From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/42 RESEND+NEW] Target updates for May 27
Date: Fri, 27 May 2011 16:39:23 -0700
Message-ID: <1306539563.23461.229.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306534540.23461.203.camel@haakon2.linux-iscsi.org>
	 <20110527223538.GA26592@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53777 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab1E0Xrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 19:47:41 -0400
In-Reply-To: <20110527223538.GA26592@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-iscsi-target-dev@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Fri, 2011-05-27 at 18:35 -0400, Christoph Hellwig wrote:
> Nick, Andi,
> 
> any chance we can get these patches posted to the list for review?
> 

I will send these out as they are committed into lio-core-2.6.git for
next week and will be sure to include you in the specific discussions if
we run into concerns.  Also Andy, please start including Christoph and
the scsi list on subsequent drivers/target/ patch series for LIO
upstream for more reviewer eyeballs..

Btw, the LIO v4.1 upstream tree has been diverging from mainline v4.0
drivers/target/ quite a bit recently, and a number these cleanups and
improvements that Andy has made are running behind the initial mainline
merge of iscsi-target.  This series is pretty obviously all non .40
stuff, but would have really liked to get more of Andy's cleanup of
target core ahead of an initial iscsi-target .40 merge, but these
improvements to target core and the rest of Andy's changes will have to
be .41 items.

--nab











