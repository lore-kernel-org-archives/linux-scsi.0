From: Mark Overmeer <Mark@Overmeer.net>
Subject: Re: Huge 1.2TB partition
Date: Sat, 25 Sep 2004 10:01:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040925100108.A7908@speeltuin.ATComputing.nl>
References: <1096019417.2726.61.camel@whirl.lab7.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from speeltuin.ATComputing.nl ([195.108.229.26]:43275 "EHLO
	speeltuin.ATComputing.nl") by vger.kernel.org with ESMTP
	id S269273AbUIYIBJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 04:01:09 -0400
Content-Disposition: inline
In-Reply-To: <1096019417.2726.61.camel@whirl.lab7.lan>; from stas@itam.nsc.ru on Fri, Sep 24, 2004 at 04:50:17PM +0700
List-Id: linux-scsi@vger.kernel.org
To: Stas Nikiforov <stas@itam.nsc.ru>
Cc: Linux-scsi list <linux-scsi@vger.kernel.org>, rocks_list <npaci-rocks-discussion@sdsc.edu>

* Stas Nikiforov (stas@itam.nsc.ru) [040924 11:50]:
> I have RAID 5 6x250 SATA storage.
> Is it a good idea to have one huge partition
> or it is better to split it on smaller logical drives and then use LVM,
> for example?
> 
> In any way, what is a preferred filesystem for this storage?
> I plan to use it as a mass storage for CFD results.

I run a disk-set of 4x250 SATA with an Adaptec 2410SA and
      a disk-set of 8x250 SATA with an Adaptec 2810SA.

In both cases, I have a small disk aside, which I use for the OS, log-
files and such.  The array is dedicated to my data: satellite images.

Usually, having one partition is best,  certainly with a file-system
which is tuned on large disk-sets.  I choose XFS, which is capable of
handing much larger partitions.  It runs currently on SuSE9.0 with
recent 2.6 kernels.

My selection is not based on performance tests: the I/O bandwidth of
the PCI-bus is my bottleneck.  But in my case counts: as long as it
is faster than a tape-archive..... and cheap
-- 
               MarkOv

------------------------------------------------------------------------
drs Mark A.C.J. Overmeer                                MARKOV Solutions
       Mark@Overmeer.net                          solutions@overmeer.net
http://Mark.Overmeer.net                   http://solutions.overmeer.net
