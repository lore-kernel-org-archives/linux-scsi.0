From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Thu, 16 Jan 2014 13:33:55 -0500
Message-ID: <52D82613.9090804@ubuntu.com>
References: <52CEC5EF.4030201@ubuntu.com> <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org> <20140116180415.GA14515@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63108 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaAPSeA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 13:34:00 -0500
In-Reply-To: <20140116180415.GA14515@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com, Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/16/2014 1:04 PM, Todd E Brandt wrote:
> Both approaches employ non-blocking resume of the scsi disks so why
> don't we treat these two patch sets as parts one and two. My patch
> just spins everything up but sets everything to non-blocking, so it
> will take care of the most common use cases. Your patch will then
> fine-tune that behavior to only spin up those disks that are
> actually needed. I don't think there are any serious conflicts
> between the two patch sets.

Sounds good.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS2CYTAAoJEI5FoCIzSKrwLicIAJqlqHgr8fXpkoNo/jTNjaXv
7hKkLD0QevQrdd7O9hiQ8sT9ncR6XSx+B3naTpDOsAe/s0b964EuFxMyhixV7rij
+ODTLQ6p2Bl0y12WoXvi95iK+F71ZofHH6aGeFF7lz6FDvFFCHBI3fTRI1Z3ybo5
XQgGZ2yissvoNFdtBqbx3ezFTP6XBP6y1i7dGQxfRFoq5UIHYL2w1mUobdLuAkaF
I3pbMqxUDJO1CDrhwYP1URPRQQiNrpm2Di8P3kuJJgbtetW5cpDFTH6Oo0/8IMNW
2H7JByM2ZmGtN4r5ALeePmBdxgzkU8V3KittSHUGvs0mfXpMet+TRW/vNCHakzQ=
=hZGn
-----END PGP SIGNATURE-----
