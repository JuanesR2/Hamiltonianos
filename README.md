# 🌍 Simulación de un Sistema Dinámico No Lineal Basado en Energía

Este documento describe la implementación en Python de un sistema dinámico no lineal modelado con una estructura tipo **Hamiltoniana disipada**, comúnmente utilizada en el análisis de sistemas eléctricos, especialmente en **máquinas síncronas**, **convertidores de potencia**, y **microredes**. La simulación nos permite observar la evolución temporal de variables de estado relevantes como la velocidad angular y el ángulo eléctrico.

---

## 🎯 Objetivo

Simular la evolución temporal de un sistema no lineal con estructura energética del tipo:

\[
\dot{x} = (J - R) \nabla H(x) + u_{\text{ext}}
\]

Donde:
- \( H(x) \) es una función de energía (Hamiltoniana),
- \( J \) es una matriz antisimétrica (interconexión),
- \( R \) es una matriz simétrica semidefinida positiva (disipación),
- \( u_{\text{ext}} \) representa entradas externas, como potencia mecánica.

Este modelo es útil para estudiar el comportamiento dinámico de generadores síncronos y convertidores conectados a la red, bajo perturbaciones o controladores no lineales.

---

## ⚙️ Dinámica del Sistema

El sistema tiene dos variables de estado:
- \( x_1 \): proporcional a la velocidad angular (relativa o en p.u.).
- \( x_2 \): ángulo eléctrico.

Se define la función gradiente de la energía como:

\[
\nabla H(x) = 
\begin{bmatrix}
\frac{\omega_{\text{base}}}{M} x_1 \\
P_{\max} \sin(x_2)
\end{bmatrix}
\]

Donde:
- \( \omega_{\text{base}} = 2\pi \cdot 60 \) rad/s es la frecuencia base,
- \( M \) es el parámetro de inercia,
- \( P_{\max} \) representa la máxima potencia activa que puede transferirse,
- \( P_m \) es la potencia mecánica de entrada (fuente constante).

La matriz de interconexión y disipación:

\[
J = \begin{bmatrix}
0 & -1 \\
1 & 0
\end{bmatrix}, \quad
R = \begin{bmatrix}
0.3 & 0 \\
0 & 0
\end{bmatrix}
\]

Finalmente, la ecuación completa queda:

\[
\dot{x} = (J - R) \nabla H(x) + 
\begin{bmatrix}
0 \\
P_m
\end{bmatrix}
\]

Este sistema representa el **modelo dinámico simplificado de una máquina síncrona** con entrada mecánica constante y disipación en la velocidad.

---

## 🧪 Simulación

La simulación se realiza sobre un intervalo equivalente a **100 ciclos de red (a 60 Hz)**:

```python
nt = 100
t_span = (0.0, nt * (1/60))
```

Se parte de una condición inicial:

```python
x_ini = [0.9, 0.8]
```

Y se integra el sistema utilizando el método de Runge-Kutta de orden 4-5 (`RK45`) de la función `solve_ivp`.

---

## 📈 Resultados

Se grafica la evolución de las variables de estado en el tiempo:

- `x₁(t)` representa la dinámica de la velocidad angular.
- `x₂(t)` representa la evolución del ángulo eléctrico.

La figura muestra cómo el sistema evoluciona hacia una condición de equilibrio (si existe) o cómo se comporta bajo la influencia de la entrada constante y la disipación.

---

## 🔍 Interpretación Física

Este tipo de modelo es muy útil para:
- Estudiar la **respuesta transitoria** de un generador cuando se conecta a una carga o red.
- Diseñar **controladores no lineales basados en energía**, como control pasivo o control por interconexión y asignación de energía (IDA-PBC).
- Validar esquemas de sincronización o despacho en entornos simulados de **microrredes** o sistemas de generación distribuida.

---

## 🧠 Conclusión

Este ejemplo muestra cómo construir un sistema físico con estructura energética, modelarlo numéricamente y simular su comportamiento. Además de ser una excelente herramienta didáctica, permite avanzar hacia implementaciones más complejas, como modelos multi-máquina, controladores embebidos o validación experimental de estrategias de control.
