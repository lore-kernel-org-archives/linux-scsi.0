From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi_debug: simplify offset calculation for dif_storep
Date: Wed, 24 Apr 2013 22:18:26 -0400
Message-ID: <yq1wqrrs68d.fsf@sermon.lab.mkp.net>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
	<1366535879-20775-4-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46678 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3DYCSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 22:18:11 -0400
In-Reply-To: <1366535879-20775-4-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Sun, 21 Apr 2013 18:17:59 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

+		sector += len / sizeof(*dif_storep);

I'd rather see sizeof(struct scsi_dif_tuple) here. But that's just
personal preference. Otherwise ok.

-- 
Martin K. Petersen	Oracle Linux Engineering
