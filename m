From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Mon, 12 May 2003 14:49:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030512214902.GD3226@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com> <1052711864.1768.7.camel@mulgrave> <20030512063833.GA4133@beaverton.ibm.com> <1052761851.2093.55.camel@mulgrave> <1052762365.2148.59.camel@mulgrave> <20030512184140.GB3226@beaverton.ibm.com> <1052770234.1769.75.camel@mulgrave> <20030512203507.GC3226@beaverton.ibm.com> <1052772136.1769.103.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:6327 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262810AbTELVd6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 17:33:58 -0400
Content-Disposition: inline
In-Reply-To: <1052772136.1769.103.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, mochel@osdl.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> > What slab size? (size-512)
> 
> size-4096
> 

I am seeing size-512 with my modified version of scsi_debug. I modified
slab.c to store last user for this size and it indicates it was
scsi_free_shost. I am looking at this now.

-andmike
--
Michael Anderson
andmike@us.ibm.com

