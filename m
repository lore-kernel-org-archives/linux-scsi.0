Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E16C19437
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 01:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6242239ED
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 01:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgLHBgY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 20:36:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgLHBgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 20:36:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B81TLLH064916;
        Tue, 8 Dec 2020 01:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=y0FE8S9fE5+CxLPMzAs98rjcgOv0fPolfCkTEwdK30k=;
 b=wkcp1+yM2uIwvq57YBLP4jw2hK2iO6KNtguXXu165UHTcS6N3rqc15t8tTrmdlxIHpnd
 TQao8WpbG/OaX+rIZDXAx15G5vfm/k3l/ccTq6zr/C6Uc225/P7u7VuqgMaIJNa6bzV6
 GZnZpCm6DOvTITmiOoeVmRfxhCnWcE2JP8FKR9a5/uT3xBhgmTLQktc6jGgn11QUV0M7
 5gzPi4S6lJjiDYfdTCjxaC9GdYZ2oTcRgJ5aoaYAsv7w638nCxv3+o4PT0VRGTDMnHxK
 OZx6C3FxTZVTOWD9u4XbhT+nUddkW4GDKOJCMK6mx2oHtLLjCz0Q6Av8xPoHF1R+1ARw IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35825m0dk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 01:35:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B81UjBF159766;
        Tue, 8 Dec 2020 01:35:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 358ksmx2jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 01:35:38 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B81ZaTP018288;
        Tue, 8 Dec 2020 01:35:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 17:35:36 -0800
To:     trix@redhat.com
Cc:     njavali@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: qla2xxx: remove trailing semicolon in macro
 definition
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tusxyt9j.fsf@ca-mkp.ca.oracle.com>
References: <20201130205509.3447316-1-trix@redhat.com>
Date:   Mon, 07 Dec 2020 20:35:34 -0500
In-Reply-To: <20201130205509.3447316-1-trix@redhat.com> (trix@redhat.com's
        message of "Mon, 30 Nov 2020 12:55:09 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080006
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tom,

> The macro use will already have a semicolon.  Remove unneeded escaped
> newline.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
