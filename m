Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACA0C2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 677F92087E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:19:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UYQn4MAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392478AbgDOBTH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 21:19:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44272 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392471AbgDOBTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 21:19:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1E6rq069367;
        Wed, 15 Apr 2020 01:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=lnu0TCLP/vWgpy9ysGa2iDKSFkne9ZPLXGb9Fb1iDDg=;
 b=UYQn4MATm18uRNgbpI8K2Ub0PzXvIDUw7tXt0ajK6VQbBpj/+fi/8kfLBYiJK50DhzfQ
 a6kwZtVdlIwrgYZNf1dbr8hfbWtaKdkcjfNBeIbidDRwnkQac90hmQHSXXdNYAII+YVJ
 4IuMm/9CoZjiI5VApV+mC3ndmGLxPxXSh4OmskIW4/FGxG2PK6AHBbaeTp+Y89dl4ykR
 p0+CUZqdrLbH+yGsftfsOrXd9rC2NfnSIyZU9CpKHEyKvEMm0Yg8esS64FDBEDbvsZUZ
 zyJFnJyxAhd/R5sg4nDmPhf8U53Fg+UJMv3tNZ22RtMf4s4X5IJjw/GKmFwxdZRKaFEI GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30dn95gjk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:18:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1Bq2q091526;
        Wed, 15 Apr 2020 01:16:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30dn98ejg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:16:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03F1GoAk008401;
        Wed, 15 Apr 2020 01:16:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 18:16:49 -0700
To:     Diego Elio =?utf-8?Q?Petten=C3=B2?= <flameeyes@flameeyes.com>
Cc:     Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/4] Update referenced link to cdrtools.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200413170501.13381-1-flameeyes@flameeyes.com>
Date:   Tue, 14 Apr 2020 21:16:48 -0400
In-Reply-To: <20200413170501.13381-1-flameeyes@flameeyes.com> ("Diego Elio
        =?utf-8?Q?Petten=C3=B2=22's?= message of "Mon, 13 Apr 2020 18:05:01 +0100")
Message-ID: <yq1tv1lr1j3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=673 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004150005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=729 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150005
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Diego,

> -	  (<http://cdrecord.berlios.de/private/cdrecord.html>)
> +	  (<http://cdrtools.sourceforge.net/>)

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
