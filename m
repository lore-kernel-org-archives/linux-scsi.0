From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [dm-devel] [RFC PATCH 0/4] dm mpath: vastly improve blk-mq IO
 performance
Date: Fri, 01 Apr 2016 10:12:33 +0200
Message-ID: <6c6623e7f92e31daf1586d266fa03e1d@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbcDAIMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 04:12:36 -0400
In-Reply-To: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, linux-block@vger.kernel.org, jmoyer@redhat.com, j-nomura@ce.jp.nec.com

On 2016-03-31 22:04, Mike Snitzer wrote:
> I developed these changes some weeks ago but have since focused on
> regression and performance testing on larger NUMA systems.
> 
> For regression testing I've been using mptest:
> https://github.com/snitm/mptest
> 
> For performance testing I've been using a null_blk device (with
> various configuration permutations, e.g. pinning memory to a
> particular NUMA node, and varied number of submit_queues).
> 
> By eliminating multipath's heavy use of the m->lock spinlock in the
> fast IO paths serious performance improvements are realized.

Hi Mike,

Are this the patches you pointed Hannes to?

If yes, please add my Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
