From: Rabeeh Khoury <rabeeh@il.marvell.com>
Subject: Linux limitation of amount of SCSI buses
Date: Tue, 29 Jul 2003 15:58:08 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F266F60.5070501@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop3.galileo.co.il ([199.203.130.130]:53172 "EHLO
	mail.galileo.co.il") by vger.kernel.org with ESMTP id S271704AbTG2M6g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 08:58:36 -0400
Received: from il.marvell.com (linux2.galileo.co.il [10.2.40.2])
	by mail.galileo.co.il (8.12.6/8.12.6) with ESMTP id h6TDu26D013579
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2003 15:56:02 +0200 (GMT-2)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I'm connecting few cards with 24 buses and Linux gives me only 15 buses.
Is there any limitation in Linux SCSI subsystem within kernel 2.4.x of 
the number of SCSI buses ?
Each bus has a single target and a single LUN.

Regards,
Rabeeh


