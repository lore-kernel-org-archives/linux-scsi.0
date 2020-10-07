Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C886C4363D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 02:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B9C2080A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 02:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cs1FkHQI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgJGCG4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 22:06:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGCG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 22:06:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09724Taq085736;
        Wed, 7 Oct 2020 02:06:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=npR1jO1LL2S5BgBvOdjPwn4IpCYcjN8e6TgEDtc4Xqk=;
 b=Cs1FkHQIUCte2o/KQ1md7DBqlbREVv01AbR1tOpRpBU+otnXXNJ06hv7OoYMTpAX3hvj
 ekiaDZj+W/Xw+fp+7UaCo1h8hY4ICvgeqQ+5rnYZJh3qCR+PEsu9ZmxHbGvAdy52KZmG
 dmvLMw+ZWKZ6MN8dtm9A0EJ8MHckvEuoivIFI40RPfd9wkej/pHMEP6eX/XqdfkLuvgd
 7kdRbxmt8lrlzy5oubJ6/HO1Trymjou7ImjRffYjZHJnwmn6IWAfkDhAomP+c8Ua+oj4
 AJ/KAdK15cftJXQXXIB9xOYwI2oBsyQUXXuD4KSA8s5yABkaDctrPQJ/o0Tmd/37yV4x 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym34mcgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 02:06:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097269LU140818;
        Wed, 7 Oct 2020 02:06:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y37xw0q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 02:06:48 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09726l1O029544;
        Wed, 7 Oct 2020 02:06:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 19:06:46 -0700
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH V2 0/4] pm80xx updates.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1qa7pw7.fsf@ca-mkp.ca.oracle.com>
References: <20201005145011.23674-1-Viswas.G@microchip.com.com>
Date:   Tue, 06 Oct 2020 22:06:44 -0400
In-Reply-To: <20201005145011.23674-1-Viswas.G@microchip.com.com> (Viswas G.'s
        message of "Mon, 5 Oct 2020 20:20:07 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=745
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=777 clxscore=1011 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Viswas,

> Changes from v1:
> 	- Improved commit messages.
> 	- Fixed compiler warning for 
> 		 "Increase the number of outstanding IO supported" patch 

Applied to 5.10/scsi-staging.

In the future please run checkpatch and make sure that the commit
messages are using imperative mood (see
Documentation/process/submitting-patches.rst, section 2).

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
