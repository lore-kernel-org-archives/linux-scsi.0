Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B5DC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D41220872
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BRsEezrB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgH1PlO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 11:41:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgH1PlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 11:41:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07SFe51g129850;
        Fri, 28 Aug 2020 15:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=r8C8jz6oLvETxK5w03By/NmBkmZ7p5pr5jENm4ISQpI=;
 b=BRsEezrB+JXE+gKiadiEnv0V1eWLBXOTbojVpNKZqk8usko7wRipqzDTo9PgHre55jbw
 ffsc9A8LuGEqVd31l4SVZczyXbPFhMZ1bOJFzGdT1jYfQIkDykTtK95wS5H2HbApfRXc
 fCiYIxZCH2cpXnEPdcz+nhEtom35T9ndLFyAQ+IJKoaxTZzGZPs2WFAr8eoR4AppYs+F
 4CZZjxHmrtH79XhT3Qr/+rDHhhHwZbm8I4bqHO0zUG8ulJtcWPU6/deNxFg2eXg1a3HB
 NhjmX+/l9Dh4d+zBzEP0JWagieRJTg6+8zUo9esWsG5d2gT+g1lajaIdWb4xLs8R/7HX nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbscmhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 15:41:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07SFVFh0150163;
        Fri, 28 Aug 2020 15:39:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9pt6hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 15:39:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07SFd4Jj004599;
        Fri, 28 Aug 2020 15:39:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 08:39:03 -0700
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: orphan sections with qlogic.com group alias
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7smkcqc.fsf@ca-mkp.ca.oracle.com>
References: <20200828070824.8032-1-lukas.bulwahn@gmail.com>
        <20200828091758.GF54274@SPB-NB-133.local>
        <alpine.DEB.2.21.2008281524360.11562@felia>
Date:   Fri, 28 Aug 2020 11:39:01 -0400
In-Reply-To: <alpine.DEB.2.21.2008281524360.11562@felia> (Lukas Bulwahn's
        message of "Fri, 28 Aug 2020 15:30:44 +0200 (CEST)")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=925 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=893 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lukas,

> So, if these drivers are not orphans, you can answer Thomas Gleixner's
> original email from 2019. If you can quickly ack that patch set, I am
> happy to do the donkey work to get this apply nicely on the current
> master (please CC me on that response).

This is the first I hear of this since the patches weren't CC:ed to
linux-scsi. And not all of these changes pertain to storage drivers but
to networking so I am also not sure that mails sent to the above Storage
alias would have ended up in the right place.

But we'll get this fixed up. Reaching out to our contacts at Marvell.

-- 
Martin K. Petersen	Oracle Linux Engineering
