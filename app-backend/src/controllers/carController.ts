import { Request, Response } from 'express';
import Car from '../models/Cars';

export const getCars = async (req: Request, res: Response): Promise<void> => {
    try {
        const cars = await Car.find();
        console.log("Cars : ", cars);
        res.json(cars);
    } catch (error) {
        res.status(500).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};

export const createCar = async (req: Request, res: Response): Promise<void> => {
    try {
        const car = new Car(req.body);
        const savedCar = await car.save();
        res.status(201).json(savedCar);
    } catch (error) {
        res.status(400).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};


export const brandCar = async (req: Request, res: Response): Promise<void> => {
    try {
        const brand = await Car.find({ brand: req.params.brand });
        if (brand.length === 0) {
            res.status(404).json({ message: `No cars found for brand ${req.params.brand}` });
            return;
        }
        res.json(brand);
    } catch (error) {
        res.status(400).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};

export const carBrands = async (req: Request, res: Response): Promise<void> => {
    try {
        const brands = await Car.distinct('brand');
        if (brands.length === 0) {
            res.status(404).json({ message: 'No brands found' });
            return;
        }
        res.json(brands);
    } catch (error) {
        res.status(400).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};

export const favCar = async (req: Request, res: Response): Promise<void> => {
    try {
        console.log(req.params.id);
        const car = await Car.findById(req.params.id);
        console.log(car);
        if (!car) {
            res.status(404).json({ message: 'Car not found' });
            return;
        }
        car.fav = true;
        await car.save();
        console.log("After saving : ", car);
        res.json(car);
    } catch (error) {
        res.status(400).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};

export const unFavCar = async (req: Request, res: Response): Promise<void> => {
    try {
        console.log(req.params.id);
        const car = await Car.findById(req.params.id);
        console.log(car);
        if (!car) {
            res.status(404).json({ message: 'Car not found' });
            return;
        }
        car.fav = false;
        await car.save();
        console.log("After saving : ", car);
        res.json(car);
    } catch (error) {
        res.status(400).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};

export const getFavCars = async (req: Request, res: Response): Promise<void> => {
    try {
        console.log("Getting fav cars");
        const cars = await Car.find({ fav: true });
        console.log("Fav cars : ", cars);
        res.json(cars);
    } catch (error) {
        res.status(400).json({ message: error instanceof Error ? error.message : 'An error occurred' });
    }
};