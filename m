From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Mon, 08 Aug 2016 21:57:21 -0400
Message-ID: <yq1k2fqu2ke.fsf@sermon.lab.mkp.net>
References: <1470657309-9564-1-git-send-email-oneukum@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42570 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbcHIB6m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 21:58:42 -0400
In-Reply-To: <1470657309-9564-1-git-send-email-oneukum@suse.com> (Oliver
	Neukum's message of "Mon, 8 Aug 2016 13:55:09 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Alan Stern <stern@rowland.harvard.edu>

>>>>> "Oliver" == Oliver Neukum <oneukum@suse.com> writes:

Oliver> Some SATA to USB bridges fail to cooperate with some drives
Oliver> resulting in no cache being present being reported to the
Oliver> host. That causes the host to skip sending a command to
Oliver> synchronize caches. That causes data loss when the drive is
Oliver> powered down.

Alan?

-- 
Martin K. Petersen	Oracle Linux Engineering
