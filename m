From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH/RESEND v2 0/2] SATA disk resume time optimization
Date: Wed, 27 Nov 2013 11:18:54 -0500
Message-ID: <52961B6E.9070505@ubuntu.com>
References: <20131017193331.GA11747@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20131017193331.GA11747@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/17/2013 3:33 PM, Todd E Brandt wrote:
> sd_resume patch (2/2):
> 
> On resume, the SD driver currently waits until the block driver 
> finishes executing a disk start command with blk_execute_rq. This 
> patch changes the sd_resume callback to use blk_execute_rq_nowait 
> instead, which allows it to return immediately, thus allowing the

Can another request in the queue race with the start/stop command and
possibly beat it to dispatch?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSlhtuAAoJEI5FoCIzSKrwgJ0H/ioXLuLHh4aJ3ZNs9LZ3gloA
hQb9bTbUOFpC2HM0GpWntNs9V1KXKha7zqiW7alqmmiaUor7mN8CoVILIrwgEe10
9Fd8z0DNBjCM+BdhdSO1g2opjMYif9ID74E/nA4tP3cXV2TiPjax/lF861iirEAl
xaK5WdI7Ua5qbpIc1Xr6t8EbH1DSwEbiFOkN5HGs2ldFWB+f3jTRMZiGwh2RhUzV
OZt2UKIsCAhwO6opnUPJ3Vv4IHQR248uijGxcuy5KDERVbKtfz8If6CG43FVdSr/
c59AEXgUFtvPm/J9DRO/rVO7Dp2e+DTwJ67Mx9TDqtcKwuRxzsdaxn1yJEXoZfk=
=IOxx
-----END PGP SIGNATURE-----
