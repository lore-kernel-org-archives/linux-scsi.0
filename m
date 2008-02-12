From: Linda Walsh <lkml@tlinx.org>
Subject: Drivers 'sd' & 'sr' need updating: please use bus_type methods...
Date: Mon, 11 Feb 2008 18:07:15 -0800
Message-ID: <47B0FF53.8010608@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([64.81.245.74]:59362 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbYBLCHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 21:07:15 -0500
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by ishtar.tlinx.org (8.13.3/8.12.10/SuSE Linux 0.7) with ESMTP id m1C27FNk016683
	for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2008 18:07:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I turned on the option to flag deprecated code, and
these two popped up:
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods

I'm assuming these are referring to the SCSI devices?

I'm assuming they are already "known about"?

Just checking...
-l

