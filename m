From: ching <ching2048@areca.com.tw>
Subject: [PATCH 1.2 0/16] arcmsr: bugfix and support new adapters ARC12x4
 series
Date: Wed, 14 May 2014 18:59:35 +0800
Message-ID: <1400065175.6957.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:48992 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaENK7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2014 06:59:43 -0400
Received: by mail-ve0-f171.google.com with SMTP id oz11so2131555veb.16
        for <linux-scsi@vger.kernel.org>; Wed, 14 May 2014 03:59:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


In last patch v1.1 16/16 series, patch2 has been updated several time.
The patch line number, from patch3 to patch16, are all shifted.
So I repost the corrected patch files, patch v1.2 17/16 series.

In the meantime, I add a new patch 17 to fix of calling scsi_scan_host() after every initialization are done.

Thanks,
Ching

