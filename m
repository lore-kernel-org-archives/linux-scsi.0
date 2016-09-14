From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] sd: move DIF protection types to t10-pi.h
Date: Wed, 14 Sep 2016 14:34:35 -0400
Message-ID: <yq1h99il490.fsf@sermon.lab.mkp.net>
References: <1473615341-27203-1-git-send-email-hch@lst.de>
        <1473615341-27203-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40288 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932517AbcINSen (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2016 14:34:43 -0400
In-Reply-To: <1473615341-27203-4-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Sun, 11 Sep 2016 19:35:41 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> These should go together with the rest of the T10 protection
Christoph> information defintions.

Series looks good in general. However, now that you introduced t10-pi.h
it seems a bit odd to perpetuate the obsolete "DIF" terminology.

+enum t10_dif_type {
+	T10_DIF_TYPE0_PROTECTION = 0x0,
+	T10_DIF_TYPE1_PROTECTION = 0x1,
+	T10_DIF_TYPE2_PROTECTION = 0x2,
+	T10_DIF_TYPE3_PROTECTION = 0x3,
+};

How about?

enum t10_pi_type {
	T10_PI_TYPE0_PROTECTION = 0x0,
	T10_PI_TYPE1_PROTECTION = 0x1,
	T10_PI_TYPE2_PROTECTION = 0x2,
	T10_PI_TYPE3_PROTECTION = 0x3,
};

I don't mind fixing that up when I apply. Any objections?

-- 
Martin K. Petersen	Oracle Linux Engineering
