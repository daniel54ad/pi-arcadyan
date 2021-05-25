#include <iostream>
#include "MQTTClient.h"
using namespace std;

#define ADDRESS     "tcp://54.157.155.150"
#define CLIENTID    "Daniel"
#define TOPIC       "Try/MQTT"
#define QOS         1

MQTTClient_deliveryToken deliveredtoken;

void delivered(void *context, MQTTClient_deliveryToken dt) {
    printf("Message with token value %d delivery confirmed\n\n", dt);
    fflush(stdout);
    deliveredtoken = dt;
}
int msgarrvd(void *context, char *topicName, int topicLen, MQTTClient_message *message) {
    int i;
    char* payloadptr;
    printf("Message arrived\n");
    printf("     topic: %s\n", topicName);
    printf("   message: ");
    payloadptr = (char*)message->payload;
    for(i=0; i<message->payloadlen; i++) {
        putchar(*payloadptr++);
    }
    putchar('\n');
    fflush(stdout);
    MQTTClient_freeMessage(&message);
    MQTTClient_free(topicName);
    return 1;
}
void connlost(void *context, char *cause) {
    printf("\nConnection lost\n");
    printf("     cause: %s\n\n", cause);
    fflush(stdout);
}

int main(int argc, char* argv[]){
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;
    int ch;

    MQTTClient_create(&client, ADDRESS, CLIENTID, MQTTCLIENT_PERSISTENCE_NONE, NULL); 
    conn_opts.keepAliveInterval = 60;
    conn_opts.cleansession = 0;
    MQTTClient_setCallbacks(client, NULL, connlost, msgarrvd, delivered);

    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS) {
        printf("Failed to connect, return code %d\n", rc);
        fflush(stdout);
        exit(EXIT_FAILURE);
    }

    // printf("Subscribing to topic %s\n"
    //        "For client %s using QoS%d\n"
    //        "Press Q<Enter> to quit\n"
    //        "====================================================\n", TOPIC, CLIENTID, QOS);
    // fflush(stdout);

    MQTTClient_subscribe(client, TOPIC, QOS);

    // do {
    //     ch = getchar();
    // } while(ch!='Q' && ch != 'q');
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    
    return rc;
}
