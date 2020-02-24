Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA540C38BE0
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 20:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F93820838
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 20:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WB5Mqc+8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgBXUBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:01:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgBXUBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2020 15:01:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OK1fNA089741;
        Mon, 24 Feb 2020 20:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=FpQQf0lMmWt1gONn/OVl+/71hdBmyk1yroGkgirNhIQ=;
 b=WB5Mqc+83TDlSnPNCMtDkUdKKv7Pv59WCOKWMZokdPUgzXZOpPqpiuJkfgratdRHnYrN
 Gfuc8af1zRprS8FTpThgZDBHi9WTHG2iK5G4oq30vTssRrLc0tnWK3iKtiGhG54CuX0g
 39Lu8ufta53uuJhMUOK3P/Pw++zEJr3PXOlYViN3Lx3DpJCQevY06Tjwjrkm9B6UQsZX
 jFpaHcwwYQvk/wvev7ptCZ+sfsVPuN2VYgzZc70bvevjHCEyLzcfcNugJG4mYgng04dw
 TPG238Xfdf7oK5bqmhUEYkLZXY9J7fEYtoWaB0bbfzpPIt7D49uBx+oICtknRM5EUw9E fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ybvr4p0d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 20:01:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OJud0E128929;
        Mon, 24 Feb 2020 19:59:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ybduv3kus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 19:59:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01OJxfiY028192;
        Mon, 24 Feb 2020 19:59:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 11:59:41 -0800
To:     Diego Elio =?utf-8?Q?Petten=C3=B2?= <flameeyes@flameeyes.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sr_vendor: remove references to BLK_DEV_SR_VENDOR, leave it enabled.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200223191144.726-1-flameeyes@flameeyes.com>
Date:   Mon, 24 Feb 2020 14:59:39 -0500
In-Reply-To: <20200223191144.726-1-flameeyes@flameeyes.com> ("Diego Elio
        =?utf-8?Q?Petten=C3=B2=22's?= message of "Sun, 23 Feb 2020 19:11:44 +0000")
Message-ID: <yq1lfordadw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240145
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Diego,

> This kernel configuration is basically enabling/disabling sr driver
> quirks detection. While these quirks are for fairly rare devices (very
> old CD burners, and a glucometer), the additional detection of these
> models is a very minimal amount of code.
>
> The logic behind the quirks is always built into the sr driver.
>
> This also removes the config from all the defconfig files that are
> enabling this already.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
