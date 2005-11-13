From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] - mptfusion - fix mapping for transport (FC/SPI/SAS) supp ort
Date: Sun, 13 Nov 2005 13:34:14 +0000
Message-ID: <20051113133414.GA7539@infradead.org>
References: <91888D455306F94EBD4D168954A9457C04DEBFC7@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33979 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932456AbVKMNeV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 08:34:21 -0500
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C04DEBFC7@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, hch@infradead.org

On Fri, Nov 11, 2005 at 04:47:42PM -0700, Moore, Eric Dean wrote:
> Here is a patch for review.
> 
> This is to fix proper mid-layer to mpt fw mapping. 
> This is in preparation for James Bottomley's 
> SPI and RAID transport, and SGI's FC Transport support.
> The SAS mapping implementation is currently broken in several
> areas, to include error handling, which this patch fix's.   
> 
> The hd->Target[] data area will go away once
> in driver domain validation is replaced with 
> James SPI transport support.  This is replaced with
> the usage of scsi_device->hostdata and 
> scsi_target->hostdata. I've added support for 
> scsi_host->target_alloc and scsi_host->target_destroy.
> You will notice that hd->Target[] only is 
> present in the domain validation path.
> 
> I've also added scsi_host->module = THIS_MODULE, so 
> you will not be able to unload the driver when file handle is open. 

The patch looks good.  would be nice to get this into 2.6.15 still
as it definitly is a bug-fix.

