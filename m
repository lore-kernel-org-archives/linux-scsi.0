From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Wed, 5 Jan 2005 11:19:18 +0000
Message-ID: <20050105111918.GB30954@infradead.org>
References: <B51CDBDEB98C094BB6E1985861F53AF302DE45@nkse2k01.adaptec.com> <1104831161.4215.17.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:38032 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262329AbVAELTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 06:19:21 -0500
Content-Disposition: inline
In-Reply-To: <1104831161.4215.17.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Leubner, Achim" <Achim_Leubner@adaptec.com>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 04, 2005 at 10:32:41AM +0100, Arjan van de Ven wrote:
> On Tue, 2005-01-04 at 10:29 +0100, Leubner, Achim wrote:
> > You are right, in gdth_fill_raw_command() the driver is doing two
> > different dma mappings, one for the data buffer stored in
> > SCp.dma_handle, and the second for the sense buffer stored in SCp.buffer
> > and host_scribble. So reuse of dma_handle does not work here.
> 
> Is there a way the driver can get rid of looking at the sense buffer at
> all and let the midlayer do this ?

The driver needs to fill the sense buffer ;-)

