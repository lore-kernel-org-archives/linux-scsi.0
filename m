From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 23 Jan 2008 20:11:34 +0300
Message-ID: <47977546.8090904@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:52478 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbYAWRLk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 12:11:40 -0500
In-Reply-To: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@hansenpartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> As you probably know there is a trend in enterprise computing towards
> networked storage. This is illustrated by the emergence during the
> past few years of standards like SRP (SCSI RDMA Protocol), iSCSI
> (Internet SCSI) and iSER (iSCSI Extensions for RDMA). Two different
> pieces of software are necessary to make networked storage possible:
> initiator software and target software. As far as I know there exist
> three different SCSI target implementations for Linux:
> - The iSCSI Enterprise Target Daemon (IETD,
> http://iscsitarget.sourceforge.net/);
> - The Linux SCSI Target Framework (STGT, http://stgt.berlios.de/);
> - The Generic SCSI Target Middle Level for Linux project (SCST,
> http://scst.sourceforge.net/).
> Since I was wondering which SCSI target software would be best suited
> for an InfiniBand network, I started evaluating the STGT and SCST SCSI
> target implementations. Apparently the performance difference between
> STGT and SCST is small on 100 Mbit/s and 1 Gbit/s Ethernet networks,
> but the SCST target software outperforms the STGT software on an
> InfiniBand network. See also the following thread for the details:
> http://sourceforge.net/mailarchive/forum.php?thread_name=e2e108260801170127w2937b2afg9bef324efa945e43%40mail.gmail.com&forum_name=scst-devel.
> 
> About the design of the SCST software: while one of the goals of the
> STGT project was to keep the in-kernel code minimal, the SCST project
> implements the whole SCSI target in kernel space. SCST is implemented
> as a set of new kernel modules, only minimal changes to the existing
> kernel are necessary before the SCST kernel modules can be used. This
> is the same approach that will be followed in the very near future in
> the OpenSolaris kernel (see also
> http://opensolaris.org/os/project/comstar/). More information about
> the design of SCST can be found here:
> http://scst.sourceforge.net/doc/scst_pg.html.
> 
> My impression is that both the STGT and SCST projects are well
> designed, well maintained and have a considerable user base. According
> to the SCST maintainer (Vladislav Bolkhovitin), SCST is superior to
> STGT with respect to features, performance, maturity, stability, and
> number of existing target drivers. Unfortunately the SCST kernel code
> lives outside the kernel tree, which makes SCST harder to use than
> STGT.
> 
> As an SCST user, I would like to see the SCST kernel code integrated
> in the mainstream kernel because of its excellent performance on an
> InfiniBand network. Since the SCST project comprises about 14 KLOC,
> reviewing the SCST code will take considerable time. Who will do this
> reviewing work ? And with regard to the comments made by the
> reviewers: Vladislav, do you have the time to carry out the
> modifications requested by the reviewers ? I expect a.o. that
> reviewers will ask to move SCST's configuration pseudofiles from
> procfs to sysfs.

Sure, I do, although I personally don't see much sense in such move.

> Bart Van Assche.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

