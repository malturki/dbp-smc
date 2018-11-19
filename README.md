# Statistical Model Checking of Distance Fraud Attacks on the Hancke-Kuhn Family of Distance-bounding Protocols

This is a formal model of the Hancke-Kuhn family of distance-bounding (DB) protocols as a probabilistic rewrite theory, focusing on the rapid bit exchange phase. 
The model is computational and generic, enabling reasoning about guessing and timing attacks in different DB protocols. Furthermore, the model is heavily 
parametrized to capture different attack behaviors and countermeasures, further adding to its generic design. Moreover, by utilizing 
different facilities provided by its underlying formalism, the model is both **probabilistic**, specifying randomized behaviors and environment 
uncertainties, and **real-time**, capturing time clocks and message transmission delays. 

*This is joint work with Max Kanovich, Tajana Ban Kirigin, Vivek Nigam, Andre Scedrov and Carolyn Talcott.*

*The technical paper describing the model, the analysis performed and analysis results appeared in [CPS-SPC'18](https://www.cps-spc.org/2018) and can be found here:*

<img src="resources/pdf-icon.png" alt="PDF" width="2%" /> *[Statistical Model Checking of Distance Fraud Attacks on the Hancke-Kuhn Family of Protocols](https://dl.acm.org/citation.cfm?doid=3264888.3264895)*

## Running Simulations

The Maude model can be used to obtain sample runs of the protocol. The model is specified in **apmaude.maude** and **dbp-timing_v2.maude**, which can be found in the **/maude-specs** directory. To run the simulations, [Maude 2.4](http://maude.cs.illinois.edu/ "Maude") or newer versions may be used. Once installed, follow the following steps:

1. Run Maude to get into its prompt `Maude>`.
2. Issue the command: `set clear rules off .` to explicitly ask Maude to maintain its state between command runs (this is necessary for pseudo-random number generation).
3. load the model files: `load apmaude.maude .` and then `load dbp-timing_v2.maude .`.
4. Use the rewrite command to obtain a sample run: `rew tick(initState) .`. The result is a configuration term that specifies the final state of the protocol session. You may repeat the command to obtain potentially different runs of the protocol.

The directory **/maude-specs** includes a Maude script named **dbp-tests.maude** that automates the steps above.


## Changing the Model Parameters

The model is heavily parameterized to enable experimenting with different setups and attack behaviors. The parameters are declared as Maude operators, and are given values using Maude equations given in the module `MODEL-PARAMS` in **dbp-timing_v2.maude**. The relevant equations are listed below:

    --- Protocol Session Parameters
    eq HASHTYPE = 0 .
    eq BBASE = 2 .
    eq ROUNDS = 35 .
    eq DEPTH = 2 .
    eq MAXRTT = 4.0 .
    eq NOISE = 0.05 .

	--- Verifier Parameters
    eq VDCLK = false .
    eq sampleX = rand2 .
    eq sampleY = rand2 .
    eq sampleZ = rand2 .
    eq CDELAY(N) = @psb(1.0) .

	--- Prover Parameters
    eq PTYPE = 1 .
    eq sampleRD = prand2 .
    eq GAHEAD = true .
    eq gATD(fH) = ag .

    --- Acceptance threshold levels
    eq MIN-MTR = all .
    eq MIN-ATR = lmr .
    eq MIN-MBR = lmr .

The module also defines other constants, such as `rand2`, `ag`, `all` and `lmr`, that make it easy to use specific quantities that are usually needed for the specification of a DB protocol. For example, constant operator `ag` evaluates to the guess-ahead time of the aggressive guess-ahead attacker. The module is well documented and explains the constants it defines.

Once the parameters are set, the steps explained in the previous section may now be used to obtain new sample runs.


## Running Statistical Model Checking Tasks

The model can be used not only to simulate DB protocols but also to statistically verify certain security properties about them, including false acceptance and false rejection probabilities. For this, we use the statistical model checking and quantitiative analysis tool [PVeStA](http://maude.cs.uiuc.edu/tools/pvesta/ "PVeStA") alongside [Maude](http://maude.cs.illinois.edu/ "Maude"). The properties to be verified are specified as temporal quantitative expressions in QuaTEx, and are fed into PVeStA (along with the Maude models) for evaluation. 

To get started, you will need to:

*  Download and install [Maude 2.4](http://maude.cs.illinois.edu/ "Maude") or newer, and have it available in your PATH (e.g. in bash: `export PATH=<path_to_the_maude_executable>:$PATH`). Maude will have to be accessible from anywhere in your terminal.
*  Download the [PVeStA](http://maude.cs.uiuc.edu/tools/pvesta/ "PVeStA") binaries (the server and client jar files). Note that PVeStA needs Java 1.6 or later installed (there is however an apparent incompatibility with Java 9).

As explained [here](http://maude.cs.uiuc.edu/tools/pvesta/usage.html "PVeStA Usage"), there are three steps for running a verification task with PVeStA:

1. Running the server executable pvesta-server.jar 
2. Creating a server-list file
3. Running the client executable pvesta-client.jar 

For simplicity, we will assume two server instances running on the same machine, and that we would like to estimate false acceptance based on correctness of response bits. Furthermore, PVeStA requires that the Maude model files and the QuaTEx formula files are all in the current directory. To initiate the verification task, follow the steps below:

1. Make a working directory `workarea` and change to it.
2. Copy the files **apmaude.maude**, **dbp-timing.maude**, **accMB.quatex** and **portlist2** to `workarea` (the current directory).
3. Run the servers using the following commands (`<pvesta-jar-files-path>` is the path to PVeStA's binaries):

      ``` 
      java -jar <pvesta-jar-files-path>/pvesta-server.jar 49046 > server1.out &
      ```

      ```
      java -jar <pvesta-jar-files-path>/pvesta-server.jar 49047 > server2.out &
      ```
      
4. Run the client using the following command:

      ```
      java -jar <pvesta-jar-files-path>/pvesta-client.jar -l portlist2 -m dbp-timing_v2.maude -f accMB.quatex -a 0.01 -d1 0.01
      ```

The last command initiates the verification task and may take a while to execute (depending on the parameters chosen for the model). Once it finishes, the result is output to the screen. The servers will continue to run in the background waiting for further requests. So, you may repeat step 4 above right away to verify other properties, or re-verify the same property but with different model parameters. Of course, sequences of verification tasks can be automated by writing appropriate scripts.


## Getting Help

For inquiries or to report problems, please contact musab.alturki [at] gmail [dot] com.

