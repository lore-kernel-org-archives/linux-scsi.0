From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 22:20:25 -0500
Message-ID: <52D9F2F9.2050304@ubuntu.com>
References: <20140116220409.GA1183@linux.intel.com> <Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org> <20140118012420.GA11405@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:62197 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaARDU0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 22:20:26 -0500
In-Reply-To: <20140118012420.GA11405@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com, Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/17/2014 08:24 PM, Todd E Brandt wrote:
> 10 seconds?! The only possible way that could happen is if the test
> unit ready SCSI command actually triggered an ata port wakeup; at
> which point you've already done the one thing you were trying not
> to do.

A typical ATA disk is already spinning up on its own as soon as power
is applied.  They don't respond to any commands until they finish.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJS2fL5AAoJEI5FoCIzSKrw0MMIAIy8Ue/Ny+pq095ZHJjOtfq2
gsEQgfEjp1s2Aekv4md/H2tstit8CC1dKkIhppuLJV/0BZgckDEO+ee8SmVKf+8I
ctolLIAKy+vP6jAYHaOVUGvwWEyaLsVyAuPulunvDKs9crRijI/7fFK/RtbAVQSS
+fVnhriAlm7Vsd/okt3sgXMiVQGzlA5dA+0NrklAf4OZckeC/6ZqSrz3z1j1jc1k
dyItvfQxdG9Sys6DrxPJGF+FKHu6btZ/m060jRSth2+i62qtTHkgLJRe0QnjmGKK
0G8AtI5WYy10igtB5xDTr8tSfxnc9bmruZQNOU+jHEerIeBDxUAAomN5t9157Sc=
=O0TD
-----END PGP SIGNATURE-----
