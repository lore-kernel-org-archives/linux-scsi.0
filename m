From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 18/28] scsi/lpfc/lpfc_init.c: remove unused variable
Date: Tue, 22 May 2007 14:04:02 -0500
Message-ID: <1179860642.3738.45.camel@mulgrave.il.steeleye.com>
References: <200705110601.l4B612QA008169@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58892 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966733AbXEVTEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 15:04:07 -0400
In-Reply-To: <200705110601.l4B612QA008169@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de

On Thu, 2007-05-10 at 23:01 -0700, akpm@linux-foundation.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Actually, not against vanilla linus:

drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_pci_probe_one':
drivers/scsi/lpfc/lpfc_init.c:1581: error: 'retval' undeclared (first use in this function)
drivers/scsi/lpfc/lpfc_init.c:1581: error: (Each undeclared identifier is reported only once
drivers/scsi/lpfc/lpfc_init.c:1581: error: for each function it appears in.)

There's probably some global change in -mm that makes pci_set_mwi()
return void ... in which case, this needs to be swept up into it.

James


