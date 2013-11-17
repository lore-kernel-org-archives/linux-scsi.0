From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sun, 17 Nov 2013 11:15:34 -0500
Message-ID: <5288EBA6.3070609@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>		 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>		 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>	 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>	 <52883CE9.9040102@ubuntu.com> <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dgilbert@interlog.com, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/17/2013 01:43 AM, James Bottomley wrote:
> OK, so three people have now told you that's not how the code
> works. Why don't you just read it?  because there's not really much
> point us reading your patches until you do.

I have, which is why I said it handles it via scsi_eh_stu.  If I'm not
understanding it correctly, then by all means, explain.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSiOumAAoJEJrBOlT6nu75j6QH/3QURQwEXSjeQRaHdEo3dPUp
eKSf7ix/6kOlWDzqzyNB0BWb0NDmCVc7v0GfKmcO0/7U2VoC4N5WqhvcXHU6X/PO
ZjhcvKvuZEK9z8H9+Dx2CsB2nZ1p3hnQq6GXk1oa4tNx4id+sXioG8qX8Uw5AurA
6O+ceHnb3hggvC8Oojo2YCwEMJiOYw+xhEjnleMcDAj+T5X3T4SMR/N6rM9NgX1L
4ekrQMi3dNrizZaFKXjkf8/xult/nsnk1jKnhvJ/Sdl3EOSMTMypjdVo3W4VHpZ1
0aDE8qIiLaU8x/xNjT4oQrVfseHexjzHVlQ7O5fc79+Tz+ej8PbjDLTtltPmn5M=
=fnx7
-----END PGP SIGNATURE-----
