From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] ufs: introduce UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR quirk
Date: Wed, 16 Nov 2016 20:35:56 -0500
Message-ID: <yq17f82c2gz.fsf@sermon.lab.mkp.net>
References: <000401d23fc6$b6685110$2338f330$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16752 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753101AbcKQBgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 20:36:08 -0500
In-Reply-To: <000401d23fc6$b6685110$2338f330$@samsung.com> (Kiwoong Kim's
        message of "Wed, 16 Nov 2016 14:03:04 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

>>>>> "Kiwoong" == Kiwoong Kim <kwmad.kim@samsung.com> writes:

Hi Kiwoong,

Kiwoong> Some UFS host controllers may clear a transfer request slot by
Kiwoong> setting an associated bit in UTRLCLR/UTMRLCLR to 1, not 0.
Kiwoong> That's opposite to what UFS spec describes.

These don't apply cleanly to 4.10/scsi-queue. Please send a v4, ideally
as a series.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
