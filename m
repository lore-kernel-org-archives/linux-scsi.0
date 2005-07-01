From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: Write cache on SATA drives?
Date: Fri, 01 Jul 2005 10:17:24 +0200
Message-ID: <m3acl7ym7f.fsf@merlin.emma.line.org>
References: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com>
	<20050701062416.GQ2243@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:4765 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S263281AbVGAIR2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2005 04:17:28 -0400
In-Reply-To: <20050701062416.GQ2243@suse.de> (Jens Axboe's message of "Fri, 1
	Jul 2005 08:24:21 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Edwards, Scott (GE Healthcare)" <J.Scott.Edwards@ge.com>, linux-scsi@vger.kernel.org

Jens Axboe <axboe@suse.de> writes:

> On Thu, Jun 30 2005, Edwards, Scott (GE Healthcare) wrote:
>> Hello,
>> 
>> Can anyone tell me if the write cache on SATA drives are handled such
>> that journaling file systems work correctly?  Back in the 2.6.5 -
>> 2.6.7 time frame I had to disable the write cache to get ext3 to not
>> trash things when the power was lost.  With kernel 2.6.10 would I
>> still need to disable the write cache?
>
> With 2.6.12.x it should work, if you use ext3 or reiser and the
> appropriate mount options (-o barrier=1 for ext3, barrier=flush for
> reiserfs). 2.6.11 and earlier does not work on SATA.

I presume this means "libata" exclusively, no?

Which is the oldest version where this works

1. for SCSI (perhaps by adaptor)?

2. for traditional IDE (such as VIA 82*, PIIX_*)?

3. for RAID?

4. for XFS or JFS?

I have started to compile a list of requirements,
<http://home.pages.de/~mandree/linux/kernel/safe-write-caches.html>

Contributions solicited.

-- 
Matthias Andree
