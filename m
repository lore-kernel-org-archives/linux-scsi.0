From: Frederic TEMPORELLI <frederic.temporelli@bull.net>
Subject: proc_name in sysfs
Date: Wed, 06 Apr 2005 13:40:04 +0200
Message-ID: <4253CA94.8000500@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:20449 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S262168AbVDFLkR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2005 07:40:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 4810319D90D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2005 13:40:08 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 17353-07 for <linux-scsi@vger.kernel.org>;
 Wed,  6 Apr 2005 13:40:06 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 600C919D90A
	for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2005 13:40:06 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by openx3.frec.bull.fr (Postfix) with ESMTP id C4A312B0EC
	for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2005 13:40:04 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,


We are using HBAs modules names from "proc_name" interface in sysfs:
/sys/class/scsi_host/hostX/proc_name.

But with new Emulex drivers (8.0.21 and +), proc_name is reporting <NULL> 
(previous drivers were reporting "lpfc").
=> In the driver code, .proc_name field from scsi_host_template structure is no 
more initialized.
James Smart told us that the "removal" of .proc_name field (not really removed, 
but no more initialized) was part of the /proc interfaces removal (suggested by 
scsi-linux feedback).

So:
1/ now, what is the aim of proc_name interface (reporting "<NULL>") in sysfs ?
2/ now, how can we get the adapter module name from sysfs ?

=> I'm just thinking that .proc_name field has to be kept initialized and/or 
something has to be changed to replace the confusing "proc" prefix.


Best regards


-- 
Frederic TEMPORELLI
Bull - Echirolles - France
