From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Mon, 10 Mar 2014 18:41:09 -0400
Message-ID: <531E3F85.9010304@ubuntu.com>
References: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Dan Williams <dan.j.williams@intel.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 03/10/2014 04:59 PM, Alan Stern wrote:
> Why?  The existing code doesn't have anything like that.

The current sd code doesn't, but the libata code does use the AHCI
staggered spinup feature flag as a hint to only spin up one drive at a
time, so these patches together may defeat that behavior when resuming
from suspend.  That could be a problem on some systems.  Then again,
it may still follow the same code path in libata; I haven't looked at
it closely enough lately to be sure.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJTHj+FAAoJEI5FoCIzSKrwYm0IAKZlralrzs8+5s7F4xouYrz8
samOep5+XxO8eVa6Cl6kqQvl02jYJNLUnabeBBTe8L5qws+ZFXnSkhFvAC5zd3LF
a68hns996l9wum+XWDAeMb7K7/dKYJiDB+6w3foquA4fgoZsc2tYLEjvUUA9h9U6
+bfZpelLnqqRgFwKwBazqVRB4ZIBGcq1+DLnDTldOH6e4gJSnzoJU1MbLYiCa6KU
tvg2XWDnp1ifhHcCGVIsdEdB1hxKKs3J+3CiXeg1Uc6LoWOfOpsfkvReNfIk4Ju9
zr2KEXGsIZwcmyx9i2Jni/I90oG3jNtVWlOT9Gvey2RW2fiMREesuHTt5KONc/U=
=wrih
-----END PGP SIGNATURE-----
