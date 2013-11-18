From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sun, 17 Nov 2013 20:11:56 -0500
Message-ID: <5289695C.1000907@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>			 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>			 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>		 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>		 <52883CE9.9040102@ubuntu.com>	 <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com>	 <5288EBA6.3070609@ubuntu.com> <1384733368.2050.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1384733368.2050.18.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dgilbert@interlog.com, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/17/2013 07:09 PM, James Bottomley wrote:
> Because you don't damn well listen.  Two emails ago I said:
> 
> The error handler is not automatically activated for a not 
> ready/initializing command required because of multi-path

And I replied that that *if* eh is suppressed ( and I'm still not
clear on why multipath would do that ), then a flag could be used to
pro actively start the drive despite the suppression, like I did with
libata.

> I don't really understand how I can be clearer.  You keep
> wittering about the error handler spin up but if the error handler
> doesn't activate, the disk is never spun up with your patch.  This
> is the problem we keep telling you about.  You can't make the error
> handler always activate because then multi-path would fail.

Why does multi-path -> no eh?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSiWlcAAoJEJrBOlT6nu755h4H/AwoDzPc/iNAw/v3h+HGszCx
3AZUJUbabF7XB8NxbfyLG/vvaGEqxatv5fX3y0I6CmWpWBGQYyDL7W6uQIgKjqAt
OmUCEEv3PqnytTg7VjyBBif+TMxM35gZvqzFYWU5DOMB9D+QtvfIHmyH4rCMujYl
tLJqArxLMBLnLmpSTp0/TTrvjxDThjkCF6vlM0iSe7C8xZsByRcpoIQJlsvTW7YT
IWVop4H9iAW4CZhiSQwdf+IiK8Av45RW8i20em+LlaVvbofoBlUOgUrxIIXu7trT
cslbwtPQ2N3SsTEd5E43W3bzDO19gzQHJf5wHTiMg3++yPWqP0hMUgU0ci0Y4aI=
=DleI
-----END PGP SIGNATURE-----
