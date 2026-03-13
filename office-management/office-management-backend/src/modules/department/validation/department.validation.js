const createDepartmentSchema = {
 body:{
  name:{
   required:true,
   type:"string",
   trim:true,
   minLength:2,
   maxLength:100
  },
  description:{
   type:"string",
   trim:true,
   maxLength:250
  }
 }
}

const updateDepartmentSchema = {
 body:{
  name:{
   required:true,
   type:"string",
   trim:true,
   minLength:2,
   maxLength:100
  },
  description:{
   type:"string",
   trim:true,
   maxLength:250
  }
 }
}

module.exports = {
 createDepartmentSchema,
 updateDepartmentSchema
}
