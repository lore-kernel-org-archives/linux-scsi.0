From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] sd: Check for unaligned partial completion
Date: Wed, 1 Mar 2017 19:09:06 -0300
Message-ID: <a06db0b0-7590-33d2-de98-3845d28d4c51@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33386 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752642AbdCAWJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 17:09:24 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v21M3beH038803
        for <linux-scsi@vger.kernel.org>; Wed, 1 Mar 2017 17:09:23 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28wxrb7bxb-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 17:09:22 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Wed, 1 Mar 2017 19:09:21 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.18.232.42])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id CE3981DC006F
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2017 17:09:19 -0500 (EST)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v21M9IS230212204
        for <linux-scsi@vger.kernel.org>; Wed, 1 Mar 2017 19:09:18 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v21M9G6U030623
        for <linux-scsi@vger.kernel.org>; Wed, 1 Mar 2017 19:09:17 -0300
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Cc: Ram Pai <linuxram@us.ibm.com>, Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.de>, bart.vanassche@sandisk.com

Looks good, thanks for the patch.


Reviewed-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>


Cheers,

Guilherme
