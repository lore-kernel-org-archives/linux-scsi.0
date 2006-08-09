From: Doug Maxey <dwm@enoyolf.org>
Subject: Re: [PATCH ver3 3/4] qla4xxx: use dev_xxx on some pci/dma resource alloc warning and error printks
Date: Wed, 09 Aug 2006 14:03:44 -0500
Message-ID: <20060809190344.66598@bebe.enoyolf.org>
References: <20060805225156.9557.99072.stgit@bebe.enoyolf.org> <20060805225227.9557.30796.stgit@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:35983 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751322AbWHITI3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Aug 2006 15:08:29 -0400
In-reply-to: <44DA20C7.7030302@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Doug Maxey <dwm@enoyolf.org>, Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org


On Wed, 09 Aug 2006 13:52:07 EDT, Mike Christie wrote:
...
> >  	if (ha->srb_mempool == NULL) {
> > -		ql4_printk(KERN_WARNING, ha,
> > -			   "Memory Allocation failed - SRB Pool.\n");
> > -
> > +		dev_warn(&ha->pdev->dev,
> > +			 "Memory Allocation failed - SRB Pool.\n");
> >  		goto mem_alloc_error_exit;
> 
> Sorry for the late response on this one. As you know I was out for a
> while and I was waiting to get internet access yesterday.
> 
> For these host messages, do we want something like the sdev_printk and
> starget_printk or does it really make more sense to use the pci bus id
> for the message prefix? What about other scsi host messages, will they
> always go with the pci bus id or some scsi-ml id? And even if we want to
> print out the pci bus id as the prefix instead of some scsi info, should
> we still have some scsi wrapper?
> 

Ha.  Just pre-replied to the this issue in the patchset just sent.

Will spin up an RFC patch and see where this goes.


