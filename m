From: Andre Tomt <andre@tomt.net>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.rc2
Date: Fri, 28 May 2004 10:58:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B6FF30.4040308@tomt.net>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC694@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050003090705050805080709"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.skjellin.no ([80.239.42.66]:46237 "HELO mail.skjellin.no")
	by vger.kernel.org with SMTP id S262370AbUE1I6Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 04:58:25 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC694@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Marcelo Tosatti' <marcelo.tosatti@cyclades.com>, 'Matthew Wilcox' <willy@debian.org>, 'Arjan van de Ven' <arjanv@redhat.com>, 'Christoph Hellwig' <hch@infradead.org>, "'matt_domsch@dell.com'" <matt_domsch@dell.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'paul@wagland.net'" <paul@wagland.net>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "Prabhakaran, Rajesh" <rajeshpr@lsil.com>, "Jose, Manoj" <Manojj@lsil.com>

This is a multi-part message in MIME format.
--------------050003090705050805080709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Mukker, Atul wrote:
> The patch for lk 2.6.6 and the driver is available at
> 
> ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.0.rc2/

2.6.6 patch is missing vital drivers/scsi/Makefile part.

-- 
Cheers,
André Tomt

--------------050003090705050805080709
Content-Type: text/x-diff;
 name="31_scsidrv_megaraid-2.20.0.rc2-missing-makefile-bit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="31_scsidrv_megaraid-2.20.0.rc2-missing-makefile-bit.patch"

diff -Naur linux-2.6.7-rc1-bk4-s1/drivers/scsi/Makefile linux-2.6.7-rc1-bk4-s1-1/drivers/scsi/Makefile
--- linux-2.6.7-rc1-bk4-s1/drivers/scsi/Makefile	2004-05-28 04:07:43.000000000 +0200
+++ linux-2.6.7-rc1-bk4-s1-1/drivers/scsi/Makefile	2004-05-28 07:57:52.000000000 +0200
@@ -96,7 +96,8 @@
 obj-$(CONFIG_SCSI_EATA)		+= eata.o
 obj-$(CONFIG_SCSI_DC395x)	+= dc395x.o
 obj-$(CONFIG_SCSI_DC390T)	+= tmscsim.o
-obj-$(CONFIG_SCSI_MEGARAID)	+= megaraid.o
+obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
+obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
 obj-$(CONFIG_SCSI_SUNESP)	+= esp.o
 obj-$(CONFIG_SCSI_GDTH)		+= gdth.o

--------------050003090705050805080709--
