From: christophe.varoqui@free.fr
Subject: oss emulex linux driver : error report
Date: Thu, 18 Mar 2004 12:30:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079609445.405988655230b@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:34743 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S262528AbUCRLar
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2004 06:30:47 -0500
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

Hello,

I report a bad behaviour with a LP952 HBA :
06:02.0 Fibre Channel: Emulex Corporation LP952 Fibre Channel Adapter (rev 01)

Symptoms in dmesg when insmod lpfcdd.ko :
Emulex LightPulse FC SCSI 2.10c
lpfc 0000:06:02.0: 0:0442:INe:Adapter failed to init, mbxCmd x88 CONFIG_PORT,
mbxStatus x12 Data: x0
lpfc 0000:06:02.0: 0:0442:INe:Adapter failed to init, mbxCmd x88 CONFIG_PORT,
mbxStatus x12 Data: x0

The kernel is 2.6.3-mm1

regards,
cvaroqui
-- 
