Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F319C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7A7E21897
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGNI0t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:26:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbgGNI0r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 04:26:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06E82v2n056879;
        Tue, 14 Jul 2020 04:26:38 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3279k40rya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 04:26:37 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06E8KHHf009619;
        Tue, 14 Jul 2020 08:26:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 327527hjn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 08:26:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06E8QWcQ62062740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 08:26:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A475B4C050;
        Tue, 14 Jul 2020 08:26:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F3904C044;
        Tue, 14 Jul 2020 08:26:32 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.164.206])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 14 Jul 2020 08:26:32 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jvGGl-001PYC-Eb; Tue, 14 Jul 2020 10:26:31 +0200
Date:   Tue, 14 Jul 2020 10:26:31 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: Rename slave_configure to sdev_configure
Message-ID: <20200714082631.GB7244@t480-pf1aa2c2>
References: <20200706193920.6897-1-willy@infradead.org>
 <20200706193920.6897-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200706193920.6897-4-willy@infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_01:2020-07-13,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007140058
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Matthew,

On Mon, Jul 06, 2020 at 08:39:20PM +0100, Matthew Wilcox (Oracle) wrote:
> Match sdev_init() and sdev_destroy().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  Documentation/scsi/scsi_mid_low_api.rst   | 30 +++++++++++------------
>  drivers/s390/scsi/zfcp_scsi.c             |  4 +--
>  76 files changed, 200 insertions(+), 201 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 1f95c38738e3..67bd30d4f4cc 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -49,7 +49,7 @@ static void zfcp_scsi_sdev_destroy(struct scsi_device *sdev)
>  	put_device(&zfcp_sdev->port->dev);
>  }
>  
> -static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
> +static int zfcp_scsi_sdev_configure(struct scsi_device *sdp)
>  {
>  	if (sdp->tagged_supported)
>  		scsi_change_queue_depth(sdp, default_depth);
> @@ -428,7 +428,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
>  	.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
>  	.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
>  	.sdev_prep		 = zfcp_scsi_sdev_prep,
> -	.slave_configure	 = zfcp_scsi_slave_configure,
> +	.sdev_configure	 = zfcp_scsi_sdev_configure,

Please fix the alignment.

>  	.sdev_destroy		 = zfcp_scsi_sdev_destroy,
>  	.change_queue_depth	 = scsi_change_queue_depth,
>  	.host_reset		 = zfcp_scsi_sysfs_host_reset,


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
