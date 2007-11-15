From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH resend] scsi tgt: fix build when dprintk is defined
Date: Wed, 14 Nov 2007 22:15:36 -0800
Message-ID: <20071114221536.ac172633.randy.dunlap@oracle.com>
References: <20071114165236.54f93155.randy.dunlap@oracle.com>
	<473BDAE6.4030309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:33053 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762391AbXKOGQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 01:16:29 -0500
In-Reply-To: <473BDAE6.4030309@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: jejb <james.bottomley@steeleye.com>, scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, FUJITA Tomonori <tomof@acm.org>

On Wed, 14 Nov 2007 23:36:38 -0600 Mike Christie wrote:

> Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Fix scsi_tgt_lib build when dprintk is defined:
> 
> > @@ -617,7 +617,7 @@ int scsi_tgt_kspace_it_nexus_rsp(int hos
> >  	struct Scsi_Host *shost;
> >  	int err = -EINVAL;
> >  
> > -	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
> > +	dprintk("%d %d\n", host_no, result);
> >  
> 
> Is there a correct kernel macro or value to use when the variable is 
> u64/uint64_t? Something like PRIu64 in userspace?

Not that I'm aware of.  There has been some discussion of it,
but that's all I've seen.

---
~Randy
