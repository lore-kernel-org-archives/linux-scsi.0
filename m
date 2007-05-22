From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 18/28] scsi/lpfc/lpfc_init.c: remove unused variable
Date: Tue, 22 May 2007 12:34:00 -0700
Message-ID: <20070522123400.8acc4e1f.akpm@linux-foundation.org>
References: <200705110601.l4B612QA008169@shell0.pdx.osdl.net>
	<1179860642.3738.45.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727AbXEVTf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2007 15:35:59 -0400
In-Reply-To: <1179860642.3738.45.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de

On Tue, 22 May 2007 14:04:02 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Thu, 2007-05-10 at 23:01 -0700, akpm@linux-foundation.org wrote:
> > From: Adrian Bunk <bunk@stusta.de>
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Actually, not against vanilla linus:
> 
> drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_pci_probe_one':
> drivers/scsi/lpfc/lpfc_init.c:1581: error: 'retval' undeclared (first use in this function)
> drivers/scsi/lpfc/lpfc_init.c:1581: error: (Each undeclared identifier is reported only once
> drivers/scsi/lpfc/lpfc_init.c:1581: error: for each function it appears in.)
> 
> There's probably some global change in -mm that makes pci_set_mwi()
> return void ... in which case, this needs to be swept up into it.
> 

yep, sorry.  I rebadged this patch as being
"after Greg merges add-pci_try_set_mwi.patch"
