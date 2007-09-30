From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/16] gdth: make some virt ctrlr code common
Date: Sun, 30 Sep 2007 22:22:01 +0100
Message-ID: <20070930212201.GA13343@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <470000B4.1060504@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53558 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXI3VWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 17:22:18 -0400
Content-Disposition: inline
In-Reply-To: <470000B4.1060504@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30, 2007 at 10:01:56PM +0200, Boaz Harrosh wrote:
> 
>   * New function gdth_register_virt() replaces the three
>     basically-duplicate copies of virtual controller registration.

I think we can just kill this one if 8/16 goes in..

