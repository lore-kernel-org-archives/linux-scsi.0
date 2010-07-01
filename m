From: Vivek Goyal <vgoyal@redhat.com>
Subject: [ATTEND] Want to attend LSF 2010
Date: Thu, 1 Jul 2010 14:04:30 -0400
Message-ID: <20100701180430.GD2705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab0GASEg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 14:04:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf10-pc@lists.linuxfoundation.org
Cc: linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@suse.de>

Resending this mail. This time also CCing linux-scsi mailing list. Sorry
for the duplicate copy.

Hi,

I wanted to attend LSF 2010. Sepcifically I was interested in discussing
couple of things.

- CFQ performance issues on higher end storage
        - Deadline outperforms CFQ on higher end storage (storage arrays
          and also on host based hardware RAID). I was wondering if there
          is a way to fix it or it is just design limitation. In the past
          Jens had mentioned that he wants to get rid of deadline also and
          be replaced with CFQ. Are we still targeting that and if yes,
          how to achieve that (some kind of auto tuning).

- Max bandwidth IO controller
        - A basic proportional weight controller (blkio) based off CFQ is
          now in. Now there is also a need to implement throttling/max
          bandwidth controller. Wanted to get some ideas on how to go
          go about it and what is the best place to impement it. Implement
          it in CFQ or a new device mapper target or something else.

Thanks
Vivek

