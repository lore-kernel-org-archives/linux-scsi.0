Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A2CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Dec 2021 14:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhLaOzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Dec 2021 09:55:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229474AbhLaOzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Dec 2021 09:55:11 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BVE7PIF002945;
        Fri, 31 Dec 2021 14:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=rAL1c/LW3RqyI8qBquY8tmfePAKq2eTxx9ygA8WbUV4=;
 b=dZHTg0bupItea1j4Dkvnq13fnOpwP1ubaWGfSdw7VvkfsF9ewpdE4bErNlVKGKm+BiVk
 nuuPa/BGPFjcpi87YYDAg2+CmoH6pSAwgfBnSZ4phjVcyY7QbZvyffnnoJ45tDxLvpKM
 TCDa2S4e9MWjT/owUuCQfx98L5OClO6/H2EkW2U1MTvjbtPwo9/5K22WTmv2S8ikwK5n
 f+yXLmRYLBs1MRqUgoWqQGUoKENMmfzXXbOI6bJyfvBsStdDnlAzGQ4+nMbKug1FUlu9
 fP52dd0ohg/q2YAM79AOij5eDFYhVATtTMoYPbUMxMd/sepC0cOD7p3kRSt+Ef4tLCVH MA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d9tme97cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Dec 2021 14:55:06 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BVEh7sa014214;
        Fri, 31 Dec 2021 14:55:05 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3d5txd53dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Dec 2021 14:55:05 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BVEt2oF27263436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Dec 2021 14:55:02 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 588BA78069;
        Fri, 31 Dec 2021 14:55:02 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FBC77805F;
        Fri, 31 Dec 2021 14:55:01 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.163.16.130])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 31 Dec 2021 14:55:01 +0000 (GMT)
Message-ID: <fca6717d704ffa33cfd9d3cba519da8705195858.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: lpfc: Terminate string in
 lpfc_debugfs_nvmeio_trc_write()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Fri, 31 Dec 2021 09:55:00 -0500
In-Reply-To: <20211214070527.GA27934@kili>
References: <20211214070527.GA27934@kili>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y89eHcrpjrzar0v_GrAvFoK2A2ZcQ0J2
X-Proofpoint-ORIG-GUID: y89eHcrpjrzar0v_GrAvFoK2A2ZcQ0J2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-31_05,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1011
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112310063
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-12-14 at 10:05 +0300, Dan Carpenter wrote:
> The "mybuf" string comes from the user, so we need to ensure that it
> is NUL terminated.
> 
> Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs
> support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c
> b/drivers/scsi/lpfc/lpfc_debugfs.c
> index 21152c9a96ef..30fac2f6fb06 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -2954,8 +2954,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file
> *file, const char __user *buf,
>  	char mybuf[64];
>  	char *pbuf;
>  
> -	if (nbytes > 64)
> -		nbytes = 64;
> +	if (nbytes > 63)
> +		nbytes = 63;

Just for future reference, next time could we do

if (nbytes > sizeof(mybuf) - 1)
        nbytes = sizeof(mybuf) - 1;

just so we minimize the possibility of screw ups in the unlikely event
that someone reduces the size of the mybuf array?

James


