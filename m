From: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Subject: can_queue modification within select_queue_depths
Date: Wed, 18 Aug 2004 14:17:05 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41233AB1.7030605@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shosh.galileo.co.il ([199.203.130.250]:7309 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S265887AbUHRLRI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2004 07:17:08 -0400
Received: from [127.0.0.1] ([10.4.22.164])
	by il.marvell.com (8.12.10/8.12.10) with ESMTP id i7IBEsDF007375
	for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2004 14:14:55 +0300 (IDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
    is it allowed to modify the host can_queue with select_queue_depths 
function?
    if yes, is it needed to lock/unlock io_request_lock ?
thanks  

-- 
Saeed Bishara
Marvell Semiconductor Israel Ltd
6 Ha'mada St.
Industrial Area
P.O. Box 692
Yokneam 20692 ISRAEL
Email    -  Saeed.Bishara@il.marvell.com
Tel      -  + 972 4 9091602
Cell     -  + 972 54 7619030
Fax      -  + 972 4 9091505
WWW Page:     http://www.marvell.com 

This message may contain confidential, proprietary or legally privileged information. The information is intended only for the use of the individual or entity named above. If the reader of this message is not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this communication in error, please notify us immediately by telephone, or by e-mail and delete the message from your computer.



