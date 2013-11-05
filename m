From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk wakeup on resume
Date: Tue, 05 Nov 2013 09:07:03 -0500
Message-ID: <5278FB87.3020908@ubuntu.com>
References: <527859D9.3030607@ubuntu.com> <5278B4DB.7080302@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5278B4DB.7080302@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/5/2013 4:05 AM, Aaron Lu wrote:
>> Are you using an ATA drive? Last time I checked, the spin up
>> actually happened while the ata port is resumed(when it will be
>> reset): https://lkml.org/lkml/2013/2/4/361

Why does resetting the port spin up the drive?  And I'm pretty sure I
still saw the port reset messages after unbinding sd, yet the drive
remained spun down.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSePuHAAoJEJrBOlT6nu75NYMIAL41IBonf1CAP/OVEXBwpBIa
HXQoo7Icz5ZQ+Tu/Tj2orumu0m0Cm3O7aUt30Gye+Vca8UpWDUjcqQ0br+dymdXq
PFkPS7Dr2zF3mSULDBUn6mHXUuUgS5Vmdf2+FLSldfa8SyTsT2Nwzz8hnUCAZQEO
C7aA2fZCQ1yZYCXrXKSh/TZg2RGT+eg57kNLQ2hwBrDwHKL+p7UbWESuqEFeR5U9
bj3JCO6/erG19/tibVHP7tuJokxSWrbQZbHrjO8a74ms5esiEAHpnka7q8wp/FbS
gPklZJJjk+C0akaHDbj1dslEXgozoam42GhYeq7Lgo0O3Wx1N1/Fy5ZBxW3KTu0=
=Ci32
-----END PGP SIGNATURE-----
