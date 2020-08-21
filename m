Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8F0C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 02:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5671B20732
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 02:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pe0kdtmt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgHUC1J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:27:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgHUC1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 22:27:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L2N5ad136255;
        Fri, 21 Aug 2020 02:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=lGDLfl72wMNLinlLZDOcfwNXBQUhogFM+gDqAjXTZoQ=;
 b=Pe0kdtmt3RDDS5Y1br074GQBaTAauE/vWq1hWl1+/GrpHqh5QyMBFBdJ6+SBbic0eIvk
 aOoDhciruS/l0p3sVK4+67XoLRTJifKgw4spKqfmRli06R45D0xXBjrGNjgowElVsryL
 icegAEzwatPqy/yV4px5shy4KpcIX57aBYrnbbt+OcXue7Ld/siPyuEL8Iu987HhcV6M
 s+k7OCPu71Fe6PLj0tzJbutFNOEY4SjWxnO7NefxODZPnLcUQ6pWiHnj2OyPMIrRivBT
 /lPdGaFDQHedooaaVeJFCvAFuDEV1RaWsh1ufZ0uGczUGPQeDVND/W1uNyz34uccAPiF Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74rkxbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:27:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L2N3aL059901;
        Fri, 21 Aug 2020 02:27:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsn23bgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:27:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07L2R5hi025110;
        Fri, 21 Aug 2020 02:27:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:27:04 -0700
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH v1] mpt3sas: Add support for Non-secure Aero and Sea PCI
 IDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6yoviti.fsf@ca-mkp.ca.oracle.com>
References: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
Date:   Thu, 20 Aug 2020 22:27:02 -0400
In-Reply-To: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
        (Sreekanth Reddy's message of "Fri, 14 Aug 2020 13:04:26 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> This patch will add support for Non-secure Aero & Sea adapters' PCI
> IDs.

That wording is misleading since you're effectively removing support for
these controllers.

> Driver will throw an warning message when a non-secure type controller
> is detected. Purpose of this interface is to avoid interacting with
> any firmware which is not secured/signed by Broadcom.

The request was to log a warning. Why would we want to disable support
for these devices in the driver?

-- 
Martin K. Petersen	Oracle Linux Engineering
