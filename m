From: Douglas Gilbert <dougg@torque.net>
Subject: sdparm cannot start or stop SATA disks
Date: Fri, 29 Jul 2005 20:47:51 +1000
Message-ID: <42EA0957.9010408@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:39863 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262568AbVG2Kr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 06:47:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 02F053947DC
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2005 20:47:50 +1000 (EST)
Received: from [192.168.48.80] (dsl-94.28.240.220.dsl.comindico.com.au [220.240.28.94])
	by borg.st.net.au (Postfix) with ESMTP id 5F924394984
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2005 20:47:49 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Putting this post on this list might head off
more (private) emails on this subject.

sdparm uses the START STOP UNIT SCSI command to start
and stop (spin up and spin down) SCSI devices.
Currently libata does not implement that SCSI command.
[Hopefully Jeff contradicts me.]

Has anybody seen a USB or 1394 enclosure that implements
START STOP UNIT? [The command is defined in SBC, MMC and
RBC.]

Doug Gilbert

