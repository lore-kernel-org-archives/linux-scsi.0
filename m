From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: ultrastor.c is a bit-rot
Date: Tue, 18 Mar 2008 23:07:11 +0100
Message-ID: <m363vj1yb4.fsf@ursa.amorsen.dk>
References: <47DE8736.8020405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33111 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759166AbYCSUUU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 16:20:20 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Jbu4c-00024V-Ku
	for linux-scsi@vger.kernel.org; Wed, 19 Mar 2008 08:55:02 +0000
Received: from hd5b9080a.c45-01-12.sta.perspektivbredband.net ([213.185.8.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2008 08:55:02 +0000
Received: from benny+usenet by hd5b9080a.c45-01-12.sta.perspektivbredband.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2008 08:55:02 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Boaz Harrosh <bharrosh@panasas.com> writes:

> if the machine has more then 2^24 of memory. Then this will never
> work, right? or I'm missing it completely?

I used to have a machine with the VL-bus version of that card. I spent
a fortune upgrading that machine from 8x1MB to 4x4MB + 4x1MB, so it
did indeed work with larger than 16MB. The card got awfully hot and it
only worked when clocked at 33MHz (not the 40MHz the PC could do
without the card), but otherwise it worked fine.

I'm not sure whether that machine made it to kernel 2.0 though.


/Benny


