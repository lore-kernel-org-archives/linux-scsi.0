From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: Fri, 25 Jun 2004 09:13:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040625081335.GA26302@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC7CA@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:41908 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266335AbUFYINj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 04:13:39 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC7CA@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, Jun 24, 2004 at 09:07:48PM -0400, Mukker, Atul wrote:
> Christoph,
> 
> I have put the revised driver on the ftp server
> 
> ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.0.1/
> 
> This driver incorporates almost all your suggestions. I think it's high
> time, the driver makes into the mainstream kernel.

Oh well, let's include it and I'll fix up some minor cruft later on.
Note that changes to drivers/pci/pci.ids should be sent separately to
pci-ids@ucw.cz (see http://pciids.sourceforge.net/ for defails)
