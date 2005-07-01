From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: Write cache on SATA drives?
Date: Sat, 02 Jul 2005 01:33:40 +0200
Message-ID: <m38y0qnlt7.fsf@merlin.emma.line.org>
References: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com>
	<20050701062416.GQ2243@suse.de> <m3acl7ym7f.fsf@merlin.emma.line.org>
	<20050701083308.GZ2243@suse.de>
	<20050701084717.GA18306@merlin.emma.line.org>
	<20050701085412.GA2243@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:16816 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261632AbVGAXdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2005 19:33:45 -0400
In-Reply-To: <20050701085412.GA2243@suse.de> (Jens Axboe's message of "Fri, 1
	Jul 2005 10:54:13 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Edwards, Scott (GE Healthcare)" <J.Scott.Edwards@ge.com>, linux-scsi@vger.kernel.org

Jens Axboe <axboe@suse.de> writes:

>> I'm not acquainted with kernel/block I/O queueing internals.
>
> SCSI without TCQ or with TCQ depth=1 should be safe, provided the driver
> never reorders a command once it has received it.

Wouldn't we rather use *deep* TCQ and set write cache enable to 0 then?

Does anybody have benchmarks with TCQ depth = 1/WCE = 1 vs. TCQ = <deep>
(64+)/WCE = 0? I only have ancient SCSI drives in test machines, so my
testing wouldn't be representative.

>> > > 2. for traditional IDE (such as VIA 82*, PIIX_*)?
>> > 
>> > In SUSE kernels, for many years. Since 2.6.7/8'ish in Linus' kernels.
>> 
>> I don't care for vendor kernels. Is listing 2.6.8 safe?
>
> Check the changelogs, I can't remember exactly if it was 2.6.7 or 2.6.8
> (or perhaps .6...).

Hm. Any buzz^Wkeywords to look for? "barrier" doesn't seem to be the
right word, it yields only memory barriers and an as-iosched fix in
2.6.7.  I checked ChangeLog-2.6.[56789].

-- 
Matthias Andree
