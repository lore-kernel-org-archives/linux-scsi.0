From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: Thu, 13 Jan 2005 12:14:57 -0700
Message-ID: <91888D455306F94EBD4D168954A9457CD321AC@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50604 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261390AbVAMTPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 14:15:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Saturday, January 08, 2005 2:33 PM, James Bottomley wrote:
> Actually, I think I'd like this to be a clean modularisation, 
> so the SPI
> functions go in one piece, the FC functions in another and the SAS
> functions in yet a third.  Then everything could depend on the core
> fusion engine for the interface with firmware.  That would allow:
> 
> - the transport classes to attach correctly,
> - the transport dependent functions (which currently litter the driver
> as if (spi) else if(fc) to be contained individually
> - and the PCI ID's which will drive the installer and upgrade 
> processes
> to be stored in the transport dependent pieces.
> 

I agree, and I begun getting others on the same page here.
I will be investigating this design soon. Thanks.
Although, we soon will have some other updates I would like to get
out ahead of this, one of them requested by hch@.

> optionally the mptlan module.  If I read mptctl right, it only
> implements the RAID ioctl features, so it could likewise be optional.
> 

mptctl is raid ioctl's and more.  
We provide our fw(firmware) passthru interface to applications, as
well as fw wrappers.

Eric
