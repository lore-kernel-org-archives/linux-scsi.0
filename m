From: "Infante, Jon" <Jon.Infante@Emulex.Com>
Subject: suspending I/Os to a device
Date: Fri, 23 Apr 2004 08:59:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E704E37A7B@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56553 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264854AbUDWP7f
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Apr 2004 11:59:35 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.206])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i3NFxYcj009476
	for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2004 08:59:34 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Reflector <linux-scsi@vger.kernel.org>


Is there a standard, or generally accepted way, for a driver to request the
scsi layer temporarily suspend all I/Os to a particular Target or
Target/Lun. Conversely, I would want to resume I/Os at a driver determined
time without the scsi layer timing them out. 

--
Jon Infante
Emulex
