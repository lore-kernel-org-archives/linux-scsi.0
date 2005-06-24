From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 2/2] - mptfusion - FC Transport Support
Date: Fri, 24 Jun 2005 13:20:42 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C02DD9478@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5834 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263206AbVFXTVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2005 15:21:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

> 
> To be honest, if I could have killed it (target-based object
> in sysfs), I would have as part of the FC transport rework. There was
> unfortunately too many app side things (udev, etc) that refer to it.
> This object is really a lame-duck.
> 
> If you want real FC transport support, be sure to support all the new
> host attributes, and the remote port infrastructure as well.
> 

Yep, sure will.  I'm looking into adding the host_attrs, as well
as the rport attributes.  The target attributes I did about 7 months ago,
however there were delays due to the  driver needing to be split into
 separate bus type drivers; e.g. spi, fc, and sas.  I'd thought I'd
go ahead and submit what fc transport stuff we have already
implemented in our LSI Logic internal driver stream.

Thanks,
Eric Moore 
