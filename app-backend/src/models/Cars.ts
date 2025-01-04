// src/models/Car.ts
import mongoose, { Document, Schema } from 'mongoose';
import { IBrand } from './Brands';

export interface ICar extends Document {
  name: string;
  brand: string;
  detail: string;
  coverimage: string;
  price: string;
  engine: string;
  rating: number;
  fav: boolean;
}

const carSchema: Schema = new Schema({
  name: { 
    type: String, 
    required: true 
  },
  brand: { 
    type: String, 
    required: true 
  },
  detail: { 
    type: String, 
    required: true 
  },
  coverimage: { 
    type: String, 
    required: true 
  },
  price: { 
    type: String, 
    required: true 
  },
  engine: { 
    type: String, 
    required: true 
  },
  rating: { 
    type: Number, 
    required: true 
  },
  fav: { 
    type: Boolean, 
    required: false,
    default: false
  }
});

export default mongoose.model<ICar>('Car', carSchema);