From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/2] libata: use sleep instead of standby command
Date: Mon, 04 Nov 2013 21:39:10 -0500
Message-ID: <52785A4E.7080006@ubuntu.com>
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com> <527856B6.8030901@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <527856B6.8030901@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/04/2013 09:23 PM, Aaron Lu wrote:
> I suppose this is mainly for runtime PM? Since for system 
> suspend/hibernation, the disk and its controller will be powered
> off anyway.

Yes, or the second patch also helps when one manually issues hdparm
- -Y, which otherwise will cause the drive to be woken up to answer the
CHECK POWER command, which udisks issues to decide if it should skip
polling the SMART status of the drive.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSeFpOAAoJEJrBOlT6nu75JdwIALFvwncNyf1ENxnIho2Y3CXC
N6BpHQ7CzD1tap/5ybSFPBvUvJfyC/UPAY69bjldOtbwnArDIWRFqEWW7JWm6G0z
J1C5MMCIRHSuRo4RbN/rnsPQFsaFJy0Z5kJ0uXX+aOrZwEov5vo2MEuj/DEdCBDC
SKpYkogDlSHTNhFsaEF5iJiJlLU9FF5pEM6S6P0/+Z+SrZ5PVCDOm9rK+oeqrn0U
TBX5tKPxWRSjJ/2F094DYia5l8ODNgzl1gPDXA50a+A4M0CZi3d5Liz5Ctfnv88A
ac5cG8Ae8MDss0kJmSMCuRwkKVIROM3qMxf1wDWjBwm3eCTAJV1gxRYSN0adOvc=
=Rfny
-----END PGP SIGNATURE-----
