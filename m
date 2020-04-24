Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60C1C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 16:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B10162071E
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 16:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vtL3wlE/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgDXQ7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:59:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgDXQ7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 12:59:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OGwqYb051105;
        Fri, 24 Apr 2020 16:58:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=NGqZDadojME6Ndxh7YoN7j4tuiq/x9zi+kr5E7fzHb0=;
 b=vtL3wlE/z4ToFtBnBahFAypR9bCGQmjLZ56bEYo7dErGB/A4sJTxy73ByDKR8aPwxSQc
 p9JrSagaeCf/bwef2RTnRcIW6u0TSGZaFvCxj1GC4C9oqq8musS9S2zSeSUYZzyvu+On
 ni+DuAdvMnuIeQI7+kLGz2CaspXK7yEpntuSd2rp7Agj6kHyEL115OqMkG+E6cV+P6L3
 L2G1R/gWp4kbIP6tTndRMo8HhLeiO4dPaV9rB4RKYKpCj0eDYKcRBIvVqtNoZjQhjPj9
 R/QgTcuMqzkdSQ2QmLqjgulTV03tjD2lvaNJtdaRkH3302MvRSaW9jnBYxi8P3VGRxP+ Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30ketdnfk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:58:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OGmPrQ114455;
        Fri, 24 Apr 2020 16:56:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30gb1q4pey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:56:56 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03OGutJ8021804;
        Fri, 24 Apr 2020 16:56:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 09:56:54 -0700
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     linux-kernel@vger.kernel.org, boqun.feng@gmail.com,
        QLogic-Storage-Upstream@qlogic.com (supporter:BROADCOM BNX2FC 10
        GIGABIT FCOE DRIVER), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:BROADCOM BNX2FC 10 GIGABIT FCOE
        DRIVER)
Subject: Re: [PATCH 7/9] scsi: bnx2fc: Add missing annotation for bnx2fc_abts_cleanup()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200411001933.10072-1-jbi.octave@gmail.com>
        <20200411001933.10072-8-jbi.octave@gmail.com>
Date:   Fri, 24 Apr 2020 12:56:51 -0400
In-Reply-To: <20200411001933.10072-8-jbi.octave@gmail.com> (Jules Irenge's
        message of "Sat, 11 Apr 2020 01:19:31 +0100")
Message-ID: <yq1eescesa4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=925 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=983 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240132
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jules,

> Sparse reports a warning at bnx2fc_abts_cleanup()
>
> warning: context imbalance in bnx2fc_abts_cleanup() - unexpected unlock
>
> The root cause is the missing annotation at bnx2fc_abts_cleanup()
>
> Add the missing  __must_hold(&tgt->tgt_lock) annotation

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
