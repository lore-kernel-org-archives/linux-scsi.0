Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66C9C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 435CA22226
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iFE5ac5j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgKTDXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:23:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgKTDXS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:23:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3AWZd069775;
        Fri, 20 Nov 2020 03:23:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=P7qwUAq4LOfiqpiLuCfp4Ec5eN1+CCRtOfcxSaMf+xg=;
 b=iFE5ac5jQTeYWfqwKxq6XDllLtlA0Ee7YUfihmj/Y53TK49WNv4Wi/RFyYeb2nzlpJCF
 zMvkMapXzNVts8I7nOOICGdVUhDU7xxPcLYmdmusSZWyybqI3bgmzbnAt9K+yGo5h4iC
 a3u3ERZ8nwi0RkuFb1mleHu/MsGyBDvanTHeyxpTKykPuZJ6vOv2LDODN708mf5t3n2P
 e7CxOdUshJRsmmH6MfbqFEKCUv2MDHJQBHiTmUdfqoAkn7japKbM6o0pEbqdhmAISd2T
 4LqG0NsQnipKoMkFIhqzSjdzNLT/8pxN/vuRW5NSFfcrjszUsagPlc5GmCvMXbn8A908 XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34t76m8qj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:23:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK35cYp028082;
        Fri, 20 Nov 2020 03:21:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ts0upqy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:21:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3LDBd012507;
        Fri, 20 Nov 2020 03:21:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:21:13 -0800
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix set but unused variables in
 lpfc_dev_loss_tmo_handler
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dqgww65.fsf@ca-mkp.ca.oracle.com>
References: <20201119203353.121866-1-james.smart@broadcom.com>
Date:   Thu, 19 Nov 2020 22:21:11 -0500
In-Reply-To: <20201119203353.121866-1-james.smart@broadcom.com> (James Smart's
        message of "Thu, 19 Nov 2020 12:33:53 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=865 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=876
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Remove set but not used variable shost in lpfc_dev_loss_tmo_handler()

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
