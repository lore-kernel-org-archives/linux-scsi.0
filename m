From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Wed, 20 Nov 2013 09:48:35 -0500
Message-ID: <528CCBC3.3030002@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>		 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>		 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>	 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>	 <52883CE9.9040102@ubuntu.com> <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com> <5288EBA6.3070609@ubuntu.com> <5289573A.9070307@interlog.com> <52896806.4040907@ubuntu.com> <528A382E.10400@ubuntu.com> <528CC5C8.6080700@start.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <528CC5C8.6080700@start.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <kernel@start.ca>, dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/20/2013 9:23 AM, Mark Lord wrote:
> Yeah, solve that, and you're golden. I totally understand the
> motivation for this patch, and would love to have it working on my
> machines here too.
> 
> But it may have to be some kind of sysfs optional setting, 
> defaulting to current behaviour, to keep the server keepers happy.

My original idea was actually to just have the system resume force the
runtime pm status to suspended, then it will take care of calling the
runtime resume which can easily start the drive, but I was hoping to
get it working whether or not runtime pm is configured.  I may just
have to fall back to that.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSjMvDAAoJEJrBOlT6nu75J5QH/2APABstv5HejNp5R4uvmAuL
xTZyHHOFvcMBDpCFLtlWK6PhnKmN7C/eFlzc7xaadtd0wmgjOqZVLTgfYSWBON6X
/kRz/QtDMhsppah7t1T/QzPPQ/z2j4j2/ffwDRRN4bCdM39B/QQCUeVCxVK0mEx3
w5A2Xiro1gAknh1xb/0SfSb9M35H5bLBt4Pz5Ql/75to9jEeH0MlTthZmm+CJPC/
RcBgCkOG6kEOeqCj4tehnTOrs4a8ghdeGNnR6W6UDaeRh3QjRwOvAmwIbZsxkXgs
XSP52adzt5fnZi8uQAzV0bIGN+8Zttx0PHdl3AsVt56CMfdfAHVbL1RVo+Pl85E=
=fnz3
-----END PGP SIGNATURE-----
