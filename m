From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [RFC v2 PATCH 0/19] A kernel-level configfs enabled generic
 target engine for Linux v2.6.32
Date: Fri, 18 Sep 2009 18:15:25 -0700
Message-ID: <1253322925.6699.8.camel@desktop>
References: <1253311656.4498.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:40510 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZISBPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 21:15:23 -0400
In-Reply-To: <1253311656.4498.143.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>

On Fri, 2009-09-18 at 15:07 -0700, Nicholas A. Bellinger wrote:
> Greetings all,
> 
> This is the second round of request for comments for TCM/ConfigFS v3.2
> from lio-core-2.6.git.
> Thanks to the folks who made comments, and I again invite people to
> take a look and make
> recommendations on how the code can be futher improved to use the best
> available upstream
> interfaces.

There are still a couple of minor checkpatch errors in the series, but
it's nothing you would need to resubmit because of ..

In patch 2 the following are fixable,

ERROR: return is not a function, parentheses are not required
#3401: FILE: include/target/configfs_macros.h:104:
+       return((ci) ? container_of(to_config_group(ci), struct _item,   \

ERROR: trailing whitespace
#3438: FILE: include/target/configfs_macros.h:141:
+CONFIGFS_EATTR_OPS_STORE(_name, _item);^I$


and in Patch 18, and 19 there are a couple more whitespace related
errors you could fix..

Daniel

