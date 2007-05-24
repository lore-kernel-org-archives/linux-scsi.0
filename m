From: Christoph Lameter <clameter@sgi.com>
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
Date: Thu, 24 May 2007 09:59:01 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705240958380.28086@schroedinger.engr.sgi.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59969 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbXEXQ7C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 12:59:02 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Aubrey Li <aubreylee@gmail.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Thu, 24 May 2007, Salyzyn, Mark wrote:

> So, is the sequence:
> 
> 	p = kmalloc(upsg->sg[i].count,GFP_KERNEL);
> 	. . .
> 	addr = pci_map_single(dev->pdev, p, upsg->sg[i].count,
> data_dir);
> 
> Going to ensure that we have a 31 bit (not 32 bit) physical address?

Only if you have less than 2G of memory. So no.

