From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: fix EEH recovery
Date: Fri, 27 Nov 2009 10:58:23 -0200
Message-ID: <1259326703.26087.13.camel@zeppelin>
References: <1259187223.4938.45.camel@zeppelin>
	 <4B0F2F87.9070804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:40336 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZK0M6W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Nov 2009 07:58:22 -0500
Received: from mailhub1.br.ibm.com (mailhub1.br.ibm.com [9.18.232.109])
	by e24smtp01.br.ibm.com (8.14.3/8.13.1) with ESMTP id nARDAohS000573
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2009 11:10:50 -0200
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by mailhub1.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nARCxnnd864724
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2009 10:59:49 -0200
Received: from d24av01.br.ibm.com (d24av01 [127.0.0.1])
	by d24av01.br.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nARC68FU022077
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2009 10:06:09 -0200
In-Reply-To: <4B0F2F87.9070804@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Brian King <brking@linux.vnet.ibm.com>, Wayne Boyer <wayneb@linux.vnet.ibm.com>

On Thu, 2009-11-26 at 19:46 -0600, Brian King wrote:
> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> 
> > 
> > Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
> > ---
> >  drivers/scsi/ipr.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> > index 76d294f..c3ff9a6 100644
> > --- a/drivers/scsi/ipr.c
> > +++ b/drivers/scsi/ipr.c
> > @@ -6516,6 +6516,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
> >  	int rc;
> > 
> >  	ENTER;
> > +	ioa_cfg->pdev->state_saved = true;
> >  	rc = pci_restore_state(ioa_cfg->pdev);
> > 
> >  	if (rc != PCIBIOS_SUCCESSFUL) {
> 
> 

Since this is a regression, is there any chance to have this patch
applied and merged for 2.6.32?


Thanks,

-- 
Kleber S. Souza
IBM Linux Technology Center

