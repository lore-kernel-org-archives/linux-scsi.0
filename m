From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/6] scsi_debug: clear correct memory region when LBPRZ is enabled
Date: Wed, 24 Apr 2013 21:42:06 -0400
Message-ID: <yq1txmvtmhd.fsf@sermon.lab.mkp.net>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
	<1366117920-11740-4-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37986 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3DYBl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:41:56 -0400
In-Reply-To: <1366117920-11740-4-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Tue, 16 Apr 2013 22:11:57 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> The function unmap_region() clears memory region specified as
Akinobu> the logical block address and the number of logical blocks in
Akinobu> ramdisk storage (fake_storep) if lbpu and lbprz module
Akinobu> parameters are enabled.

Akinobu> In the while loop of unmap_region(), it advances optimal unmap
Akinobu> granularity in logical blocks.  But it only clears one logical
Akinobu> block at LBA 'block' per loop iteration.  And furthermore, the
Akinobu> 'block' is not pointing to a logical block address which should
Akinobu> be cleared, it is a index of probisioning map (map_storep).

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
