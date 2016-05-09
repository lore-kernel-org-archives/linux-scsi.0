From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [RFC PATCH 0/4] dm mpath: vastly improve blk-mq IO performance
Date: Mon, 9 May 2016 15:48:12 +0000 (UTC)
Message-ID: <loom.20160509T174545-587@post.gmane.org>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42935 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbcEIQaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 May 2016 12:30:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1azo4L-00051T-5p
	for linux-scsi@vger.kernel.org; Mon, 09 May 2016 18:30:06 +0200
Received: from 63.163.107.100 ([63.163.107.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 09 May 2016 18:30:05 +0200
Received: from bart.vanassche by 63.163.107.100 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 09 May 2016 18:30:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Mike Snitzer <snitzer <at> redhat.com> writes:
> I developed these changes some weeks ago but have since focused on
> regression and performance testing on larger NUMA systems.

Hello Mike,

Sorry that I do yet have any performance numbers available for the SRP 
protocol for this patch series. But I want to let you know that since I 
started testing this patch series three weeks ago that I haven't seen any 
regressions caused by this patch series.

Bart.

