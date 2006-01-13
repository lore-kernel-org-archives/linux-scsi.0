From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] remove target parent limitiation
Date: Fri, 13 Jan 2006 12:27:54 -0600
Message-ID: <43C7F12A.5060501@cs.wisc.edu>
References: <20060113180400.GA3509@lst.de> <43C7EFCA.4020908@cs.wisc.edu> <20060113182401.GA4106@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37810 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1422806AbWAMS2M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:28:12 -0500
In-Reply-To: <20060113182401.GA4106@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, Eric.Moore@lsil.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>>Should we remove the target_parent callout from the trasnport_template 
>>since it is no longer used or does it make sense to keep it as part of 
>>the API?
> 
> 
> In the patch I have hear I did that:
> 
> -       struct device *(*target_parent)(struct Scsi_Host *, int, uint);
> +       int (*user_scan)(struct Scsi_Host *, uint, uint, uint);

oops sorry.
