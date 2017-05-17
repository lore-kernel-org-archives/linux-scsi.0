From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 02/15] lpfc: Fix system crash when port is reset.
Date: Wed, 17 May 2017 19:06:16 -0300
Message-ID: <85ccdd5a-3466-ed7e-4d61-b59e9d8233de@linux.vnet.ibm.com>
References: <20170515222052.26004-1-jsmart2021@gmail.com>
 <20170515222052.26004-3-jsmart2021@gmail.com>
 <73cdc776-8eea-b63b-89af-ffa9829e1f9d@linux.vnet.ibm.com>
 <c2bf3df0-e65e-2f1c-5bb7-cb5b62697e30@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57641 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753658AbdEQWG0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 May 2017 18:06:26 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4HM1TX7050334
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 18:06:26 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2agsbdew2q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 18:06:25 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Wed, 17 May 2017 19:06:23 -0300
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4HM6LXI1901000
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 19:06:21 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4HM6LTV005817
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 19:06:22 -0300
In-Reply-To: <c2bf3df0-e65e-2f1c-5bb7-cb5b62697e30@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com, linux-nvme@lists.infradead.org
Cc: raphasil@linux.vnet.ibm.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On 05/17/2017 03:49 PM, James Smart wrote:
> Your patch is still needed.  Can you repost your patch with a new 
> subject and add my signature:
> 
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> Sorry, I didn't see it to roll it into the set.

No problem James, already sent it to linux-scsi:
https://marc.info/?l=linux-scsi&m=149505857715991

Cheers,


Guilherme

> 
> -- james
> 
> 
> 
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme
> 
