From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] split private and public scsi headers
Date: Mon, 28 Apr 2003 10:08:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030428100819.A27762@beaverton.ibm.com>
References: <20030426233054.A22823@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:50424 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S261198AbTD1Q7w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2003 12:59:52 -0400
Content-Disposition: inline
In-Reply-To: <20030426233054.A22823@lst.de>; from hch@lst.de on Sat, Apr 26, 2003 at 11:30:54PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Apr 26, 2003 at 11:30:54PM +0200, Christoph Hellwig wrote:
> Two new headers:
> 
>   scsi_priv.h - for macros/declarations private to the scsi midlayer
> 		  (= not EXPORT_SYMBOL()ed)
>   scsi_logging.h - for SCSI_LOG_* and friends, semi-private to the
>   		midlayer and the upper drivers.  One abuse of this
> 		in dpt_i2o killed.

Hi -

I had to add an include of scsi_logging.h to compile with logging configured:

--- sm-inclsplit-hch/drivers/scsi/scsi_syms.c-orig	Mon Apr 28 09:47:50 2003
+++ sm-inclsplit-hch/drivers/scsi/scsi_syms.c	Mon Apr 28 09:59:48 2003
@@ -21,6 +21,7 @@
 #include "scsi.h"
 #include <scsi/scsi_ioctl.h>
 #include "hosts.h"
+#include "scsi_logging.h"
 
 #include <scsi/scsicam.h>
 
