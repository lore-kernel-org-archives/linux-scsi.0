From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Tue, 18 Nov 2003 01:04:25 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311180052380.2258-100000@poirot.grange>
References: <20031117232829.GR30120@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:48798 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262315AbTKRAFl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 19:05:41 -0500
In-Reply-To: <20031117232829.GR30120@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org, gl@dsa-ac.de

On Tue, 18 Nov 2003, Kurt Garloff wrote:

> Hmm, the INQUIRY did not yield any data :-(
> pci_unmap() or at least pci_sync happened at that moment already?

Well, I just realised, that I don't, actually, unmap at the right place,
this has to be fixed, so, no, don't think, it can be a problem...:-( I
thought, it had to be done on DMA_XFER_DONE interrupt, but it is actually
commented out with

#define DMA_INT 0
#if DMA_INT
...
#endif

Thanks
Guennadi
---
Guennadi Liakhovetski


