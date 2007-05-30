From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [patch 1/1] scsi: cover up bugs^W^W^WFix up compiler warnings in megaraid driver
Date: Tue, 29 May 2007 19:10:10 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229AE165A@NAMAIL2.ad.lsil.com>
References: <20070525144534.a76e59b8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63249 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXE3BK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 21:10:27 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070525144534.a76e59b8.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, mbligh@google.com

Hello Andrew,

	The email-id megaraidlinux@lsi.com is the alias for driver
developers for MegaRAID product. This id includes my name. Recently I
submitted patch to update the MAINTAINERS to add this id.	

Regards,

Sumant

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Friday, May 25, 2007 2:46 PM
To: Patro, Sumant
Cc: James.Bottomley@steeleye.com; linux-scsi@vger.kernel.org;
mbligh@google.com
Subject: Re: [patch 1/1] scsi: cover up bugs^W^W^WFix up compiler
warnings in megaraid driver

On Fri, 25 May 2007 14:28:19 -0600 "Patro, Sumant"
<Sumant.Patro@lsi.com> wrote:

> Ack.

Thanks.



While we're here...

box:/usr/src/25> grep -i lsi MAINTAINERS
LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
M:      Eric.Moore@lsi.com
M:      support@lsi.com
L:      mpt_linux_developer@lsi.com
W:      http://www.lsilogic.com/support
LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
W:      http://megaraid.lsilogic.com
USB KAWASAKI LSI DRIVER
M:      uclinux-v850@lsi.nec.co.jp

box:/usr/src/25> grep -i sumant MAINTAINERS   
box:/usr/src/25> 

Could I ask that you review the MAINTAINERS file and ensure that
all appropriate lsil developers are appropriately mentioned and that
all drivers which lsil look after have the appropriate entries?

Thanks.
