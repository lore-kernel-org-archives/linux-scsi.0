From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: SCSI vs SATA considerations
Date: Sat, 08 May 2004 22:22:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409D4193.6144664B@danbbs.dk>
References: <200405081903.i48J3CB23261@www.watkins-home.com>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:46187 "EHLO
	pfepa.post.tele.dk") by vger.kernel.org with ESMTP id S264147AbUEHUUJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 May 2004 16:20:09 -0400
Received: from danbbs.dk (0xc2ef15a4.bynxx4.adsl-dhcp.tele.dk [194.239.21.164])
	by pfepa.post.tele.dk (Postfix) with ESMTP id 6F44847FE08
	for <linux-scsi@vger.kernel.org>; Sat,  8 May 2004 22:20:08 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi <linux-scsi@vger.kernel.org>

Guy wrote:
> 
> 34.4MB/s may be the correct speed for the disk.
> What do the specs say?
> 
> My disks are running at 80MB/s and 40MB/s.  I have 17 of them on 3 buses.
> But any 1 disk only gives me about 19MB/s, regardless of which bus it is
> on.
> But if I test 2 disks I get about 37MB/s total, 3 or more gives me about
> 38MB/s total on the 40MB/s bus.  The 80MB/s bus does better, 70+MB/s with
> 4 or more disks.  The only time there is a real difference in performance
> between the 40 and 80MB/s buses it during a RAID re-build or when I test
> disk performance.  In real life, disk access is random, and the random
> read rate of my disks is about 3MB/s.

I wrote:

>> I still get only 34.4 MB/s, though (misspelled the speed in first post).
>> Tried forcing 80MB/s, disabling domain validation, and forcing
>> termination on the 29160, no change.

Yes, something to think about. Figures well with i.e. copying files
locally on one SCSI disk. Maybe I cheated myself looking at the SATA
performance, where hdparm -t gives me 54MB/s; of cause not a real-life
situation.
However, doing the same filecopy on SATA is just so much faster.
Of cause, filesystem and disk caching may have eluded me, so the
filecopy was not actually complete, the action still pending a
filesystem flush.

I started this writing saying I need to figure out which disk subsystem
is best for me. This is not a multiuser system, or a highload database
server.
SATA may be/look fast, but (SATA v.1 on interfaces like Sil321a) is
still little more than ATA revisited, whereas SCSI in real-life work may
still provide better results, especially when running 3-4 OS's in
vmware.

It's problem for me, as I'm not running this system on either scsi,
sata, or a combination of both, as yet...
Though I've been using SCSI UW for some years now, initially, SATA just
seems somewhat faster.  Geez, more thinking left to do :-

Thanks for the practical points of views.

-- 
Kind regards,
Mogens Valentin
Networking, Security
www.danbbs.dk/~monz
Phone +45 32 525 878


The more things change, the more they stay the same.
  -- unknown
