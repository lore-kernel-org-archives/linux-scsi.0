From: Anirban Chakraborty <anirban@qlogic.com>
Subject: [PATCH 0/5] qla2xxx: Code Refactoring
Date: Wed, 15 Oct 2008 22:43:49 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0810152210280.24642@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:41949 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYJPF7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 01:59:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

Hi,

We have refactored the qla2xxx FC driver in preparation for the multi queue and 
future SR IOV hardware. Following changes are made to the driver.

1. scsi_qla_host structure has been changed to contain scsi host specific 
data only.
2. A new structure, qla_hw_data is created to contain HBA specific hardware data
3. Request and response IO specific data strucures are created.
4. Outstanding commands are now based to a request queue.
5. The global list of fcports for the hba is not maintained anymore, instead 
a fcport list is construted on per scsi_qla_host.
6. start_scsi function is now accessed via function pointer from the 
isp_ops struct.
7. Interrupt handler registrations are done with the rsp_que, instead 
of the device id.

Thank you,
Anirban
