From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/6] scsi_debug: fix logical block provisioning support
Date: Wed, 24 Apr 2013 21:46:20 -0400
Message-ID: <yq1haivtmab.fsf@sermon.lab.mkp.net>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
	<1366117920-11740-7-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20777 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3DYBqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:46:05 -0400
In-Reply-To: <1366117920-11740-7-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Tue, 16 Apr 2013 22:12:00 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> This problem is due to the wrong translation between LBA and
Akinobu> index of provisioning map.  Fix it by using correct translation
Akinobu> functions added previously.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
