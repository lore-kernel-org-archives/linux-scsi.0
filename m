From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 22:24:04 -0500
Message-ID: <52D9F3D4.6050807@ubuntu.com>
References: <Pine.LNX.4.44L0.1401172034180.945-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:61914 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaARDYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 22:24:05 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401172034180.945-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/17/2014 08:41 PM, Alan Stern wrote:
> The intention is that this will help on systems with more than one 
> disk drive.  The one containing the core OS files and the journal
> will certainly spin up right away, but the others may not.

I am hoping to prevent that as well with the regular laptop-mode type
knobs.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJS2fPUAAoJEI5FoCIzSKrwLj4H/3DVvgo/35w+zyBT6ZQCn+0c
uV0oD+8hPFIr7yY5ynOP0HGdSOtXgBxo7sOz/1yED/jnOOgyx11oma+Y0lkT1PSw
OK3+Du8xLDAtomNwng3/Wul4tGKV/tkAL5giblztk8ZLkC5zC4mOkuD44bqF8shq
4NzDvA/25KGEcVAHoFml7BxDbLirWkhtyVW75DnVlAIel8nIOL7AuYOP8xap++k4
SfYTsTLMpN46j/dorWvFtQ9tfmYeqEltPgtGejT89oDeFwyVegotSiuFsib1vu82
gKVKGkcPdazW18V3LoPnz3QSIb0uU2tgzCFY45ZqS7g9f87V0bFQMvO3iZ9F3qI=
=ddyN
-----END PGP SIGNATURE-----
