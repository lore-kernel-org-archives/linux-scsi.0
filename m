From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove target parent limitiation
Date: Fri, 13 Jan 2006 19:24:01 +0100
Message-ID: <20060113182401.GA4106@lst.de>
References: <20060113180400.GA3509@lst.de> <43C7EFCA.4020908@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:23006 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422785AbWAMSYR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:24:17 -0500
Content-Disposition: inline
In-Reply-To: <43C7EFCA.4020908@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, Eric.Moore@lsil.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

> Should we remove the target_parent callout from the trasnport_template 
> since it is no longer used or does it make sense to keep it as part of 
> the API?

In the patch I have hear I did that:

-       struct device *(*target_parent)(struct Scsi_Host *, int, uint);
+       int (*user_scan)(struct Scsi_Host *, uint, uint, uint);
