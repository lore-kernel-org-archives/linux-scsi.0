From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device driver for new sequence firmware.
Date: Wed, 31 Jan 2007 09:56:03 +0000
Message-ID: <20070131095603.GB3200@infradead.org>
References: <89FD792A883D4B47AD469FEA2E5D1F9B0F59B6@aime2k302.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56296 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920AbXAaJ4E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 04:56:04 -0500
Content-Disposition: inline
In-Reply-To: <89FD792A883D4B47AD469FEA2E5D1F9B0F59B6@aime2k302.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 30, 2007 at 03:31:25PM -0800, Wu, Gilbert wrote:
> Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
> driver for new sequence firmware.
> 
>  
> 
> Contribution:
> 
>    Ed Chim <ed_chim@adaptec.com>
>    Gilbert Wu <gilbert_wu@adaptec.com>
> 
> Change Log:
>  
> 1.    Use dword instead of qword to display the value of Connection
> State register for debug purpose.
> 
> 2.    There are some registers location of AIC94xx chip has been changed
> according to the new V28 firmware. The patch has redefined the register
> location and provided initialization.

These look like incompatible changes, so you should make sure the driver
still works when it detects the old firmware.
