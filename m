From: Fabien Salvi <fabien@cri74.org>
Subject: (RAID controller) Unified way to get alarms
Date: Tue, 02 Mar 2004 10:05:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40444E62.2070705@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:62441 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S261515AbUCBJFP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Mar 2004 04:05:15 -0500
Received: from pc00 (pc00.cri.cur-archamps.fr [10.10.10.11])
	by aravis.cur-archamps.fr (Postfix) with ESMTP id 1E61111F0E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Mar 2004 10:05:13 +0100 (CET)
Received: from cri74.org (pc00 [127.0.0.1])
	by pc00 (Postfix) with ESMTP id 84F561EFBA
	for <linux-scsi@vger.kernel.org>; Tue,  2 Mar 2004 10:05:38 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I've noticed each PCI Raid card (for example ICP-Vortex ,LSILogic or 
ServerRAID) with their own driver uses a specific way to get alarms.

We could have several types of alarm or warning, depending on the event 
(degraded RAID, bad sectors detected, temperature sensor, etc...) :

- audible alarm ==> the more classical signal
- messages in kernel logs ==> not all drivers support this and each one 
send different messages
- messages in console ==> idem
- informations in /proc/scsi/... (for 2.4 kernel) ==> for example in 
/proc/scsi/gdth/0 with ICP controllers

- others ?


Unlike proprietary OS with proprietary (manufacter) driver, we have the 
ability under linux and with opensource drivers to use an unified way to 
get warning and alarms from a RAID controller.

Why don't use it ?

It will permit a single tool to manage these events without writing one 
per driver...

-- 
Fabien SALVI
