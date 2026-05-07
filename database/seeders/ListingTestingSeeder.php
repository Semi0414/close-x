<?php

namespace Database\Seeders;

use App\Models\Agency;
use App\Models\BrokerProfile;
use App\Models\Listing;
use App\Models\ListingDetail;
use App\Models\ListingMedia;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class ListingTestingSeeder extends Seeder
{
    public function run()
    {
        $now = Carbon::now();
        $passwordHash = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi';

        // Helper to create/get agency + user + broker profile
        $upsertBroker = function (string $agencyName, string $userName, string $email, ?string $companyName) use ($passwordHash) {
            $agency = Agency::updateOrCreate(
                ['name' => $agencyName],
                []
            );

            $user = User::firstOrCreate(
                ['email' => $email],
                [
                    'name' => $userName,
                    'password' => $passwordHash,
                ]
            );

            // Ensure basic fields are aligned (firstOrCreate only sets on create)
            $user->name = $userName;
            $user->password = $passwordHash;
            $user->email_verified_at = Carbon::now();
            $user->remember_token = $user->remember_token ?: Str::random(10);
            $user->save();

            $user->agency()->associate($agency)->save();

            BrokerProfile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'company_name' => $companyName,
                    'verified' => true,
                    'is_active' => true,
                    'show_whatsapp' => true,
                    'experience_years' => 5,
                ]
            );

            return $user;
        };

        $users = [
            'sarah' => $upsertBroker('SKYLINE REALTY', 'Sarah Jenkins', 'sarah@example.com', 'Palm Luxury Estates'),
            'ahmed' => $upsertBroker('ELITE PROPERTIES', 'Ahmed Khan', 'ahmed@example.com', 'Downtown Specialists'),
            'maria' => $upsertBroker('NEXTGEN HOMES', 'Maria Lee', 'maria@example.com', 'NextGen Homes'),
            'lynn' => $upsertBroker('RENTAL SPECIALISTS', 'Lynn Wong', 'lynn@example.com', null),
        ];

        // 1) sale
        $listing1 = Listing::updateOrCreate(
            [
                'created_by' => $users['sarah']->id,
                'listing_type' => 'sale',
                'property_type' => 'Elite Penthouse',
                'area' => 'Dubai Marina',
                'city' => 'Sector 4',
            ],
            [
                'price' => 8800000,
                'currency' => 'AED',
                'size' => 3450,
                'beds' => 4,
                'baths' => 5,
                'status' => 'active',
                'is_off_plan' => true,
                'tags' => ['EXCLUSIVE', 'DISTRESS'],
                'views_count' => 2,
                'saves_count' => 45,
                'expires_at' => null,
            ]
        );
        Listing::whereKey($listing1->id)->update(['created_at' => $now->copy()->subDays(2), 'updated_at' => $now]);

        $detail1 = ListingDetail::updateOrCreate(
            ['listing_id' => $listing1->id],
            [
                'payment_plan' => '60/40 (Post-Handover)',
                'ownership' => null,
                'furnished' => null,
                'commission' => null,
                'roi' => 7.4,
                'notes' => 'Iconic skyline views, vacant on transfer. Full-floor luxury unit.',
                'amenities' => null,
                'extra' => [
                    'ai_verified' => true,
                    'service_charges' => '12.5 / sqft',
                    'completion_date' => 'Q4 2025',
                    'lat' => 25.0800,
                    'lng' => 55.1400,
                ],
            ]
        );

        ListingMedia::where('listing_id', $listing1->id)->delete();
        $imageUrl1 = 'https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200';
        for ($i = 0; $i < 12; $i++) {
            ListingMedia::create([
                'listing_id' => $listing1->id,
                'type' => 'image',
                'url' => $imageUrl1,
                'order' => $i,
            ]);
        }

        // 2) requirement
        $listing2 = Listing::updateOrCreate(
            [
                'created_by' => $users['ahmed']->id,
                'listing_type' => 'requirement',
                'property_type' => 'Looking for 2BHK + Study',
                'area' => 'Downtown Dubai • Urgent requirement',
                'city' => null,
            ],
            [
                'price' => 3500000,
                'currency' => 'AED',
                'size' => null,
                'beds' => 2,
                'baths' => 2,
                'status' => 'active',
                'is_off_plan' => false,
                'tags' => ['URGENT'],
                'views_count' => 0,
                'saves_count' => 0,
                'expires_at' => null,
            ]
        );
        Listing::whereKey($listing2->id)->update(['created_at' => $now->copy()->subHours(2), 'updated_at' => $now]);

        ListingDetail::updateOrCreate(
            ['listing_id' => $listing2->id],
            [
                'payment_plan' => null,
                'ownership' => null,
                'furnished' => null,
                'commission' => null,
                'roi' => null,
                'notes' => 'Client urgently needs 2BHK + Study in Downtown Dubai. High floor, Burj view preferred. Budget flexible for serious options.',
                'amenities' => null,
                'extra' => [
                    'ai_verified' => false,
                    'timeline_label' => 'Immediate',
                ],
            ]
        );

        // 3) rent
        $listing3 = Listing::updateOrCreate(
            [
                'created_by' => $users['maria']->id,
                'listing_type' => 'rent',
                'property_type' => 'Modern Studio',
                'area' => 'Jumeirah Village Circle',
                'city' => null,
            ],
            [
                'price' => 65000,
                'currency' => 'AED',
                'size' => 480,
                'beds' => 1,
                'baths' => 1,
                'status' => 'active',
                'is_off_plan' => true,
                'tags' => [],
                'views_count' => 2,
                'saves_count' => 45,
                'expires_at' => null,
            ]
        );
        Listing::whereKey($listing3->id)->update(['created_at' => $now->copy()->subDays(8), 'updated_at' => $now]);

        ListingDetail::updateOrCreate(
            ['listing_id' => $listing3->id],
            [
                'payment_plan' => '60/40 (Post-Handover)',
                'ownership' => null,
                'furnished' => null,
                'commission' => null,
                'roi' => 7.4,
                'notes' => 'Fully furnished, ready to move. Close to park and community center.',
                'amenities' => null,
                'extra' => [
                    'ai_verified' => true,
                    'service_charges' => '12.5 / sqft',
                    'completion_date' => 'Q4 2025',
                    'lat' => 25.0600,
                    'lng' => 55.2100,
                ],
            ]
        );

        ListingMedia::where('listing_id', $listing3->id)->delete();
        $imageUrl3 = 'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200';
        for ($i = 0; $i < 12; $i++) {
            ListingMedia::create([
                'listing_id' => $listing3->id,
                'type' => 'image',
                'url' => $imageUrl3,
                'order' => $i,
            ]);
        }

        // 4) rent_request
        $listing4 = Listing::updateOrCreate(
            [
                'created_by' => $users['lynn']->id,
                'listing_type' => 'requirement',
                'property_type' => 'Need 1BHK for 12 months',
                'area' => 'JLT • Ready to move next month',
                'city' => null,
            ],
            [
                'price' => 85000,
                'currency' => 'AED',
                'size' => null,
                'beds' => 1,
                'baths' => 1,
                'status' => 'active',
                'is_off_plan' => false,
                'tags' => ['RENT REQUEST'],
                'views_count' => 0,
                'saves_count' => 0,
                'expires_at' => null,
            ]
        );
        Listing::whereKey($listing4->id)->update(['created_at' => $now->copy()->subHours(24), 'updated_at' => $now]);

        ListingDetail::updateOrCreate(
            ['listing_id' => $listing4->id],
            [
                'payment_plan' => null,
                'ownership' => null,
                'furnished' => null,
                'commission' => null,
                'roi' => null,
                'notes' => 'Looking for furnished 1BHK in JLT or Marina. Prefer building with gym. Lease start March.',
                'amenities' => null,
                'extra' => [
                    'ai_verified' => false,
                    'timeline_label' => 'March',
                ],
            ]
        );
    }
}

