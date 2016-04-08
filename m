From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 0/4] dm mpath: vastly improve blk-mq IO performance
Date: Fri, 8 Apr 2016 15:29:39 -0400
Message-ID: <20160408192938.GC8453@redhat.com>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <57067597.4080103@suse.de>
 <20160407153448.GA30510@redhat.com>
 <2760420.6GyDefUaH5@c203>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbcDHT3l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 15:29:41 -0400
Content-Disposition: inline
In-Reply-To: <2760420.6GyDefUaH5@c203>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, linux-block@vger.kernel.org, jmoyer@redhat.com, j-nomura@ce.jp.nec.com

On Fri, Apr 08 2016 at  7:42am -0400,
Johannes Thumshirn <jthumshirn@suse.de> wrote:

> Ladies and Gentlemen,
> To show off some numbers from our testing:
> 
> All tests are performed against the cache of the Array, not the disks as we 
> wanted to test the Linux stack not the Disk Array.
> 
> All single queue tests have been performed with the deadline I/O Scheduler.
> 
> Comments welcome, have fun reading :-)

Any chance you collected performance results from DM MQ on this same
testbed without any variant of my lockless patches?  The DM SQ results
aren't too interesting a reference point.  Seeing how much better
lockless DM MQ (multipath) is than the old m->lock heacy code (still in
4.6) would be more interesting.

Not a big deal if you don't have it.. but figured I'd check to see.

And thanks for the numbers you've provided.
Mike
