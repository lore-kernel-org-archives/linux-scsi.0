From: Raphael Philipe Mendes da Silva <raphasil@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: lpfc: Fix crash on PCI hotplug remove path
Date: Mon, 29 May 2017 18:32:37 -0300
Message-ID: <20170529213236.GA14650@raphasil>
References: <20170528214554.24336-1-gpiccoli@linux.vnet.ibm.com>
 <cdc85e21-caf1-aeb6-a24f-dac063e66c5a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751053AbdE2Vcu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 May 2017 17:32:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4TLSivS053744
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2017 17:32:49 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2arujbr4kq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2017 17:32:49 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <raphasil@linux.vnet.ibm.com>;
        Mon, 29 May 2017 18:32:47 -0300
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4TLWiL52359614
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2017 18:32:44 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
        by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4TLWiMb024566
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2017 18:32:45 -0300
Content-Disposition: inline
In-Reply-To: <cdc85e21-caf1-aeb6-a24f-dac063e66c5a@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com, porcusbr@gmail.com

On Mon, May 29, 2017 at 09:56:09AM +0200, Johannes Thumshirn wrote:
> On 05/28/2017 11:45 PM, Guilherme G. Piccoli wrote:
> > During a PCI hotplug remove event we could have a NULL pointer
> > dereference on lpfc_sli_abort_iocb(), if pring is NULL. This
> > patch adds a check for this case and is able to circumvent the
> > failure and continue the hotplug remove process with success.
> > 
> > This issue was introduced after the driver refactor made on
> > commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications").
> > 
> > Fixes: 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
> > Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
> > Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> > ---
> 
> Looks good,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Tested-by: Raphael Silva <raphasil@linux.vnet.ibm.com>
