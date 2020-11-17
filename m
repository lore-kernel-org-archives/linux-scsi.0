Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2754C56202
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC56A223BD
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:56:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WE1zkVBK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgKQD4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:56:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgKQD4T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 22:56:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3dwCM166149;
        Tue, 17 Nov 2020 03:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GIMTB8BpU8tBdqjUEfN4pOkfikOqGpoKtBjM6BWvysw=;
 b=WE1zkVBKTFxmX7/NnSkXeNbZrwonT1vSJ94Z3zrwiCNHXRstH9aa16iK57PiNYV3Su3u
 eC2e4se4RacppMs/NTCifQzUhv/oZnLsPRTQc0TxagjfQE9RI2ndSdILEmAHj4bDB447
 Cwo4czHm4SspBmbdU44R9FZGexsEx7KIxNq8BFbyS9ezCw5LjONUSYac//d2eMX4Q7Ma
 Qma2/TBUojnSDSC2/fslAy+g5ny5BOYfutC189UUfoRFOhNNVrYAkBchLjWE58bf1FPt
 tBDZaV2VvG9EsqywOnhs3wWCsooc43Y2Wv8yBaLAkUZP+iCRisdR/LnriAZ8013r1iiu fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34t7vn0ccs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 03:56:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3fILS005292;
        Tue, 17 Nov 2020 03:56:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34umcxmpds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:56:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH3uA81006513;
        Tue, 17 Nov 2020 03:56:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 19:56:10 -0800
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 1/1] scsi: pm8001: pm8001_hwi: Remove unused variable
 'value'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6vg63hp.fsf@ca-mkp.ca.oracle.com>
References: <20201116104119.816527-1-lee.jones@linaro.org>
Date:   Mon, 16 Nov 2020 22:56:08 -0500
In-Reply-To: <20201116104119.816527-1-lee.jones@linaro.org> (Lee Jones's
        message of "Mon, 16 Nov 2020 10:41:19 +0000")
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> Hasn't been used since 2009.
>
> Fixes the following W=3D1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_hwi.c: In function =E2=80=98mpi_set_phys_g3_w=
ith_ssc=E2=80=99:
>  drivers/scsi/pm8001/pm8001_hwi.c:415:6: warning: variable =E2=80=98value=
=E2=80=99 set but not used [-Wunused-but-set-variable]

Applied to 5.11/scsi-staging, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
