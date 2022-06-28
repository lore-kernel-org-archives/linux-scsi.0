Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41848CCA47F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 03:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiF1DZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 23:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiF1DZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 23:25:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF0425584
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 20:25:10 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S1RcSE026411;
        Tue, 28 Jun 2022 03:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=bTnv+ItHm9EeuSMvv7xrhhl+2/0fU+/6AnUITOX2wKU=;
 b=QtZEFFC1B7sV3N3FkFwkBjyPfEFFF7dOdr+4IdbbLfPKLi3U/ca+5pv9zsUnQb4Z/aGK
 xJJUS1TTvATPa13X7DPJL4dSTfqyrt22SCatnh8nezRDXQfgNg7diZfKQpcKxg9TRiOy
 bCG3WmCNVr0QO9UX80K24lAXKq69ZBIBn17yR+xgzCykEXLNhGJOvkZvkCoO63v1+R+v
 bB4QSUwQiknMkjAnxFQM3Zc/FBHO7UX/IvBFRZEKg1XDgb1YQcCCvjSs52bsU9iCZRCD
 iEoRnjFep3PrMlYCY18WjCA/9loDl2esvZlJwf5ByYXofaMxYtZFJ5XRSi52KRKxgUSo Dg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsyscrse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:25:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S3F1AD002527;
        Tue, 28 Jun 2022 03:25:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:25:03 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25S3NvqQ016584;
        Tue, 28 Jun 2022 03:25:03 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjkg-15;
        Tue, 28 Jun 2022 03:25:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Varun Prakash <varun@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update cxgb3i and cxgb4i maintainer
Date:   Mon, 27 Jun 2022 23:24:53 -0400
Message-Id: <165638665788.7726.8581117923029608.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220612121340.6746-1-varun@chelsio.com>
References: <20220612121340.6746-1-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Pudz2tPmXh5r1_B0axxN9QoRDUKnlYgE
X-Proofpoint-GUID: Pudz2tPmXh5r1_B0axxN9QoRDUKnlYgE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 12 Jun 2022 17:43:40 +0530, Varun Prakash wrote:

> 


Applied to 5.20/scsi-queue, thanks!

[1/1] MAINTAINERS: update cxgb3i and cxgb4i maintainer
      https://git.kernel.org/mkp/scsi/c/e34cc16a8042

-- 
Martin K. Petersen	Oracle Linux Engineering
