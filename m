Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03004C4363D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 13:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D5B6208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 13:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vaudEtAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgJGNc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 09:32:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50402 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgJGNc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 09:32:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097DDUE2134529;
        Wed, 7 Oct 2020 13:32:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=qs97gC59p8+vTB3DTCcQDnWHINcXtYOlPp2Ryb61e/E=;
 b=vaudEtAgfkE8qX7dNHZCb4OHFeFJL2wmZ3drtxnHFNZYxqyl7Qtte2P4q5guCX0NrZ50
 7+uKEk718QMSqJNLR1iHjuQr3BazSbQ4HpiGzGUC14CniIhLi8aQmGW5stDJThEFK8bh
 m588/2/Cu9Tagy7cMNZEhAF7X8JLV1SJNNrFDT+1x+9zfI8/v3bTPyTcjMDWBQszBZw4
 j+ZT/chq5Rr2yH80DsIQr3rO9xx+hQzWfrPVTFXUZ/0YAAHvdQlZ5vtxpQIzrKraHOaa
 I51i2K9OPTWHb1kx9EsgZfp3jqcYwClwxVfXAwX7XAFqznzMgW9yEqjFoOrdcywOuSxl UQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxn1pbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 13:32:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097DFKWL120949;
        Wed, 7 Oct 2020 13:32:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vph5s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 13:32:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097DWhN2019396;
        Wed, 7 Oct 2020 13:32:43 GMT
Received: from [192.168.1.26] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 06:32:43 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] scsi: qla2xxx: initialize value
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201005144544.25335-1-trix@redhat.com>
Date:   Wed, 7 Oct 2020 08:32:42 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        natechancellor@gmail.com, ndesaulniers@google.com,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2E536F63-9F97-4B80-8538-D3176650CC70@oracle.com>
References: <20201005144544.25335-1-trix@redhat.com>
To:     trix@redhat.com
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1011 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 5, 2020, at 9:45 AM, trix@redhat.com wrote:
>=20
> From: Tom Rix <trix@redhat.com>
>=20
> clang static analysis reports this problem:
>=20
> qla_nx2.c:694:3: warning: 6th function call argument is
>  an uninitialized value
>        ql_log(ql_log_fatal, vha, 0xb090,
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> In qla8044_poll_reg(), when reading the reg fails, the
> error is reported by reusing the timeout error reporter.
> Because the value is unset, a garbage value will be
> reported.  So initialize the value.
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
> drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx2.c =
b/drivers/scsi/qla2xxx/qla_nx2.c
> index 3a415b12dcec..01ccd4526707 100644
> --- a/drivers/scsi/qla2xxx/qla_nx2.c
> +++ b/drivers/scsi/qla2xxx/qla_nx2.c
> @@ -659,7 +659,7 @@ static int
> qla8044_poll_reg(struct scsi_qla_host *vha, uint32_t addr,
> 	int duration, uint32_t test_mask, uint32_t test_result)
> {
> -	uint32_t value;
> +	uint32_t value =3D 0;
> 	int timeout_error;
> 	uint8_t retries;
> 	int ret_val =3D QLA_SUCCESS;
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

