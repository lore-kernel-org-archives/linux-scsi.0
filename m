From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] clean up drivers/scsi/scsi.h
Date: Mon, 14 Feb 2005 12:32:29 +0100
Message-ID: <200502141232.30212@bilbo.math.uni-mannheim.de>
References: <200502141157.30447@bilbo.math.uni-mannheim.de> <20050214110958.GB2367@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Received: from mail.sf-mail.de ([62.27.20.61]:51089 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S261415AbVBNL1f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 06:27:35 -0500
Received: from bilbo.math.uni-mannheim.de ([::ffff:134.155.88.153]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.3pre) with (RC4-MD5 encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2005 12:27:32 +0100
In-Reply-To: <20050214110958.GB2367@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Am Montag, 14. Februar 2005 12:09 schrieb Christoph Hellwig:
> On Mon, Feb 14, 2005 at 11:57:29AM +0100, Rolf Eike Beer wrote:
> > Hi,
> >
> > this patch removes some useless struct declarations from
> > drivers/scsi/scsi.h. All this structs are already defined in the header
> > files included above except Scsi_Host, for which we now directly include
> > <scsi/scsi_host.h>
>
> No, this is totally wrong.  If you only use pointers to structs always
> use forward declarations instead of pulling in a full header.

Ok, this time without include scsi/scsi_host.h. The rest remains untouched,
"struct Scsi_Host;" is also in scsi/scsi_device.h. The header files for all 
other structs are already included so no need do declare them again.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

--- linux-2.6.10/drivers/scsi/scsi.h	2004-12-24 22:34:27.000000000 +0100
+++ linux-2.6.10/drivers/scsi/scsi.h-new	2005-02-14 11:45:54.000000000 +0100
@@ -40,12 +40,6 @@
 #define FALSE 0
 #endif
 
-struct Scsi_Host;
-struct scsi_cmnd;
-struct scsi_device;
-struct scsi_target;
-struct scatterlist;
-
 /*
  * Legacy dma direction interfaces.
  *
