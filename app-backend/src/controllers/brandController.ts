// src/controllers/brandController.ts
import { Request, Response } from 'express';
import Brand from '../models/Brands';

export const getBrands = async (req: Request, res: Response): Promise<void> => {
    try {
        const brands = await Brand.find();
        res.json(brands);
    } catch (error) {
        res.status(500).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};

export const createBrand = async (req: Request, res: Response): Promise<void> => {
    try {
        const brand = new Brand(req.body);
        const savedBrand = await brand.save();
        res.status(201).json(savedBrand);
    } catch (error) {
        res.status(400).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};

export const getBrandById = async (req: Request, res: Response): Promise<void> => {
    try {
        const brand = await Brand.findById(req.params.id);
        if (!brand) {
            res.status(404).json({ message: 'Brand not found' });
            return;
        }
        res.json(brand);
    } catch (error) {
        res.status(400).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};