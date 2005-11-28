From: Andreas Haumer <andreas@xss.co.at>
Subject: Re: scsi troubles - controller or hdd?
Date: Mon, 28 Nov 2005 11:58:57 +0100
Message-ID: <438AE2F1.7050302@xss.co.at>
References: <Pine.GSO.4.64.0511280958070.16249@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bernhard.xss.co.at ([193.80.108.69]:22420 "EHLO
	bernhard.xss.co.at") by vger.kernel.org with ESMTP id S1751255AbVK1K67
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 05:58:59 -0500
In-Reply-To: <Pine.GSO.4.64.0511280958070.16249@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Ingo Flaschberger schrieb:
> Hello,
> 
> I have troubles with a not full supported
> Adaptec AIC-7902 U320 w/HostRAID (rev 03) (no hostraid support).
> 
> I'm doing now software raid and have spurious scsi bus resets when high
> load is at the discs. Currently the machines runs at only 1 disk, but
> the problems happens with 2 or with 1 disk.
> The disk's are quite old, 3 years.
> 
Last week I had a hard time with the aic79xx driver too (see the thread on
this list with subject "SCSI error: Infinite interrupt loop, INTSTAT = 0"
starting at 22th of this month)

But this was a problem with Adaptec 29320A cards (aic7901 chip) and an
externally connected RAID subsystem where my internally connected U320
drives on a aic7902B controller chip (Tyan Transport TA26 built-in) do
work fine. I looks like your case is different...

> My question is, are the disks producing the problems or the controller
> itself?
> What could I do / change?
> 
> System: dual intel xeon
> kernel version:  2.4.20-021stab028.18.777-smp
> 
You could try to upgrade to a newer aic79xx driver (you can find the
newest aic79xx driver at <http://people.freebsd.org/~gibbs/linux/>
Current version is 2.0.12. But be aware that this version did not
help with the problems I had last week.

You could also try to use a different scsi controller brand. I always
had good success with LSI logic controllers (as was the case with the
problems I had last week: replace the Adaptec controller with the LSI
logic controller and suddenly everything works fine).

And of course you can do the usual hardware replacements (cable, disks,
terminator, ...) to check if the problem changes in any way.

HTH

- - andreas

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDiuLvxJmyeGcXPhERAorNAJ0fsJtkandHnE+zjGZmJ15/I+XQrQCfWjT1
104yC6RvYHLEJF6dijbzAGM=
=sx6e
-----END PGP SIGNATURE-----
