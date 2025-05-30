# Declarative Deployment Planning for Green Pulverised Collective Computational Systems (DePPS)

## Presentation Layout - 20 Minutes

### 1. Introduction & Context (3 minutes)
- **Opening Hook**: "How can we make distributed systems greener while maintaining performance?"
- **Problem Statement**: 
  - IoT ecosystems and robot swarms need efficient deployment strategies
  - Current approaches lack automated deployment generation
  - Need to balance performance with environmental sustainability
- **Paper Overview**: Introducing DePPS - a Prolog-based approach for green deployment planning

### 2. Background: Pulverisation Model (4 minutes)
- **Aggregate Computing Overview**:
  - Collective adaptive systems (CAS) programming model
  - Sense-compute-interact execution rounds
- **Pulverisation Concept**:
  - Split device computation into 5 components: Sensing, Actuation, Behaviour, State, Communication
  - Components can be deployed across edge-cloud continuum
  - **Visual Aid**: Use Figure 1 from paper to show component splitting
- **Deployment Flexibility**:
  - Fully peer-to-peer vs. cloud-based vs. hybrid deployments
  - Previous work focused on comparing pre-defined deployments

### 3. Research Gap & Contribution (2 minutes)
- **The Problem**: 
  - No systematic approach to *generate* good deployment plans
  - Manual or ad-hoc deployment strategies
  - Limited consideration of environmental impact
- **Our Solution - DePPS**:
  - Declarative Prolog-based planner
  - Integration with Alchemist simulator
  - Focus on "green" deployments (low energy + carbon footprint)

### 4. DePPS Architecture & Methodology (4 minutes)
- **System Architecture**:
  - **Visual Aid**: Show Figure 2 architecture diagram
  - Alchemist simulator + SWI Prolog planner integration
  - Repeated reasoning for dynamic adaptation
- **Prolog-based Planning**:
  - Declarative knowledge representation
  - Physical devices, components, and constraints modeled as facts
  - Energy source mix and carbon intensity consideration
- **Key Features**:
  - Modularity and scalability
  - Continuous reasoning for network changes
  - Environmental footprint assessment

### 5. Implementation Details (3 minutes)
- **Knowledge Representation**:
  - `digitalDevice(DigDev, K, [S, A, B, C])`
  - `physicalDevice(N, FreeHW, TotHW, Sensors, Actuators)`
  - Energy source mix and PUE modeling
- **Placement Strategy**:
  - Heuristic approach: prioritize nodes with lower carbon intensity
  - Hardware requirements and latency constraints
  - Multi-device placement with resource tracking
- **Footprint Assessment**:
  - Energy consumption calculation based on load
  - Carbon emissions from energy source mix

### 6. Experimental Evaluation (3 minutes)
- **Setup**:
  - Synthetic smart city/swarm system
  - Variable number of devices (50-100)
  - Dynamic energy mix (sine wave pattern)
  - Two scenarios: device-only (baseline) vs. placer
- **Key Results**:
  - **Visual Aid**: Show Figures 6 & 7
  - **Energy Savings**: 3x reduction in energy consumption
  - **Carbon Footprint**: Significant reduction in CO₂ emissions
  - **Latency Trade-off**: Slight increase in intra-component latency, minimal impact on inter-device latency
  - **Scalability**: ~100ms execution time regardless of network size

### 7. Results Deep Dive (2 minutes)
- **Green Deployment Success**:
  - Device-only: 7-12 kWh energy consumption
  - DePPS: 2-3.5 kWh energy consumption
  - Adaptive carbon footprint management
- **Performance Trade-offs**:
  - Acceptable latency increases
  - Good scalability characteristics
  - Locality-preserving deployment strategy

### 8. Future Work & Conclusions (2 minutes)
- **Current Limitations & Future Directions**:
  - Continuous reasoning improvements
  - Decentralized/hierarchical placement
  - End-to-end simulation models with migration costs
- **Key Takeaways**:
  - Declarative approach enables flexible, green deployments
  - Significant environmental benefits with acceptable performance trade-offs
  - Reusable toolchain for further research
- **Impact**: Contributing to sustainable computing in distributed systems
