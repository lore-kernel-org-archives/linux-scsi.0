From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: problems with scsi_transport_fc and qla2xxx
Date: Tue, 28 Feb 2006 19:53:56 +0300
Message-ID: <715414614.20060228195356@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout5.netvision.net.il ([194.90.9.29]:7135 "EHLO
	mxout5.netvision.net.il") by vger.kernel.org with ESMTP
	id S932081AbWB1RyD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 12:54:03 -0500
Received: from CBL217-132-247-11.bb.netvision.net.il ([217.132.247.11])
 by mxout5.netvision.net.il
 (Sun Java System Messaging Server 6.1 HotFix 0.11 (built Jan 28 2005))
 with ESMTP id <0IVE00KM1SDW4C00@mxout5.netvision.net.il> for
 linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:54:01 +0200 (IST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!
I'm checking 2.6.16-rc5 with 2 QLogic 2312 adapters using qla2xxx
driver from 2.6.16-rc5.
As with earlier kernels, I think > 2.6.12 (since scsi_transport_fc
gained functionality) I have the following problem.
2 scsi hosts available, 4 and 5 (for QLogic).
I disconnect the cable from one of QLogic cards. After timeout I have
the message
rport-4:0-0: blocked FC remote port time out: removing target and saving binding
and appropriate SCSI devices that came from adapter 4 disappear from
/proc/scsi/scsi.
So far, so good.
I reconnect the cable, the directory
/sys/class/fc_remote_ports/rport-4:0-1 appears along with the old
ones rport-4:0-0 and rport-5:0-0, so currently I have 3.
However, no automatic rescan appears on adapter 4.
What's worse, if I try echo "0 1 0" > /sys/class/scsi_host/host4/scan
the process is stuck.
Please advise.

Thanks,

Maxim.

