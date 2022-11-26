Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69719C4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 03:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiKZD1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 22:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiKZD1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 22:27:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E18EE36
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 19:27:47 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ330Km018766;
        Sat, 26 Nov 2022 03:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=1kKYqDn/GhtiWaDvYM0hdzQTdZjgrSvHR8pSfy6XSo8=;
 b=REU3Jg9JdRq39EPn67bWzV0v5MTQfKzGd96u3DB9RycJF6l9Y8/ZAp9BnoYvTQeQ1ppK
 bSE7UdNXHGINNoKfo5bUTCTsnbVw2ioDmh0xnORfDxl10IgZ7w7UnHuyvDbw8+zShXxX
 oa5d262Ujo7MQfPBHWFV7vRErLpi4qR7g0tAWp/dDZGAK5/FlZ0QpJjt5r04Owk2pz9A
 LloTezQvX6la6GNvMhjGzZxQyrgRfLlc/VBaJDGs53mWlPesfVr6Ye85mSSyuF1mebs7
 dtRhBbg3pqDcK4wMs3Svi2XhJidrZDFu9w5mVsidNTzTfTE5oeHYJEcAI5NqVLC1oReF jg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397f8252-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1XRcT007263;
        Sat, 26 Nov 2022 03:27:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3988b80s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:45 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AQ3RhsZ028327;
        Sat, 26 Nov 2022 03:27:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3m3988b7y9-7;
        Sat, 26 Nov 2022 03:27:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com
Subject: Re: [PATCH 0/6] lpfc: Update lpfc to revision 14.2.0.9
Date:   Sat, 26 Nov 2022 03:27:38 +0000
Message-Id: <166943312547.1684293.13037923418300351162.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116011921.105995-1-justintee8345@gmail.com>
References: <20221116011921.105995-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=835 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260024
X-Proofpoint-ORIG-GUID: zg6NI0XXbOA5WPOSxYLx_3EXLTrWQ7lY
X-Proofpoint-GUID: zg6NI0XXbOA5WPOSxYLx_3EXLTrWQ7lY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Nov 2022 17:19:15 -0800, Justin Tee wrote:

> Update lpfc to revision 14.2.0.9
> 
> This patch set contains bug fixes and a change to a default setting.
> 
> The patches were cut against Martin's 6.2/scsi-queue tree.
> 
> Justin Tee (6):
>   lpfc: Fix WQ|CQ|EQ resource check
>   lpfc: Correct bandwidth logging during receipt of congestion sync WCQE
>   lpfc: Fix MI capability display in cmf_info sysfs attribute
>   lpfc: Fix crash involving race between FLOGI timeout and devloss
>     handler
>   lpfc: Change default lpfc_suppress_rsp mode to off
>   lpfc: Update lpfc version to 14.2.0.9
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/6] lpfc: Fix WQ|CQ|EQ resource check
      https://git.kernel.org/mkp/scsi/c/2c1a0a7584f5
[2/6] lpfc: Correct bandwidth logging during receipt of congestion sync WCQE
      https://git.kernel.org/mkp/scsi/c/ae696255d655
[3/6] lpfc: Fix MI capability display in cmf_info sysfs attribute
      https://git.kernel.org/mkp/scsi/c/d99af587d59c
[4/6] lpfc: Fix crash involving race between FLOGI timeout and devloss handler
      https://git.kernel.org/mkp/scsi/c/97f256913c5d
[6/6] lpfc: Update lpfc version to 14.2.0.9
      https://git.kernel.org/mkp/scsi/c/d57d98fef46f

-- 
Martin K. Petersen	Oracle Linux Engineering
