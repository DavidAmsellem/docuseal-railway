# Railway Deployment Configuration

Este documento describe la configuración específica para desplegar DocuSeal en Railway.

## Variables de Entorno Requeridas

### Variables Configuradas Actualmente ✅
- `RAILS_ENV=production` ✅
- `SECRET_KEY_BASE=[CONFIGURADO]` ✅

### Variables Adicionales NECESARIAS para Resolver el Error de PORT

Para resolver el error `bad URI (is not URI?): "tcp://0.0.0.0:$PORT"`, agrega estas variables:

**OBLIGATORIA:**
```
USE_SIMPLE_PUMA=true
```

**RECOMENDADAS:**
```
FORCE_SSL=true
RAILWAY_DEBUG=true
```

### Cómo Agregar Variables en Railway

1. Ve a tu proyecto en Railway
2. Haz clic en la pestaña "Variables"
3. Agrega cada variable:
   - Nombre: `USE_SIMPLE_PUMA`
   - Valor: `true`
4. Guarda y redeploy

## Resolución del Problema Actual

El error que estás experimentando se debe a que la variable `PORT` no se está expandiendo correctamente. La solución implementada:

1. **Configuración automática**: Detecta y corrige variables problemáticas
2. **Configuración simplificada**: `USE_SIMPLE_PUMA=true` activa un modo más robusto
3. **Debugging mejorado**: `RAILWAY_DEBUG=true` muestra información detallada en logs

## Archivos Modificados para la Solución

- `config/puma.rb` - Configuración principal con validación de PORT
- `config/puma_simple.rb` - Configuración simplificada como fallback
- `config/railway.rb` - Configuración específica de Railway con debugging
- `bin/start_production` - Script de inicio con manejo de errores
- `Procfile.railway` - Configuración optimizada para Railway

## Después del Deploy Exitoso

Una vez que la aplicación funcione correctamente:

1. Puedes remover `RAILWAY_DEBUG=true` para reducir logs
2. `USE_SIMPLE_PUMA=true` puede mantenerse para estabilidad

## Verificación

Después de agregar las variables y redeploy, deberías ver en los logs:

```
=== Railway Deployment Configuration ===
RAILS_ENV: production
PORT: [NÚMERO]
USE_SIMPLE_PUMA: true
DATABASE_URL: [SET]
SECRET_KEY_BASE: [SET]
====================================
Using simplified Puma configuration
Puma binding to 0.0.0.0:[PORT] in production environment
```
