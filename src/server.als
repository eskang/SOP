module Server

/**
	* Generic parts
	*/
sig Resource {}
abstract sig Module {
	reads : set Resource
}
abstract sig Msg {
	sender, receiver : Module
}

/**
	* Server
	*/
sig URL {}
sig Server extends Module {
	resMap : URL -> Resource
}

/** 
	* Client
	*/
sig Browser extends Module {
	frames : set Frame
}
sig Frame {
	script : lone Script
}
sig Script extends Module {}

/** 
	* Messages
	*/
sig HTTPReq extends Msg {
	url : URL
}{
	sender in Browser
	receiver in Server
}
sig HTTPResp extends Msg {
	res : Resource
}{
	sender in Server
	receiver in Browser
}

abstract sig APICall extends Msg {
}{
	sender in Script
	receiver in Browser
}
sig ReadDOM extends APICall {}
sig WriteDOM extends APICall {}

/**
	* Security property
	*/
sig CriticalResource in Resource {}
sig BadModule in Module {}
pred noResourceLeak {
	// No bad module should be able to read a critical resource
	no r : CriticalResource, b : BadModule | r in b.reads
}

run {
	some res 
	one Server
} for 3
