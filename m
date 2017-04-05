From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [lpfc 05/19] Fix driver unload/reload operation.
Date: Wed, 5 Apr 2017 10:30:37 -0300
Message-ID: <3b1f61b8-e8bb-84b7-0a94-a7b1c2b98545@linux.vnet.ibm.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
 <1491326232-11255-6-git-send-email-rkennedy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50915 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754342AbdDENbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 09:31:20 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v35DT52t054156
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 09:31:19 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29mytgp14v-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 09:31:19 -0400
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 5 Apr 2017 10:31:17 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v35DVA8x32375024
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 10:31:15 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v35DUtjL006724
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 10:30:55 -0300
In-Reply-To: <1491326232-11255-6-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@broadcom.com>

Hi Dick,

If you don't mind me being pedantic, I've noticed a couple of things.

First, is your different email addresses in from/signed-off-by lines:

On 04/04/2017 02:16 PM, Dick Kennedy wrote:
> From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>
[...]
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>

Second, is there are several indentation/line-break changes in this
'fix' patch too, of which at least one seems inconsistent in the code
(see below) -- that would be better split off to another patch IMHO.

Maybe that would be covered in the scrubbing process you mentioned in
the other/regression thread.


> @@ -10312,6 +10315,7 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
>  	}
>
>  	/* Initialize and populate the iocb list per host */
> +
>  	error = lpfc_init_iocb_list(phba, LPFC_IOCB_LIST_CNT);
>  	if (error) {
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> @@ -11092,7 +11096,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
>  	}
>
>  	/* Initialize and populate the iocb list per host */
> -
>  	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>  			"2821 initialize iocb list %d.\n",
>  			phba->cfg_iocb_cnt*1024);


cheers,


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
