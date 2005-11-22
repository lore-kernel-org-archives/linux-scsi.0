From: Jeff Johnson <jeff.johnson@wsm.com>
Subject: Kernel panic: BRKADRINT (aic79xx)
Date: Tue, 22 Nov 2005 09:26:27 -0800
Message-ID: <438354C3.5030802@wsm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from geryon.wsm.com ([12.163.128.2]:22686 "EHLO geryon.wsm.com")
	by vger.kernel.org with ESMTP id S965087AbVKVS02 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Nov 2005 13:26:28 -0500
Received: from [199.106.21.3] (helo=wsm.com)
	by charon.wsm.com with esmtp (Exim 4.43)
	id 1Eecs5-0005RS-6Z
	for linux-scsi@vger.kernel.org; Tue, 22 Nov 2005 10:28:02 -0800
Received: from [199.106.21.61] (account jeff.johnson HELO [199.106.21.61])
  by wsm.com (CommuniGate Pro SMTP 4.0.6)
  with ESMTP id 1293962 for linux-scsi@vger.kernel.org; Tue, 22 Nov 2005 11:26:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am seeing this issue when running heavy non-SCSI i/o over PCI-X. The 
Adaptec 7902 is on a different PCI-X bus than the Infiniband card 
performing high I/O. Both PCI-X buses interface with the AMD-8131 
HT/PCI-X tunnel. Only comments I am getting about the error are 
non-specific resource starvation. Has anyone seen this error before? If 
so any information as to a cause or fix would be appreciated. 

The only console message received is, after which the machine locks up:
--------------------------------------------
Kernel panic: BRKADRINT
In interrupt handler - not syncing
--------------------------------------------

OS: Suse SLES 9, 2.6.5-7.201smp, aic-79xx v2.0.15 (Adaptec source)



