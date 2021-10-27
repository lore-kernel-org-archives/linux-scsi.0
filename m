Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF19FC4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2CE860F90
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhJ0CZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:25:02 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63772 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238299AbhJ0CYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 22:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635301349; x=1666837349;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=midSt53IXwI+VfBRlUo7IoxQaAyGszKbyXnxpo5XSXI=;
  b=Wo09Rr3kI07+gPQd4z1024TqSVPEjYIJvvwlh82sycbPUgSde6IqU8Nq
   vPO3vshyDDRs/Hjf4SKmUesBMWCrap480XZJliUBaEVq5hodzV9ZEBFTT
   mmuuwSU99+mcHNMm/AB2rshkejdksOTirt0M1xAgW9LK6oyyId13VAf5a
   BB2x4vCmCFC+EXHVlahAqh5J7mnTBxYdpP0RIS9I7KJhrKvPLd1lbxPzf
   fi6sM3i/zswo1vwF8fGsRU0DRA8apVbcB+/ozITlPAgpVjwhQhULuaxED
   tjvaequGAgltgXLzuT+XsFJLaSUeoKJffnR9ZQI94S2C9Elrxih9c4L+h
   g==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="183924745"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 10:22:29 +0800
IronPort-SDR: 76yNNrirQDCghK3G0iZWV47UmjWkoiWDnlffDzMsINwc88R7hIxDPC/zuaTAcnK0cl4UqvlQKz
 /NJXcueFu+XQmTnDvoTIES45VUsa+vqL+eKvMp0UWXkQXdtNiHIyx/r7lZvmkgdxZO1fwYBRSV
 PQg0zuXsdQtHpqvaNdYyeSmfUybInss+AJbH43qsgoMmLx6MICtYX02Wsrp40qPKF7q966ck4V
 m4OnAGaZf+eOb/LR0x6ao12W8WcOA3A1Yfq7VAWbjR/X/u26v5e7Sw1LV1TtigCsdHy6c8GpZB
 ANOeA5Q4+oXU+zuwjYQMWNMq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 18:57:59 -0700
IronPort-SDR: 029dgmM2piFaGPM+lDNOR/c5cp0QANeUNv3ZQxzp+hpVBUjpX2wiAZFFi0/mhH+wXRcp5j2tt2
 TUdrrfxo+NpMdaSt4T9Qa2fVhC9N2gDspFl8qhon2/18I0FVXy0Bjw+jzlxHeEIL12U70ltFR4
 RG6Nx51xV49qZ9VPUDBpzUo6DOWCIdLfbI0IRiuWwt4kxtcaDk1g44mTzqnWUN7tsjSUakCA3y
 vj/ziQ01qYnSo75nt2skoYsr7bw4iXGok07rLwPPV+G7Wq60Acsw+5lXb8CWqYTkr2wFOs3AR1
 eSQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2021 19:22:30 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v9 5/5] doc: Fix typo in request queue sysfs documentation
Date:   Wed, 27 Oct 2021 11:22:23 +0900
Message-Id: <20211027022223.183838-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027022223.183838-1-damien.lemoal@wdc.com>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a typo (are -> as) in the introduction paragraph of
Documentation/block/queue-sysfs.rst.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/block/queue-sysfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index b6e8983d8eda..e8c74306f70a 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -4,7 +4,7 @@ Queue sysfs files
 
 This text file will detail the queue files that are located in the sysfs tree
 for each block device. Note that stacked devices typically do not export
-any settings, since their queue merely functions are a remapping target.
+any settings, since their queue merely functions as a remapping target.
 These files are the ones found in the /sys/block/xxx/queue/ directory.
 
 Files denoted with a RO postfix are readonly and the RW postfix means
-- 
2.31.1

