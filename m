From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/6] scsi_debug: prohibit scsi_debug_unmap_granularity == scsi_debug_unmap_alignment
Date: Wed, 24 Apr 2013 21:37:01 -0400
Message-ID: <yq1y5c7tmpu.fsf@sermon.lab.mkp.net>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
	<1366117920-11740-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18666 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3DYBgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:36:48 -0400
In-Reply-To: <1366117920-11740-3-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Tue, 16 Apr 2013 22:11:56 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> scsi_debug prohibits setting scsi_debug_unmap_alignment to be
Akinobu> greater than scsi_debug_unmap_granularity.  But setting them to
Akinobu> be the same value is not prohibited.  In this case, the only
Akinobu> difference with scsi_debug_unmap_alignment == 0 is the logical
Akinobu> blocks from 0 to scsi_debug_unmap_alignment - 1 cannot be
Akinobu> unmapped.  But the difference is not properly handled in the
Akinobu> current code.

Akinobu> So this prohibits such unusual setting.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
