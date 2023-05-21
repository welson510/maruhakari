package schema

import "time"

type FoodTemplate struct {
	Id            string    `json:"id"`
	Name          string    `json:"name"`
	GramPerMiller *float32  `json:"gram_per_miller"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}
