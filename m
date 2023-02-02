Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57149C636D3
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 23:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbjBBX67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 18:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjBBX66 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 18:58:58 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7795A7B415
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 15:58:57 -0800 (PST)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312NLDYn032651;
        Thu, 2 Feb 2023 23:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=k6GaHOlJ9YhmdN835UHiW+78nE8ZYSZaXx5O9ZfMgMc=;
 b=K4zjh6fgH679se5hpx6IcZsOwBUM52Cz84g2cP4KW/YzeVX19TavxDSy6IjkdPQP+uab
 7msue7pLlVRpGls/R1ptzZrNuioymfJnjr6awPEoIcAfC0hdYRfZoVe6BL35ib1KF5yk
 IMMp1lbdEMhv3GExrN+G7MMmumyGxNGaBAoL8nMnZ7QKeG3Tlx4Y4PqvT9ZrdVBVUPkp
 +HoTgLH8TH2cLDl04SeUw/UwCK44r1/9Z93uf9EXdw9aNAUIambLWhJJsImhJBa4QEIB
 DZkjt5EjOLhokXLaLFhHUIqUV7M0rhMsM/hpdjAAVhf8jkugiQr8WOI1LEJeEbeEqK2o xQ== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nfqsyby9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 23:58:42 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 312NwfEl026206
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 2 Feb 2023 23:58:41 GMT
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 2 Feb 2023 15:58:40 -0800
Date:   Thu, 2 Feb 2023 15:58:40 -0800
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <quic_cang@quicinc.com>,
        "Manivannan Sadhasivam" <mani@kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix kernel-doc syntax
Message-ID: <20230202235840.GC14334@asutoshd-linux1.qualcomm.com>
References: <20230202220155.561115-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20230202220155.561115-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 7Ug0m26Xs7_HOgKw9BB3TiLxqXv1GqVm
X-Proofpoint-ORIG-GUID: 7Ug0m26Xs7_HOgKw9BB3TiLxqXv1GqVm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_15,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020213
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 02 2023 at 14:02 -0800, Bart Van Assche wrote:
>Fix the following kernel-doc warnings:
>
>drivers/ufs/core/ufs-mcq.c:87: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_config_mac'
>drivers/ufs/core/ufs-mcq.c:87: warning: Function parameter or member 'max_active_cmds' not described in 'ufshcd_mcq_config_mac'
>drivers/ufs/core/ufs-mcq.c:107: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_req_to_hwq'
>drivers/ufs/core/ufs-mcq.c:107: warning: Function parameter or member 'req' not described in 'ufshcd_mcq_req_to_hwq'
>drivers/ufs/core/ufs-mcq.c:128: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_decide_queue_depth'
>
>Cc: Asutosh Das <quic_asutoshd@quicinc.com>
>Fixes: 854f84e7feeb ("scsi: ufs: core: mcq: Find hardware queue to queue request")
>Fixes: 2468da61ea09 ("scsi: ufs: core: mcq: Configure operation and runtime interface")
>Fixes: 7224c806876e ("scsi: ufs: core: mcq: Calculate queue depth")
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---
> drivers/ufs/core/ufs-mcq.c | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>
Thanks for the fix.

Reviewed-by: Asutosh Das <quic_asutoshd@quicinc.com>


>diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
>index dd476f9e797c..31df052fbc41 100644
>--- a/drivers/ufs/core/ufs-mcq.c
>+++ b/drivers/ufs/core/ufs-mcq.c
>@@ -77,8 +77,8 @@ MODULE_PARM_DESC(poll_queues,
>
> /**
>  * ufshcd_mcq_config_mac - Set the #Max Activ Cmds.
>- * @hba - per adapter instance
>- * @max_active_cmds - maximum # of active commands to the device at any time.
>+ * @hba: per adapter instance
>+ * @max_active_cmds: maximum # of active commands to the device at any time.
>  *
>  * The controller won't send more than the max_active_cmds to the device at
>  * any time.
>@@ -96,8 +96,8 @@ void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds)
> /**
>  * ufshcd_mcq_req_to_hwq - find the hardware queue on which the
>  * request would be issued.
>- * @hba - per adapter instance
>- * @req - pointer to the request to be issued
>+ * @hba: per adapter instance
>+ * @req: pointer to the request to be issued
>  *
>  * Returns the hardware queue instance on which the request would
>  * be queued.
>@@ -114,7 +114,7 @@ struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
>
> /**
>  * ufshcd_mcq_decide_queue_depth - decide the queue depth
>- * @hba - per adapter instance
>+ * @hba: per adapter instance
>  *
>  * Returns queue-depth on success, non-zero on error
>  *
