From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Thu, 6 Jan 2005 09:20:45 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57058C01B2@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62857 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262840AbVAFO2r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2005 09:28:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: 'Matt Domsch' <Matt_Domsch@Dell.com>, "'Salyzyn, Mark'" <mark_salyzyn@adaptec.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, 'Linux Kernel' <linux-kernel@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

> > the management app, there is no getting around knowing HCTL 
> mapping. 
> > The app must know the HCTL quad of a logical drive.
> 
> Actually, if that's all you're trying to do, what about
> 
> echo '- - -' > /sys/class/scsi_host/host<n>/scan
> 
> That'll trigger a rescan of the entire card and the device 
> will be found and added?
For this to happen, the applications must at lease know 'n' in host<n>,
otherwise it will have to trigger a rescan on all controllers. Which would
be an overkill. How about publishing the adapter class attribute as well?
This would allow applications to correlate the adapter handle with the class
attribute.

> 
> Then, if you simply publish your LD number as an extra 
> parameter of the device, you can look through /sys to find it.
Taken

Apologize for the late post, we were evaluating your feedback. It looks
good, thanks!


--------
Atul Mukker
Architect, Drivers and BIOS
LSI Logic Corporation
