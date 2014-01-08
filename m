From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 21:19:48 -0500
Message-ID: <52CCB5C4.7020206@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com> <52CC1422.1020101@ubuntu.com> <52CCA3CF.5050308@intel.com> <52CCA6E3.2090400@ubuntu.com> <52CCAAA7.4070104@intel.com> <52CCAF8C.7040407@ubuntu.com> <52CCB3E8.5010101@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CCB3E8.5010101@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/07/2014 09:11 PM, Aaron Lu wrote:
> I thought that feature is used to control if a disk should be spun
> up once powered from the host side.

That *is* what it sounds like, only ATA disks either spin up as soon
as power is applied, or wait for an actual command issued by higher
layers.  There doesn't seem to be any low level SATA mechanism to spin
the drive up that the SSS feature could toggle, so it seems to simply
be a hint to libata, and possibly the bios.

> Too bad for a jumper, that's beyond our control. And about the
> hdparm, does the setting survive a power cycle?

Yes, otherwise there wouldn't be much point to a setting that only
matters at power on ;)


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSzLXEAAoJEI5FoCIzSKrwhVwH/2amZwCu1WIFiPswU2ydIZhR
lGL0+0C9hKb4O+FEahkLMYsX/bouxtUs3HOcAJOlmmAFZC5yhczIBijcuIKjZyW5
HAv4Sfw1xIjC6N5pMtNnnG8SUORDXy4cbMDS4+poC0aKIWw47GMNin/Uqav4Wn90
3U9nbUm7sBZ6zSLpDkenB5kZKUYmMaziwEb1IwBvxrRdnS3X5B9L3WuuCjheQoF8
YhSFdc/0OGdRRiY/oaZwizRV7bJO2sg99qRoSVIa8ZnL5v9HzT0MCVq9aUBXNLUI
eTyv0O1rkgW5lFk+4aIhJUPSb52F4lNwBmNVINIzLCehpy/oT1DVZN3sL+ykBeI=
=DJOH
-----END PGP SIGNATURE-----
