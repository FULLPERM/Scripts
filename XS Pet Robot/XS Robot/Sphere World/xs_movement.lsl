// xs_movement ( for walking on a globe )
// this replaces xs_movement
// Version 0.32  12-03-2011


// added ENCRYPT global variable

/////////////////////////////////////////////////////////////////////
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike

// See http://creativecommons.org/licenses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this code but you may share this code.
// You must attribute authorship to me and leave this notice intact.
//
// Exception: I am allowing this script to be sold inside an original build.
// You are not selling the script, you are selling the build.
// Fred Beckhusen (Ferd Frederix)


// Based on code from Xundra Snowpaw
// New BSD License: http://www.opensource.org/licenses/bsd-license.php
// Copyright (c) 2010, Xundra Snowpaw
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

//* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
// in the documentationand/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////
// COPY FROM GLOBAL CONSTANTS FILE LOCATED IN Debug Folder
// INCLUDE THESE IN ALL SCRIPTS //
// XS_pet constants and names

///// GLOBAL CONSTANTS extracted from original source //////
//
// if you change any of these constants, change it everywhere and in a list in XS_Debug so it can print them
//

float VERSION = 0.28;
integer ENCRYPT = FALSE;    // set to TRUE to encrypt all data, Opensim prefers FALSE
key YOUR_UUID = "";        // if you add a UUID for your avatar here, you can change it later
                              // and other alts or friends can edit and make these pets
                              // If you leave it blank, only the creator can work on them
string Animal = "Troubot";        // was 'Quail', must be the name of your animal
string Egg = "Nut and Bolt";      // was 'XS Egg', must be the name of your egg
string Crate = "Transport UFO";   // was XS-Cryocrate
string HomeObject = "Home Flag"; // was "XS Home Object
string  SECRET_PASSWORD = "top secret robot";    // must use one unique to any animal
integer SECRET_NUMBER = 99999;             // any number thats a secret

integer MaxAge = 7;              // can get prggers in 7 days
integer UNITS_OF_FOOD = 168;     // food bowl food
float secs_to_grow = 86400;      // grow daily = 86400

// global listeners

integer FOOD_CHANNEL = -999191;
integer ANIMAL_CHANNEL = -999192;
integer EGG_CHANNEL = -999193;
integer HOME_CHANNEL = -999194;
integer BOX_CHANNEL = -999195;
integer ACC_CHANNEL = -999196;
integer UPDATE_CHANNEL = -999197;
integer API_CHANNEL = -999198;

// global prim animation linkmessages on channel 1
// these are the prim animations played for each type of possible animation

string ANI_STAND = "stand";             // default standing animation
string  ANI_WALKL   = "left";           // triggers Left foot and righrt arm walk animation
string  ANI_WALKR   = "right";          // triggers Right foot and left arm walk animation
string  ANI_SLEEP  = "sleep";           // Sleeping
string  ANI_WAVE = "wave";              // Calling for sex, needs help with food, etc.



// global link messages to control the animal
integer LINK_AGE_START = 800;      // when quail is rezzed and secret_number, is sent by brain to breeder, eater and informatic get booted up
integer LINK_FOOD_CONSUME = 900;   // from movement to brain when close to food, brain then consumes a random amount up to 10000
integer LINK_FOODMINUS = 901;    // xs_brain  receives FOOD_CONSUME, decrement hunger (eat)
integer LINK_HUNGRY = 903;        // sent by eater (string)hunger_amount, checks each hour
integer LINK_HAMOUNT = 904;       // hunger_amount = (integer)str,m updates the hunger amount in scripts
integer LINK_SET_HOME = 910;      // loc ^ dist
integer LINK_MOVER = 911;         // tell mover to rest for str seconds
integer LINK_FOODIE_CLR = 920;    // clear all food_bowl_keys and contents
integer LINK_FOODIE = 921;        // send FOOD_LOCATION coordinates to movement
integer LINK_COLOR1 = 930;             // colour1
integer LINK_COLOR2 = 931;             // colour2
integer LINK_SEX = 932;                // sex
integer LINK_SHINE = 933;              // shine
integer LINK_GLOW = 934;               // glow
integer LINK_GEN = 935;                // generation
integer LINK_RESET_SIZE = 936;          // reset size to 1
integer LINK_MAGE = 940;                // xs_brain sends, xs_ager consumes, adds str to age, if older than 7 days, will grow the animal
integer LINK_DAYTIME = 941;             // xs_ager consumes, starts a timer of 86,400 seconds in xs_ager
integer LINK_GET_AGE = 942;             // get age from xs_ager and sent it on channel 943
integer LINK_PUT_AGE = 943;             // print age from xs_ager
integer LINK_PACKAGE = 950;             // look for a cryo_crate
integer LINK_SEEK_FEMALE = 960;         // MALE_BREED_CALL
integer LINK_MALE_BREED_CALL = 961;     // triggered by LINK_SEEK_FEMALE
integer LINK_SIGNAL_ELIGIBLE = 962;     // sent by female when hears LINK_MALE_BREED_CALL
integer LINK_FEMALE_ELIGIBLE = 963;     // sent when it hears in chat FEMALE_ELIGIBLE
integer LINK_CALL_MALE = 964;           // if LINK_FEMALE_ELIGIBLE && looking_for_female
integer LINK_MALE_ON_THE_WAY = 965;     // triggered by LINK_CALL_MALE
integer LINK_FEMALE_LOCATION = 966;     // female location, sends coordinates of a female
integer LINK_RQST_BREED  = 967;         // sent when close enough to male/female
integer LINK_CALL_MALE_INFO = 968;      // sent by xs_breeding, this line of code was in error in v.24 of xs_breeding see line 557 and 636 of xs_brain which make calls and also xs_breeding which receives LINK_MALE_INFO.
integer LINK_MALE_INFO = 969;
integer LINK_LAY_EGG = 970;             // llRezObject("XS Egg"
integer LINK_BREED_FAIL = 971;          // key = father, failed, timed out
integer LINK_PREGNANT = 972;            // chick is preggers
integer LINK_SOUND_OFF= 974;             // sound is off
integer LINK_SOUND_ON= 973;             // sound is on
integer LINK_SLEEPING = 990;            // close eyes
integer LINK_UNSLEEPING = 991;          // open eyes
integer LINK_SOUND = 1001;              // plays a sound if enabled
integer LINK_SPECIAL = 1010;            // xs_special, is str = "Normal", removes script
integer LINK_PREGNANCY_TIME = 5000;    // in seconds as str
integer LINK_SLEEP = 7999;              // disable sleep by parameter
integer LINK_TIMER = 8000;              // scan for food bowl about every 1800 seconds
integer LINK_DIE = 9999;                // death


///////// end global Link constants ////////


///////////// END OF COPIED CODE ////////////




float GROWTH_AMOUNT = 0.10;

vector home_location;
float roam_distance;
list food_bowls;
list food_bowl_keys;
list food_bowl_time;

vector destination;

integer sex_dest = 0;
integer food_dest = 0;
float tolerance = 0.15;
float increment = 0.1;
integer rest;
integer age;
float zoffset;
integer sleep_last_check ;
integer sound_on;
integer sleep_disabled;


//new mover on a sphere
float RADIUS = 1.0;
rotation gOrient;
list gSilly_walks;
integer gCounter;



GetNewPos()
{
    // start over and calc a new walk

    gSilly_walks = [];


    float x = llFrand(5) + 5;

    float y = llFrand(5) + 5;

    float z = llFrand(5) + 5;

    if (llFrand(2) > 1)
        x = 1-x;
    if (llFrand(2) > 1)
        y = 1-z;
    if (llFrand(2) > 1)
        z = 1-z;


    rotation delta = llEuler2Rot(<x,y,z> * DEG_TO_RAD);

    integer STEPS = llCeil( llFrand(10)) + 1;
    integer i;
    for (i = 0; i < STEPS; i++)
    {
        vector unitpos = llRot2Fwd( gOrient );
        vector pos = home_location + unitpos * RADIUS;

        gSilly_walks += pos;
        gSilly_walks += gOrient;

        gOrient = gOrient * delta;
    }



}




face_target(vector lookat) {

     rotation rot = llGetRot() * llRotBetween(<1.0 ,0.0 ,0.0 > * llGetRot(), lookat - llGetPos());


    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WALKL, "");
    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WALKR, "");

//    vector nine = <180,0,0> * DEG_TO_RAD;
//    rotation new = llEuler2Rot(nine);


    llSetRot(rot);
    llSleep(.1);

    rot = llGetRot() * llRotBetween(<0.0 ,0.0 ,1.0 > * llGetRot(), home_location - llGetPos());
    llSetRot(rot);
}

integer sleeping()
{
    vector sun = llGetSunDirection();
    if (!sleep_disabled) {
        if (sun.z < 0) {
            if (sleep_last_check == 0) {
                // close eyes
                llMessageLinked(LINK_SET, LINK_SLEEPING, "", "");
                llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_SLEEP, "");
            }
            sleep_last_check = 1;
        } else {
                if (sleep_last_check == 1) {
                    // open eyes
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    llMessageLinked(LINK_SET, LINK_UNSLEEPING, "", "");
                }
            sleep_last_check = 0;
        }
        return sleep_last_check;
    } else {
            if (sleep_last_check == 1) {
                llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                llMessageLinked(LINK_SET, LINK_UNSLEEPING, "", "");
                sleep_last_check = 0;
            }
        return 0;
    }
}

default
{
    link_message(integer sender, integer num, string str, key id)
    {
        //llOwnerSay((string)num + "^" + (string)str);
        if (num == LINK_AGE_START) {
            state running;
        }
    }
}

state running
{
    state_entry()
    {
        gOrient = ZERO_ROTATION;
        home_location = <0,0,0>;
        roam_distance = 0;
        destination = <0,0,0>;
        age = 0;
        sleep_last_check = 0;
        sound_on = 1;
    }


    timer()
    {


        if (!sleeping())
        {
            if (sound_on) {
                llMessageLinked(LINK_SET, LINK_SOUND, "", "");
            }
            sound_on = !sound_on;

            if (rest >  0) {
               // llSetText((string) rest,<1,0,0>,1);
                rest--;
                return;
            }

            if (llVecDist( destination, llGetPos()) <= tolerance || destination == <0,0,0>)
            {
                // if at food_destination send 900 msg
                if (food_dest > 0) {
                    llMessageLinked(LINK_SET, LINK_FOOD_CONSUME, (string)food_dest, llList2Key(food_bowl_keys, 0));
                }

                if (sex_dest > 0) {

                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    llMessageLinked(LINK_SET, LINK_RQST_BREED, "", "");

                }
                // pick a new destination
                sex_dest = 0;
                food_dest = 0;

            }


            integer walkLength = llGetListLength(gSilly_walks);
            if ( walkLength > 0)
            {
                vector pos = llList2Vector(gSilly_walks,0);
                rotation  orient = llList2Rot(gSilly_walks,1);

                gCounter++;
                face_target(pos);
                llSetPos(pos);



               //llSetRot(orient);

                gSilly_walks = llDeleteSubList(gSilly_walks,0,1);                  // we have walked in those shoes
            }
            else
            {
                GetNewPos();

                rest = (integer)llFrand(12.0);      // 1 minute rest
                //llOwnerSay("resting for " + (string) rest);
            }

            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WALKL, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WALKR, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");

        }
    }

    link_message(integer sender, integer num, string str, key id)
    {


       // llOwnerSay((string)num + "^" + (string)str);



        if (num == LINK_HUNGRY) {
            if (sex_dest == 0) {
                // move to food bowl, then send 900
                if (llGetListLength(food_bowl_keys) > 0) {
                    if (roam_distance == 0 || home_location == <0,0,0>) {
                        llOwnerSay("I'm hungry, but I'm not homed so I can not move! Attempting to use Jedi Mind Powers to teleport food to my belly.");
                        llMessageLinked(LINK_SET, LINK_FOOD_CONSUME, str, llList2Key(food_bowl_keys, 0));
                        llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                        llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
                        llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    } else {
                            // find nearest food bowl
                            integer i;
                        destination = (vector)llList2String(food_bowls, 0);
                        for (i=1;i<llGetListLength(food_bowls);i++) {
                            if (llVecDist(destination, llGetPos()) > llVecDist((vector)llList2String(food_bowls, i), llGetPos())) {
                                destination = (vector)llList2String(food_bowls, i);
                            }
                        }
                        destination.z = home_location.z + zoffset;
                        // set destination,
                        // face it
                        face_target(destination);
                        food_dest = (integer)str;
                        rest = 0;
                        //llMessageLinked(LINK_SET, LINK_FOOD_CONSUME, str, llList2Key(food_bowl_keys, 0));
                    }
                } else {
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    llOwnerSay("I'm hungry, but I can't seem to find any food bowls at present.");
                }
            }
        } else
        if (num == LINK_SET_HOME) {
            list values = llParseString2List(str, ["^"], []);
            home_location = (vector)llList2String(values, 0);
            RADIUS = llList2Float(values, 1)/2;

            //llOwnerSay("location:" + (string) home_location + "   " + "distance:" + (string) roam_distance);


            vector current_loc = llGetPos();

            food_bowls = [];
            food_bowl_keys = [];
            food_bowl_time = [];

            destination = <0,0,0>;
            food_dest = 0;
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");

            GetNewPos();
            llSetTimerEvent(4.0);

            llOwnerSay("Homed");

        } else
        if (num == LINK_MOVER) {
            if (rest < (integer)str) {
                rest = (integer)str;
            }
        } else
        if (num == LINK_FOODIE_CLR) {
            food_bowls = [];
            food_bowl_keys = [];
            food_bowl_time = [];
        } else
        if (num == LINK_FOODIE) {
            vector food_loc = (vector)str;

            if (llVecDist(home_location, food_loc) <= roam_distance && llFabs(llFabs(home_location.z) - llFabs(food_loc.z)) < 2) {
                if(llListFindList(food_bowls, (list)str) == -1) {
                    integer id_pos = llListFindList(food_bowl_keys, (list)id);
                    if (id_pos == -1) {
                        food_bowls += str;
                        food_bowl_keys += id;
                        food_bowl_time += llGetUnixTime();
                    } else {
                            food_bowls = llListReplaceList(food_bowls, [str], id_pos, id_pos);
                        food_bowl_time  = llListReplaceList(food_bowl_time, [llGetUnixTime()], id_pos, id_pos);
                    }
                }

                integer iter;

                iter = 0;

                while(iter<llGetListLength(food_bowls)) {
                    if (llGetUnixTime() - llList2Integer(food_bowl_time, iter) > 3600) {//3600
                        food_bowls = llDeleteSubList(food_bowls, iter, iter);
                        food_bowl_keys = llDeleteSubList(food_bowl_keys, iter, iter);
                        food_bowl_time = llDeleteSubList(food_bowl_time, iter, iter);
                    } else {
                            iter++;
                    }
                }

                if (llGetListLength(food_bowls) > 0) {
                    llMessageLinked(LINK_SET, LINK_TIMER, "", "");
                }

            }
        } else
        if (num == LINK_FEMALE_LOCATION) {
            destination = (vector)str;
            face_target(destination);
            rest = 0;
            food_dest = 0;
            sex_dest = 1;
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
        } else
        if (num == LINK_MAGE) {
            integer heightm;
            age += (integer)str;
            heightm = age;

            if (heightm > MaxAge)
                heightm = MaxAge;
            float new_scale = (GROWTH_AMOUNT * heightm) + 1.0;

            float legsz = LegLength * new_scale;
            float legso = LegOffset * new_scale;

            zoffset = 0 ;// no offset
        } else
        if (num == LINK_SLEEP) {
            sleep_disabled = (integer)str;
        }
    }
}


