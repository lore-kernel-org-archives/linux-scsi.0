From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/16] gdth: clean up host private data
Date: Sun, 30 Sep 2007 22:23:00 +0100
Message-ID: <20070930212300.GB13343@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <470001CF.4090801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53568 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXI3VYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 17:24:18 -0400
Content-Disposition: inline
In-Reply-To: <470001CF.4090801@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30, 2007 at 10:06:39PM +0200, Boaz Harrosh wrote:
> 
>   - Get rid of all the indirection in the Scsi_Host private data and always
>     put the gdth_ha_str directly into it.
> 
>   - Change all internal functions prototype to recieve an "gdth_ha_str *ha"
>     pointer directlly and kill all that redundent access to the "gdth_ctr_tab[]"
>     controller-table.

I somewhere had a patch to do that item 2 as a separate patch.  But it's
fine with me to have it as one if that makes it easier for you.

