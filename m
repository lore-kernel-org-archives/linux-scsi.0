From: christophe.varoqui@free.fr
Subject: storageworks controlers & linux-scsi
Date: Mon, 25 Aug 2003 14:55:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061816116.3f4a073487d64@impt3-1.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:51343 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S261861AbTHYMzR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:55:17 -0400
Received: from impt3-1.proxad.net (impt3-1.free.fr [213.228.0.81])
	by postfix4-2.free.fr (Postfix) with ESMTP id A0AE0C2F2
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2003 14:55:16 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

In 2.4.21, a LUN hosted by a storageworks FC controler in multibus failover was
shown through 4 devices per HBA. 2 usable devices, 2 hang process that submit IO
in D-state. Such unusable devices, ghost paths, could be activated by sg_start.

In current 2.4.22 pre-release and 2.6, only the valid path get presented though
associated sd are allocated and partialy setup. There is no longer a clear way
to start the ghosts as sg_utils will refuse to submit commands. This behaviour
is dicted by the new BLIST_NOSTARTONADD bflag.

I would like to know what was the intention of this patch (from steeleye I
guess) ? What problems does it solve ?
Wouldn't it be better to consider ghosts as removable media, as one would get
automatic activation on IO submition ?

regards,
cva

-- 
