From: "Ely, Paul" <Paul.Ely@Emulex.com>
Subject: RE: suspending I/Os to a device
Date: Fri, 23 Apr 2004 12:28:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28025AB518@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:21230 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261947AbUDWQ2g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Apr 2004 12:28:36 -0400
Received: from xbl.ad.emulex.com (xbl.ma.emulex.com [138.239.73.11])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i3NGSZcj010717
	for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2004 09:28:35 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Goodafternoon Jon,

What about the use of scsi_block_requests and scsi_unblock_requests?

There doesn't appear to be any timer event used by the OS and the
only way to restart commands is for the driver to call
scsi_unblock_requests.

We have two routines for this:  lpfc_block_requests and
lpfc_unblock_requests.

Paul


-----Original Message-----
From: Infante, Jon 
Sent: Friday, April 23, 2004 12:00 PM
To: Linux SCSI Reflector
Subject: suspending I/Os to a device



Is there a standard, or generally accepted way, for a driver to request the
scsi layer temporarily suspend all I/Os to a particular Target or
Target/Lun. Conversely, I would want to resume I/Os at a driver determined
time without the scsi layer timing them out. 

--
Jon Infante
Emulex
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
