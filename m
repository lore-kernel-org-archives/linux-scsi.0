From: "Mukker, Atul" <Atulm@lsil.com>
Subject: [ANNOUNCE]: megaraid driver version 2.20.0.0
Date: Wed, 23 Jun 2004 16:00:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC7AC@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:11004 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266634AbUFWUAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 16:00:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Mukker, Atul" <Atulm@lsil.com>


All

The latest megaraid version 2.20.0.0 for 2.6.7 kernel has been released.
This driver incorporates most of the inputs provided by Christoph Hellwig on
linux-scsi on 5/28, which are much appreciated. 

In addition, a new capability has been added in the driver so that many
management applications can interface with the driver in parallel. Now up to
32 parallel ioctl can be issued to the driver instead of 1.

The driver patches are pretty big, so I am not attaching with the
announcement. The driver files can be downloaded from

ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.0.0/

This location has two packages, one contains the actual driver files plus
documentation. The other is a patch against the 2.6.7 kernel.

Thanks
-Atul Mukker
LSI Logic Corporation
