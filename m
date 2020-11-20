Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DBFC56202
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18FBF22249
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zHAJSeNh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgKTDT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:19:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39130 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgKTDT5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:19:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3AMkM044895;
        Fri, 20 Nov 2020 03:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=P/Qj9YJGfTJLiI6ocgmWlEWiWTZGyYYe4ejODXr/Eow=;
 b=zHAJSeNhV97QDEZe9SW9e1O+TMBQ1UAeW0AePCmoFW+CbcFv1TXwy510MLL9IXl0Oq9a
 TzQnRmmt21ffmbrEgyOPQIsnLCEBIoxBPoqDuk7x05W6eXmBrLzs0fV5bxQd20hLalOy
 kagE5xUbVPdMGV+HVMovs0lRh+9Y2F7edzd6NTFBShr62M9DwVnQtsADYjH3vuSb/9dm
 2gU/gT2vXcLxSiFdI930bpoQVGAawpcrpqWhzboNLCUdzan8sZfSLz8ljFKLM0qtaaeR
 lj2ndiHO43e8hCAqwSeVx6wxAcMGHJ6alZiYtrVxIZuv1fuD2ZJS879G0KqKWitnjcgI mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34t4rb8tan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:19:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK35cPq028084;
        Fri, 20 Nov 2020 03:19:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ts0upnjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:19:53 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AK3JpKk023651;
        Fri, 20 Nov 2020 03:19:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:19:51 -0800
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix missing prototype warning for
 lpfc_fdmi_vendor_attr_mi
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ima0ww8e.fsf@ca-mkp.ca.oracle.com>
References: <20201119203328.121772-1-james.smart@broadcom.com>
Date:   Thu, 19 Nov 2020 22:19:50 -0500
In-Reply-To: <20201119203328.121772-1-james.smart@broadcom.com> (James Smart's
        message of "Thu, 19 Nov 2020 12:33:28 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Function needs to be declared as static.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
