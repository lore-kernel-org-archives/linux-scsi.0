Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC660C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 18:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91AE820E65
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 18:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D9G4Udrr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgIBSI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 14:08:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbgIBSIV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 14:08:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082I4DRn054459;
        Wed, 2 Sep 2020 18:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Nez1OfySY7AdFYyaBS2ZUulDdKe+PLw4PqdVhB/cfns=;
 b=D9G4UdrrK2a7MsMuuTLrl/qjhnNXNEwt94wCLcvOgxNgtIyL/zAgdT4bygrBxGBaQMtm
 HCKZzQUtm06X/8DiXQSMH8LrnugFjeLIEt4RE4N1lvdiKLiWhOho0QjIwHkQA6yHVg1x
 DIC/MaTFwsmQ3Qc+ZMXBSJ94oZBpCuNwe0o7IPtOwMkdL6GGzC9/i5YXy64zfAG6nQSh
 xWWC2ZGWngBcUEs+KkCFP7TQC8SCeHnQW3vLVImPipamI5uYwYFCqAYxiR50493kYHCi
 JCUMt0KDMgTpRcKFhBNnYsvH0Tq2dC2WgWlm3GRnztm96xr00oX67z1SQo8IEA6ZHn7I aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eymc935-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 18:08:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082I53i5151228;
        Wed, 2 Sep 2020 18:08:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3380sufene-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 18:08:15 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082I8EZc001157;
        Wed, 2 Sep 2020 18:08:15 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 11:08:14 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 13/13] qla2xxx: Update version to 10.02.00.102-k
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-14-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 13:08:13 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8CE024DD-B0DB-4C63-9DCF-DC90E7204495@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-14-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020170
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Update internal driver version and remove module version macro.
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c      | 1 -
> drivers/scsi/qla2xxx/qla_version.h | 6 +++---
> 2 files changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index a186c3a55088..36bc4efc5b1c 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7962,7 +7962,6 @@ module_exit(qla2x00_module_exit);
> MODULE_AUTHOR("QLogic Corporation");
> MODULE_DESCRIPTION("QLogic Fibre Channel HBA Driver");
> MODULE_LICENSE("GPL");
> -MODULE_VERSION(QLA2XXX_VERSION);
> MODULE_FIRMWARE(FW_FILE_ISP21XX);
> MODULE_FIRMWARE(FW_FILE_ISP22XX);
> MODULE_FIRMWARE(FW_FILE_ISP2300);
> diff --git a/drivers/scsi/qla2xxx/qla_version.h =
b/drivers/scsi/qla2xxx/qla_version.h
> index 8ccd9ba1ddef..0f5a5f17dcef 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -7,9 +7,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.01.00.25-k"
> +#define QLA2XXX_VERSION      "10.02.00.102-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> -#define QLA_DRIVER_MINOR_VER	1
> +#define QLA_DRIVER_MINOR_VER	2
> #define QLA_DRIVER_PATCH_VER	0
> -#define QLA_DRIVER_BETA_VER	0
> +#define QLA_DRIVER_BETA_VER	102
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

