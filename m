Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABA4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 05:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245552AbiCOFnf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 01:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiCOFne (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 01:43:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1CA2C113;
        Mon, 14 Mar 2022 22:42:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3M3Do021977;
        Tue, 15 Mar 2022 05:02:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=oAFBBs/E5rptGEXYV7Li9rK+IINtjwWvmeJNAxYBj1o=;
 b=BKInPhDx0n2GTgqFCCrj8Lf28m11M768vEewbDSXg+zELwyWLgYXfLhW0bJCjpwA3jld
 9Mjr7kJIGpadaNs6QCsq81IZcM7ER195R33rQSFHJBm6AjQe0rcpI3TSsHVHWTZ31Zj3
 inx229R9yd+26wyP7QsyF4V2EzreW814rM4ahd5hugO3Qg+1KQr6RejZp8gSAlqeUxCR
 BDdNGSq/ZjE0cV66St2vDigaN4eH7gHIuvHZfHyPanuLxmivb/9GbIdKKngimIayF/AI
 1NW7W+xelc5rt6w1YCAkyfU1z0/1HJ88wzRtr0h2oqJdRYIdfjQZE+k7SXk9SeV2kFWU +w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60r9y1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22F51LHT005084;
        Tue, 15 Mar 2022 05:02:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:43 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22F52cq9007094;
        Tue, 15 Mar 2022 05:02:43 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wts-4;
        Tue, 15 Mar 2022 05:02:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        patches@lists.linux.dev, linux-scsi@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] SCSI: docs: UFS documentation corrections
Date:   Tue, 15 Mar 2022 01:02:34 -0400
Message-Id: <164732052813.23186.4136938710456467742.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220307013224.5130-1-rdunlap@infradead.org>
References: <20220307013224.5130-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 85Krc8joo-tg30IlXanUJsns7K5BolM8
X-Proofpoint-ORIG-GUID: 85Krc8joo-tg30IlXanUJsns7K5BolM8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 6 Mar 2022 17:32:24 -0800, Randy Dunlap wrote:

> Make a variety of corrections to ufs.rst:
> 
> - add spaces around parenthetical phrases
> - correct singular/plural grammar and nouns
> - correct punctuation
> - add article adjectives
> - add hyphens to multi-word adjectives
> - spell Lun as LUN
> - spell upiu as UPIU (in text, not code examples)
> - don't capitalize generic "specification"
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] SCSI: docs: UFS documentation corrections
      https://git.kernel.org/mkp/scsi/c/296559d41e0f

-- 
Martin K. Petersen	Oracle Linux Engineering
