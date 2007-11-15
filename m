From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH resend] scsi tgt: fix build when dprintk is defined
Date: Wed, 14 Nov 2007 23:36:38 -0600
Message-ID: <473BDAE6.4030309@cs.wisc.edu>
References: <20071114165236.54f93155.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44678 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbXKOFkE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Nov 2007 00:40:04 -0500
In-Reply-To: <20071114165236.54f93155.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: jejb <james.bottomley@steeleye.com>, scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, FUJITA Tomonori <tomof@acm.org>

Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix scsi_tgt_lib build when dprintk is defined:

> @@ -617,7 +617,7 @@ int scsi_tgt_kspace_it_nexus_rsp(int hos
>  	struct Scsi_Host *shost;
>  	int err = -EINVAL;
>  
> -	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
> +	dprintk("%d %d\n", host_no, result);
>  

Is there a correct kernel macro or value to use when the variable is 
u64/uint64_t? Something like PRIu64 in userspace?
