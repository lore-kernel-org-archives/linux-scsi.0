From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Fri, 10 Jan 2014 21:13:08 -0500
Message-ID: <52D0A8B4.90905@ubuntu.com>
References: <20140108005607.GB29556@linux.intel.com>,<52CED67E.7080706@ubuntu.com> <11E08D716F0541429B7042699DD5C1A17073C362@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <11E08D716F0541429B7042699DD5C1A17073C362@FMSMSX103.amr.corp.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Brandt, Todd E" <todd.e.brandt@intel.com>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "tj@kernel.org" <tj@kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/10/2014 06:11 PM, Brandt, Todd E wrote:
> Yes yours is simpler, but it also opens a potential memory issue
> by passing a static int as the return location for the error value.
> I think it's just safer to tell the callback to attempt no return
> value at all, and for that you need to expand it into two
> arguments, one for selection, the other for the output address.

What sort of memory issue?  Also isn't there a system NULL page
somewhere that could be used?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJS0Ki0AAoJEI5FoCIzSKrwzAUH/3PXkCbb1zW6ObzBVOS8I4vM
SjeE9unHqTlFbFL8M/sTWV+LJTKnIpEBEfV7QXFENDKPi+o58Aq1PanvW0Pu/R5+
/hOR08ry7HMRqK+Q/J+CynjoMQO3Qfw0elIVQUkSsayqdeA2QeLMDbWLxQhh9j85
o5AD7VsW1X8M7l1yzCUvl5A68M/ZR9dapW3RlErRmTdECZE5qLTN2RKezfboM5lo
i4y8IWadF7tou4vbqoGQd/JVgmgc4SRlal7HAqbVWuwmumslMGGBNpZTcgY7ffvT
PLHnx8txmeK2ELVg/aRm34j2TdI8mAYzIQ2pJ7hKwRlBc5W8ho4XHEy9o1jDaLg=
=MCaR
-----END PGP SIGNATURE-----
