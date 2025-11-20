# OGOP-Time-Distance-Calculator-Desktop-Version
For Newton’s equations of motion with constant acceleration, given 3 of 5 variables (V,U,A,T,S), this calculator solves for the remaining 2. 



# Newton's Equations of Motion

These Kinematics equations relate an object's displacement, s, initial velocity u, final velocity v, acceleration a, and time t

1. $v = u + at$
2. $s = ut + 0.5*at^2$
3. $v^2 = u^2 + 2as$


# Installation 
*Install Anaconda for Package management [Anaconda.org]

*Clone repo
```
git clone https://github.com/opeyemiman/OGOP-Time-Distance-Calculator.git
cd OGOP-Time-Distance-Calculator
```

*Create a Conda environment named crash_daddy
```
conda create -n crash_daddy
python -m ipykernel install --user --name crash_daddy --display-name "Python (crash_daddy)"
conda activate crash_daddy
pip install -r requirements.txt
```
*Conda pack the environment
```
conda-pack -o crash_daddy.zip
```

# Program Features

*Interactive Jupyter Widgets for input and outputs.
*This program accepts inputs of variables as a list, allowing single inputs, ranges, or lists. 
*Statistical summary and export of results as CSV


# Disclaimer
*This program is made for learning and research, and is free to all
*Errors always happen. You are responsible for cross-checking answers and ensuring consistent units
