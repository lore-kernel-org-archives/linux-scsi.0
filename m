From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Thu, 9 Dec 2004 12:31:37 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57057A1B87@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41168 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261567AbULIRjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 12:39:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>
Cc: 'James Bottomley' <James.Bottomley@steeleye.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, 'Matt Domsch' <Matt_Domsch@Dell.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>

 
> > 8. So, all driver has to do to assist applications is to 
> provide the 
> > logical drive number to scsi address mapping. Application 
> would say, 
> > hey! I added/removed logical drive number 5, driver 
> reverts, here is 
> > the scsi address for it "host:2, channel:5, target:5 lun:0" :-)
> 
> How does the driver supply the mapping if it does not know 
> about the "change"? Is it reserving or telling user space the 
> hctl that will be used?
This point was thoroughly explained in my previous post item 2. Yes, driver
reserves a virtual bus on which all logical drives would be exported.

> 
> If so, why can't the driver call scsi_add_device(h,c,t,l) 
> after the ioctl to create the logical drive completes?
This idea was already turned down, see mails on linux-scsi on 12/3

> 
> Though I am all for using hotplug to initiate scanning from 
> user space.
good
