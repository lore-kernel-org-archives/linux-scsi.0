From: Jianyong Zhang <jzhang@cse.psu.edu>
Subject: Is sector no. related to partitions in scsi drivers?
Date: Wed, 28 Aug 2002 21:06:38 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.SOL.4.33.0208282057580.23561-100000@frack.cse.psu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frack.cse.psu.edu (frack.cse.psu.edu [130.203.18.37])
	by mail.cse.psu.edu (CSE Mail Server) with ESMTP id AEB7519A0C
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2002 21:06:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
	by frack.cse.psu.edu (Postfix Null Client) with ESMTP id 600071D8DE
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2002 21:06:38 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

  Now I want to write a io trace collect tool in the scsi driver layer. I
use aix7xxx driver, and collect io trace in the end of the funcion
ahc_linux_run_device_queue() in the file
drivers/scsi/aic7xxx/aic7xxx_linux.c .  According to my understanding,
here cmd->request.sector is related to the begining of the partition, not
to the whole disk (suppose one disk has several partitions), is it right?

  I'm wonder where this request's sector number will be converted to one
related to the whole disk. Is it done by the firmware of controller?

