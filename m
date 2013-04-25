From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/6] scsi_debug: fix initialization of provisioning map
Date: Wed, 24 Apr 2013 21:44:20 -0400
Message-ID: <yq1li87tmdn.fsf@sermon.lab.mkp.net>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
	<1366117920-11740-6-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20280 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3DYBoF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:44:05 -0400
In-Reply-To: <1366117920-11740-6-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Tue, 16 Apr 2013 22:11:59 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> provisioning map (map_storep) is a bitmap accessed by bitops.
Akinobu> So the allocation size should be a multiple of sizeof(unsigned
Akinobu> long) and also the bitmap should be cleared by using
Akinobu> bitmap_clear() instead of memset().

Akinobu> Otherwise it will cause problem on big-endian architecture if
Akinobu> the number of bits is not a multiple of BITS_PER_LONG.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
