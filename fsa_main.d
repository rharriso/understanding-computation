import std.stdio;
import std.conv;
import std.algorithm;

class FAState {
    int index;

    this (int i){
        index = i;
    }

    string inspect(){
        return "STATE: "~to!string(index);
    }
}

class FARule {
    FAState state;
    char character;
    FAState nextState;    

    this(FAState s, char c, FAState ns){
        state = s;
        character = c;
        nextState = ns;
    }

    bool appliesTo(FAState s, char c) {
        return state == s && character == c;
    }

    FAState follow(){
        return nextState;
    }

    string inspect(){
        return "<FARule "~state.inspect~" --('"~character~"')--> "~nextState.inspect;
    }
}


class DFARuleBook {
    FARule[] rules;

    FAState nextState(FAState state, char character) {
        return ruleFor(state, character).nextState;
    }

    FARule ruleFor(FAState state, char character) {
        foreach( FARule rule; rules ){
            if (rule.appliesTo(state, character)){
                return rule;
            }
        }
        throw new Exception("Couldn't find rule for "~state.inspect~" --> "~character);
    }

    void addRule (FAState state, char character, FAState nextState){
        rules ~= new FARule(state, character, nextState);
    }
}

void main(){
    auto ruleBook = new DFARuleBook;
    auto state1 = new FAState(1);
    auto state2 = new FAState(2);
    auto state3 = new FAState(3);

    ruleBook.addRule(state1, 'a', state2);
    ruleBook.addRule(state1, 'b', state1);
    ruleBook.addRule(state2, 'a', state3);
    ruleBook.addRule(state2, 'b', state2);
    ruleBook.addRule(state3, 'a', state2);
    ruleBook.addRule(state3, 'a', state2);

    writeln(ruleBook.nextState(state1, 'a').inspect);
    writeln(ruleBook.nextState(state1, 'b').inspect);
}
