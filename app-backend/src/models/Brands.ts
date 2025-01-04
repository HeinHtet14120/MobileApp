// src/models/Brand.ts
import mongoose, { Document, Schema } from 'mongoose';

export interface IBrand extends Document {
  name: string;
  logo: string;
  description: string;
}

const brandSchema: Schema = new Schema({
  name: { 
    type: String, 
    required: true,
    unique: true 
  },
  logo: { 
    type: String, 
    required: true 
  },
  description: { 
    type: String, 
    required: true 
  }
});

export default mongoose.model<IBrand>('Brand', brandSchema);