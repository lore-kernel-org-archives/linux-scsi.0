From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] lpfc: Fix possible NULL pointer dereference
Date: Tue, 02 Aug 2016 01:17:24 -0400
Message-ID: <yq1ziovn40r.fsf@sermon.lab.mkp.net>
References: <1469799056-7708-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24395 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbcHBFSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 01:18:17 -0400
In-Reply-To: <1469799056-7708-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Fri, 29 Jul 2016 15:30:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Tyrel Datwyler <turtle.in.the.kernel@gmail.com>, James Smart <james.smart@broadcom.com>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Check for the existence of piocb->vport before accessing it.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
