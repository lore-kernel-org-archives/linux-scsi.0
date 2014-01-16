From: sagi grimberg <sagig@mellanox.com>
Subject: [LSF/MM TOPIC][ATTEND] T10-PI RDMA offload
Date: Thu, 16 Jan 2014 14:26:30 +0200
Message-ID: <52D7CFF6.4030901@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:53482 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbaAPM0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 07:26:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
Cc: Oren Duer <oren@mellanox.com>

Hey SCSI folks,

I'd like to propose the following topic for upcoming LSF-MM:

T10-PI standard is becoming more and more appealing for storage and 
cloud solutions. Since error-detection
coding comes with its cost of CPU computation overhead, state-of-the-art 
ASICs offer the ability to offload
T10-PI operations (DIF/DIX), examples are SAS & FC controllers. 
Recently, the support for T10-PI offload over
RDMA transactions was introduced in the Mellanox Connect-IB HCA.

The first building block, RDMA verbs API supporting T10-PI offload was 
submitted over Linux-rdma (see
http://marc.info/?l=linux-rdma&m=138719320307936&w=2). Moreover, We have 
seen first seeds of T10-PI
support in Linux SCSI target entering v3.14 (see 
http://lwn.net/Articles/579708/) and RDMA offload
implementation in iSER transport (see 
http://www.spinics.net/lists/linux-scsi/msg71128.html). There is
still some ground to fill to get protection information support to a 
full solution over all backend devices.

We would like to use LSF-MM platform to to push forward T10-PI support 
end-to-end which requires Linux SCSI
Target core level support along with transport level support in iSER and 
SRP (and also FCoE in the future) and
over to the Initiator side transports.

Discussion topics:
- Introduce T10-PI offload RDMA verbs and how are used in storage 
applications.
- Discuss effects of DIX1.1 (currently a draft) in Target implementation 
(core level -> transport level -> HW level).
- Discuss T10-PI Type 4 (16-byte DIF) status and possible implications 
on Target & Initiator implementation down to HW level.
- Discuss Current Limitations that T10-PI RDMA offload poses on iSCSI 
protocol (ImmediateData, UnsolDataOut) and if/how they can be solved.
- What-ever else comes to mind...

Thanks,
Sagi.
