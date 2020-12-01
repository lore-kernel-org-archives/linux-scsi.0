Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CFBC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4077A21D46
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eCK5JW9a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391849AbgLAPwv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 10:52:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37232 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390604AbgLAPwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 10:52:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FZK3A030561;
        Tue, 1 Dec 2020 15:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=FOgndsVFzAVjMsoAZHVwAECnXhItFpBGyV/JnctCWKM=;
 b=eCK5JW9apELtF6GAvwlnVSg8G2HmJzmRdA3BICH3tbkz+PHOdS2UrDROXAuJOk4IqfgT
 ZrzSur/TwyELJs0Ym5UH+531MQRHcoPG/msL0V85BwbqqMBieBCa+kYdlC2LpQjX1WMS
 qWiO4MO0YxfG2t9+D0yNmN07Qy/DrgD6biify+b9mm2G6x3N7rMk6NeZ2qdRrNioBc4X
 U1ugLUDB9aTBRAhNOvHmn5dGFkzREqn9a25T23OMAeyK8j6TrLi/zEATlKcic3PRgBvp
 wM33smG5HGpStyxDeVBhQvsQkwgyf+tvmRq0ZIxh1WJoLqeRhSFRjjTEGXelEYClkgyq 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqk9q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 15:52:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FVKGj012762;
        Tue, 1 Dec 2020 15:52:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540fx58vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 15:52:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1Fq6oj009749;
        Tue, 1 Dec 2020 15:52:06 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 07:52:05 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 06/15] qla2xxx: Fix compilation issue in PPC systems
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-7-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 09:52:04 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3197F3EB-943D-4DB8-BF33-DA732AB02990@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-7-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Fix compile time errors reported on PPC systems.
>=20

What is the error? Can you please add details in commit message for =
reference=20

> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nx.c  | 2 +-
> drivers/scsi/qla2xxx/qla_nx2.c | 4 ++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c =
b/drivers/scsi/qla2xxx/qla_nx.c
> index b3ba0de5d4fb..fd994e36200a 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -965,7 +965,7 @@ qla82xx_read_status_reg(struct qla_hw_data *ha, =
uint32_t *val)
> static int
> qla82xx_flash_wait_write_finish(struct qla_hw_data *ha)
> {
> -	uint32_t val;
> +	uint32_t val =3D 0;
> 	int i, ret;
> 	scsi_qla_host_t *vha =3D pci_get_drvdata(ha->pdev);
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx2.c =
b/drivers/scsi/qla2xxx/qla_nx2.c
> index 01ccd4526707..68a16c95dcb7 100644
> --- a/drivers/scsi/qla2xxx/qla_nx2.c
> +++ b/drivers/scsi/qla2xxx/qla_nx2.c
> @@ -139,7 +139,7 @@ qla8044_poll_wait_for_ready(struct scsi_qla_host =
*vha, uint32_t addr1,
> 	uint32_t mask)
> {
> 	unsigned long timeout;
> -	uint32_t temp;
> +	uint32_t temp =3D 0;
>=20
> 	/* jiffies after 100ms */
> 	timeout =3D jiffies + msecs_to_jiffies(TIMEOUT_100_MS);
> @@ -2594,7 +2594,7 @@ qla8044_minidump_process_rdmux(struct =
scsi_qla_host *vha,
> 	struct qla8044_minidump_entry_hdr *entry_hdr,
> 	uint32_t **d_ptr)
> {
> -	uint32_t r_addr, s_stride, s_addr, s_value, loop_cnt, i, =
r_value;
> +	uint32_t r_addr, s_stride, s_addr, s_value, loop_cnt, i, r_value =
=3D 0;
> 	struct qla8044_minidump_entry_mux *mux_hdr;
> 	uint32_t *data_ptr =3D *d_ptr;
>=20
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

