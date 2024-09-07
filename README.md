# GNU Octave Circuit Simulator(Spice)

This is my implementation of a circuit simulator in Octave, I spent around a week working on this and am pleased with what it is currently.
It is based on MNA; Modified Nodal Analysis, which puts the circuit in a linear system in a matrix which allows us to solve the circuit easily and gives us the ability,
to be able to compute large circuits easily is the groundwork for popular software like MultiSim or LTSpice.

### Modified Nodal Analysis

In electrical engineering, modified nodal analysis or MNA is an extension of nodal analysis which not only determines the circuit's node voltages (as in classical nodal analysis), but also some branch currents. 


![Screenshot 2024-09-07 180336](https://github.com/user-attachments/assets/bc062000-00b8-43e4-a894-e84ae5683679)

*Source: [Modified Nodal Analysis](https://cheever.domains.swarthmore.edu/Ref/mna/MNA2.html) -Swarthmore Collage*

With systems such as these, it's much easier to solve computationally and allows us to solve much larger systems and make way for much larger devices to be developed.
The main method of automatically making the main matrix; The A matrix, is by collecting Stamps for each component and adding them up with each other, some components don't take stamps
and instead makes Branches; an extra row and a column.

### Stamps
A Stamp is a matrix that represents the component's presence in some of the system's equations and gets added at rows and columns in the A matrix to be as such.
Here's for example the stamp for a Resistor.
![Screenshot 2024-09-07 175508](https://github.com/user-attachments/assets/824b2c03-4c14-4aff-85d6-0d62edc4fe90)

*Source: [Modified Nodal Analysis Stamps](https://onlinelibrary.wiley.com/doi/pdf/10.1002/9781119078388.app2)-Willey Online Library*

However, not all components have stamp-like Resistors, some, *as previously stated*, add Branches.

![Screenshot 2024-09-07 182448](https://github.com/user-attachments/assets/752f0845-0ee1-4dff-8202-b74189bc494c)

*Source: [Modified Nodal Analysis Stamps](https://onlinelibrary.wiley.com/doi/pdf/10.1002/9781119078388.app2)-Willey Online Library*

As we see here, AUX represents the added branch, which is added once for each battery (AC or DC), and a value at the Z matrix, which is the RHS.


### The GUI

I will go a bit into how the GUI works and how you would use it to solve systems or make a netlist.

![Screenshot 2024-09-07 151850](https://github.com/user-attachments/assets/9fcb1311-a95a-4e1b-bb6d-0bc62685c577)

1. The component list, currently contains; Resistors, Independent DC Voltage and Current Sources, Independent AC Voltage sources, Capacitors, Inductors, CCCSs, VCCSs, VCVSs, and CCVSs.
2. The Value input field, takes the value for the corresponding component you picked, be it, Resistance, Capacitance, Inductance, Transconductance, and Voltage.
3. The unit list, Currently has Giga, Mega, Kilo, Base unit, Mili, Micro, Nano, and Pico.
4. The starting node list, This is the node that is a negative pole or the back side of a current source.
5. The ending node list, This is the node that is the positive pole or the head of a current source.

All of the buttons are pretty self-explanatory.


![Screenshot 2024-09-07 151946](https://github.com/user-attachments/assets/06c334c2-7b7f-4e1d-83b2-f9533137b5a9)



When choosing a dependent component, two lists will appear (6 and 7) to enter the dependent starting node and ending one, they follow the same order as the normal ones.



![Screenshot 2024-09-07 151956](https://github.com/user-attachments/assets/49f16adb-4c28-4402-9e98-5ad26eb3a106)

When choosing the AC Battery option a list and a frequency field will appear.
Here are some examples I solved on the GUI.

![Screenshot 2024-09-07 134850](https://github.com/user-attachments/assets/10d7123e-8c80-41fc-bfb8-5ca5d14d092f)
*Source: [Introduction to Design Automation](https://onlinelibrary.wiley.com/doi/pdf/10.1002/9781119078388.app2)-Prof Guoyong Shi, Shang Jiao Tong University*


![Screenshot 2024-09-07 134904](https://github.com/user-attachments/assets/f422001c-eb7d-4149-ac8f-24303a33b4a8)


![Screenshot 2024-09-07 134837](https://github.com/user-attachments/assets/f5c13343-c1e0-4319-9866-69f22ccec5c3)


And here's another that has an AC Source.

![Screenshot 2024-09-07 191855](https://github.com/user-attachments/assets/cf711a0a-0153-441e-94cf-14b10b3fe9a1)

*Source: [Modified Nodal Analysis](http://www.swarthmore.edu/NatSci/echeeve1/Ref/mna/MNA_All.html)- Swarthmore University*

![Screenshot 2024-09-07 135209](https://github.com/user-attachments/assets/fac550ca-efac-4e1f-8ef7-6d0f51bf6e7f)

![Screenshot 2024-09-07 135155](https://github.com/user-attachments/assets/f4de4ce7-35e6-4baf-9274-97237b4bffde)
