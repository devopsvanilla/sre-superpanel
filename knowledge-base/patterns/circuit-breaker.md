# Circuit Breaker Pattern

Padrão de design para prevenir falhas em cascata em sistemas distribuídos.

## 🎯 Problema

Em sistemas distribuídos, quando um serviço dependente falha ou fica lento:

1. Requisições continuam sendo enviadas
2. Threads/recursos ficam bloqueados esperando
3. Sistema todo pode degradar
4. **Falha em cascata** afeta todos os serviços

**Exemplo**:
```
API Gateway → User Service → Database
                              ↓ (lento/falha)
                              ❌
                              
Resultado: API Gateway fica lento esperando User Service
          que está esperando Database
```

## 💡 Solução

O Circuit Breaker atua como um disjuntor elétrico:

### Estados do Circuit Breaker

```
┌─────────┐
│  CLOSED │ ← Estado normal, tráfego passa
└────┬────┘
     │ (muitas falhas)
     ↓
┌─────────┐
│  OPEN   │ ← Falha rápida, não tenta chamar serviço
└────┬────┘
     │ (timeout)
     ↓
┌──────────┐
│ HALF-OPEN│ ← Testa se serviço recuperou
└────┬────┘
     │
     ↓
(sucesso → CLOSED | falha → OPEN)
```

### Funcionamento

1. **CLOSED** (Normal):
   - Requisições passam normalmente
   - Conta falhas consecutivas
   - Se falhas > threshold → OPEN

2. **OPEN** (Falhando):
   - Rejeita requisições imediatamente
   - Retorna erro ou fallback
   - Após timeout → HALF-OPEN

3. **HALF-OPEN** (Testando):
   - Permite algumas requisições teste
   - Se sucesso → CLOSED
   - Se falha → OPEN novamente

## 🔧 Implementação

### Python com `pybreaker`

```python
from pybreaker import CircuitBreaker

# Configuração
db_breaker = CircuitBreaker(
    fail_max=5,           # Abre após 5 falhas
    timeout_duration=60,  # Testa após 60 segundos
    name='database'
)

# Uso
@db_breaker
def get_user_from_db(user_id):
    """Se DB falhar 5 vezes, circuit abre"""
    return db.query(f"SELECT * FROM users WHERE id={user_id}")

# Com fallback
def get_user(user_id):
    try:
        return get_user_from_db(user_id)
    except CircuitBreakerError:
        # Fallback: cache ou resposta padrão
        return get_user_from_cache(user_id)
```

### Java com Resilience4j

```java
import io.github.resilience4j.circuitbreaker.CircuitBreaker;
import io.github.resilience4j.circuitbreaker.CircuitBreakerConfig;
import io.github.resilience4j.circuitbreaker.CircuitBreakerRegistry;

// Configuração
CircuitBreakerConfig config = CircuitBreakerConfig.custom()
    .failureRateThreshold(50)                    // 50% falhas
    .waitDurationInOpenState(Duration.ofSeconds(60))
    .slidingWindowSize(10)                       // Últimas 10 chamadas
    .build();

CircuitBreakerRegistry registry = CircuitBreakerRegistry.of(config);
CircuitBreaker circuitBreaker = registry.circuitBreaker("userService");

// Uso
Supplier<User> decoratedSupplier = CircuitBreaker
    .decorateSupplier(circuitBreaker, () -> userService.getUser(userId));

try {
    User user = decoratedSupplier.get();
} catch (Exception e) {
    // Fallback
    user = getUserFromCache(userId);
}
```

### Go com `gobreaker`

```go
import (
    "github.com/sony/gobreaker"
    "time"
)

// Configuração
var cb *gobreaker.CircuitBreaker

func init() {
    settings := gobreaker.Settings{
        Name:        "UserService",
        MaxRequests: 3,              // HALF-OPEN: max 3 requests
        Interval:    time.Second,    // Reseta contadores a cada 1s
        Timeout:     60 * time.Second, // OPEN → HALF-OPEN após 60s
        ReadyToTrip: func(counts gobreaker.Counts) bool {
            failureRatio := float64(counts.TotalFailures) / float64(counts.Requests)
            return counts.Requests >= 3 && failureRatio >= 0.6
        },
    }
    cb = gobreaker.NewCircuitBreaker(settings)
}

// Uso
func GetUser(userID string) (*User, error) {
    result, err := cb.Execute(func() (interface{}, error) {
        return userService.GetUser(userID)
    })
    
    if err != nil {
        // Fallback
        return getUserFromCache(userID)
    }
    
    return result.(*User), nil
}
```

### JavaScript/TypeScript com Opossum

```typescript
import CircuitBreaker from 'opossum';

// Função a proteger
async function fetchUser(userId: string): Promise<User> {
    const response = await fetch(`https://api.example.com/users/${userId}`);
    if (!response.ok) throw new Error('Failed to fetch user');
    return response.json();
}

// Circuit Breaker
const options = {
    timeout: 3000,           // 3s timeout
    errorThresholdPercentage: 50, // 50% de erros
    resetTimeout: 30000      // 30s em OPEN
};

const breaker = new CircuitBreaker(fetchUser, options);

// Fallback
breaker.fallback((userId: string) => {
    console.log('Circuit open, using cache');
    return getUserFromCache(userId);
});

// Eventos
breaker.on('open', () => console.log('Circuit opened!'));
breaker.on('halfOpen', () => console.log('Circuit half-open, testing...'));
breaker.on('close', () => console.log('Circuit closed, back to normal'));

// Uso
async function getUser(userId: string): Promise<User> {
    return breaker.fire(userId);
}
```

## ⚙️ Configuração

### Parâmetros Importantes

| Parâmetro | Descrição | Valor Típico |
|-----------|-----------|--------------|
| **Failure Threshold** | Quantas falhas para abrir | 5-10 falhas ou 50% de erro |
| **Timeout** | Quanto tempo em OPEN | 30-60 segundos |
| **Success Threshold** | Sucessos para fechar de HALF-OPEN | 2-5 sucessos |
| **Window Size** | Tamanho da janela de medição | 10-100 requisições |

### Calibragem

```python
# Início: Conservador
CircuitBreaker(
    fail_max=10,          # Tolera mais falhas
    timeout_duration=30,  # Testa rapidamente
)

# Após análise: Ajustar
CircuitBreaker(
    fail_max=5,           # Mais sensível
    timeout_duration=60,  # Espera mais para testar
)
```

## 📊 Monitoramento

### Métricas Essenciais

```promql
# Estado do circuit breaker
circuit_breaker_state{name="user_service"} 
# 0=closed, 1=open, 2=half-open

# Taxa de requisições bloqueadas
rate(circuit_breaker_rejected_total[5m])

# Falhas detectadas
rate(circuit_breaker_failures_total[5m])

# Sucessos em half-open
rate(circuit_breaker_success_total{state="half_open"}[5m])
```

### Dashboard Recomendado

1. **Estado Atual**: Gauge mostrando estado
2. **Transições de Estado**: Timeline de mudanças
3. **Taxa de Rejeição**: % de requisições rejeitadas
4. **Latência do Serviço**: Correlacionar com estado

### Alertas

```yaml
# Circuit breaker aberto
- alert: CircuitBreakerOpen
  expr: circuit_breaker_state == 1
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Circuit breaker {{ $labels.name }} está aberto"
    description: "Serviço downstream pode estar com problemas"
    
# Alta taxa de rejeição
- alert: HighCircuitBreakerRejection
  expr: |
    rate(circuit_breaker_rejected_total[5m]) 
    / rate(circuit_breaker_requests_total[5m]) > 0.1
  for: 5m
  labels:
    severity: warning
```

## ✅ Boas Práticas

### 1. Use Fallbacks

```python
@circuit_breaker
def get_recommendations(user_id):
    return ml_service.get_recommendations(user_id)

def get_recommendations_safe(user_id):
    try:
        return get_recommendations(user_id)
    except CircuitBreakerError:
        # Fallbacks em ordem de preferência
        # 1. Cache
        cached = redis.get(f"rec:{user_id}")
        if cached:
            return cached
        
        # 2. Resposta padrão
        return get_popular_items()
```

### 2. Combine com Retry

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@circuit_breaker
@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=1, max=10)
)
def call_external_api():
    return api.call()
```

### 3. Circuit Breaker por Endpoint

```python
# Não: Um CB para todo o serviço
service_breaker = CircuitBreaker()

# Sim: CB por endpoint/operação
get_user_breaker = CircuitBreaker(name='get_user')
create_order_breaker = CircuitBreaker(name='create_order')
```

### 4. Configure Timeouts

```python
@circuit_breaker
def call_service():
    # Sempre use timeout!
    response = requests.get(
        'http://service.com/api',
        timeout=2  # 2 segundos
    )
    return response.json()
```

## 🚫 Anti-Patterns

❌ **Não faça**:

1. **Circuit Breaker sem Fallback**
   ```python
   # Ruim: Usuário vê erro
   @circuit_breaker
   def get_data():
       return service.fetch()
   ```

2. **Threshold muito alto**
   ```python
   # Ruim: Precisa 100 falhas para abrir
   CircuitBreaker(fail_max=100)
   ```

3. **Timeout muito curto**
   ```python
   # Ruim: Abre e fecha constantemente
   CircuitBreaker(timeout_duration=1)
   ```

4. **Ignorar estado do CB**
   ```python
   # Ruim: Não age diferente quando aberto
   try:
       data = get_data()
   except:
       raise  # Só repassa erro
   ```

## 🔄 Padrões Complementares

### 1. Bulkhead

Isola recursos para diferentes operações:

```python
# Pool de conexões separado por operação
read_pool = ConnectionPool(max_size=50)
write_pool = ConnectionPool(max_size=10)

# Se writes falharem, reads não afetados
```

### 2. Timeout

```python
@timeout(seconds=5)
@circuit_breaker
def call_service():
    return service.call()
```

### 3. Rate Limiting

```python
from ratelimit import limits

@limits(calls=100, period=60)  # 100 req/min
@circuit_breaker
def call_api():
    return api.call()
```

## 📚 Referências

- [Martin Fowler - Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html)
- [Microsoft - Circuit Breaker Pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker)
- [Netflix Hystrix](https://github.com/Netflix/Hystrix/wiki)
- [Resilience4j Documentation](https://resilience4j.readme.io/)

## 🎓 Quando Usar

✅ **Use Circuit Breaker quando**:
- Chamar serviços externos/não confiáveis
- Latência alta é inaceitável
- Falhas podem degradar todo sistema
- Você tem estratégia de fallback

❌ **Não use quando**:
- Serviço é síncrono e crítico (sem fallback)
- Latência extra não é aceitável
- Serviço já tem retry próprio adequado

---

**Circuit Breakers são essenciais para sistemas resilientes e fault-tolerant!** 🔌✨
