From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Wed, 5 Jan 2005 11:19:00 +0000
Message-ID: <20050105111900.GA30954@infradead.org>
References: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:36752 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262327AbVAELTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 06:19:04 -0500
Content-Disposition: inline
In-Reply-To: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 04, 2005 at 10:29:15AM +0100, Leubner, Achim wrote:
> You are right, in gdth_fill_raw_command() the driver is doing two
> different dma mappings, one for the data buffer stored in
> SCp.dma_handle, and the second for the sense buffer stored in SCp.buffer
> and host_scribble. So reuse of dma_handle does not work here.
> And, you are right, this is ugly and brittle, but there is no remaining
> space in the SCp scratch area to save the second dma mapping.  
> The other patches look fine for me, thanks. But what's the reason to
> remove the support of 2.2.x and 2.4.x without the full dma API?

Too much noise in the driver for totally obsolete kernels.

