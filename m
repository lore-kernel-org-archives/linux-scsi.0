From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/6] scsi_debug: add translation functions between LBA and index of provisioning map
Date: Wed, 24 Apr 2013 21:43:17 -0400
Message-ID: <yq1ppxjtmfe.fsf@sermon.lab.mkp.net>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
	<1366117920-11740-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38223 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3DYBnD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:43:03 -0400
In-Reply-To: <1366117920-11740-5-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Tue, 16 Apr 2013 22:11:58 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> The translation from LBA to index of provisioning map
Akinobu> (map_storep) is used in various places (map_state(),
Akinobu> map_region(), and unmap_region()).  But it is not correctly
Akinobu> calculated if scsi_debug_unmap_alignment is zero.

Akinobu> This introduces correct translation functions between LBA and
Akinobu> index of provisioning map:

Akinobu>         static unsigned long lba_to_map_index(sector_t lba);
Akinobu>         static sector_t map_index_to_lba(unsigned long index);

Akinobu> Actual bug fixes with using these functions will be done by
Akinobu> forthcoming patches.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
