From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] move cmd_filter from gendisk to request_queue
Date: Thu, 31 Jul 2008 14:13:51 +0900
Message-ID: <20080731141345M.fujita.tomonori@lab.ntt.co.jp>
References: <1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4890CACE.8010407@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39488 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbYGaFO1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 01:14:27 -0400
In-Reply-To: <4890CACE.8010407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pjones@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, dan.j.williams@intel.com, adel.gadllah@gmail.com, viro@ZenIV.linux.org.uk, dougg@torque.net, matthew@wil.cx

On Wed, 30 Jul 2008 16:10:54 -0400
Peter Jones <pjones@redhat.com> wrote:

> FUJITA Tomonori wrote:
> 
> > diff --git a/block/bsg.c b/block/bsg.c
> > index 5a68b09..6c5c6f3 100644
> > --- a/block/bsg.c
> > +++ b/block/bsg.c
> ...
> > @@ -87,6 +85,7 @@ struct bsg_command {
> >  	int err;
> >  	struct sg_io_v4 hdr;
> >  	char sense[SCSI_SENSE_BUFFERSIZE];
> > +	int has_write_perm;
> >  };
> >  
> >  static void bsg_free_command(struct bsg_command *bc)
> 
> Why is this added?  It never seems to be used.

Oops, I just forgot to remove it. Thanks.

I've updated a fixed version of the patchset:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git cmdfilter

