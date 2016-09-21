#version 150
#extension GL_ARB_explicit_attrib_location : enable

// shadow vertex shader

layout (location = 0) in vec3 clientPosition;

uniform mat4 clientMVP;
uniform samplerBuffer clientShapeShifter;

vec3 rotateQuat( vec4 q, vec3 v ){ 
	return v + 2.0 * cross(q.xyz, cross(q.xyz ,v) + q.w*v); 
} 

void main()
{
    vec3 workPosition = vec3(0,0,0);
    
    int vsId = gl_VertexID;
    int descriptionPosition = int(texelFetch(clientShapeShifter, vsId * 2 ).r);
    int descriptionLength   = int(texelFetch(clientShapeShifter, vsId * 2 + 1 ).r);
    
    vec3 loc = vec3(0,0,0);
    vec3 target = vec3(0,0,0);
    vec4 quat = vec4(0, 0, 0, 0); 
    
    
    for(int i = 0; i < descriptionLength; i++ ) {
        
        int jointAdress = int(texelFetch(clientShapeShifter, descriptionPosition + (i * 2)).r); 
        float jointBlend = texelFetch(clientShapeShifter, descriptionPosition + (i * 2) + 1).r; 
        
        loc.x = texelFetch(clientShapeShifter, jointAdress).r;
        loc.y = texelFetch(clientShapeShifter, jointAdress + 1).r;
        loc.z = texelFetch(clientShapeShifter, jointAdress + 2).r;
        
        quat.x = texelFetch(clientShapeShifter, jointAdress + 3).r;
        quat.y = texelFetch(clientShapeShifter, jointAdress + 4).r;
        quat.z = texelFetch(clientShapeShifter, jointAdress + 5).r;
        quat.w = texelFetch(clientShapeShifter, jointAdress + 6).r;
        
        target.x = texelFetch(clientShapeShifter, jointAdress + 7).r;
        target.y = texelFetch(clientShapeShifter, jointAdress + 8).r;
        target.z = texelFetch(clientShapeShifter, jointAdress + 9).r;
        
        vec3 operatePos = clientPosition - loc;
        operatePos = rotateQuat(quat,operatePos);
        operatePos = (operatePos + target ) * jointBlend; 
        
        workPosition += operatePos; 
    }  
    
    
    gl_Position = clientMVP * vec4(workPosition, 1.0);
}