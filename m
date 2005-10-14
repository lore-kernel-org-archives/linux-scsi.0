From: Roger While <simrw@sim-basis.de>
Subject: 2.6 - SCSI Config parameter always set ?
Date: Fri, 14 Oct 2005 16:16:54 +0200
Message-ID: <6.1.1.1.2.20051014161632.026dc918@192.168.6.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout10.sul.t-online.com ([194.25.134.21]:39874 "EHLO
	mailout10.sul.t-online.com") by vger.kernel.org with ESMTP
	id S1750754AbVJNORN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 10:17:13 -0400
Received: from simrog.sim-basis.de [192.168.6.50]
	by sim-basis.de [192.168.6.2]
	with SMTP (MDaemon.PRO.v5.0.4.R)
	for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2005 16:19:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

CONFIG_SCSI_QLA2XXX=y

It seems as though this is always set with no method
of unsetting it.
Is this intentional ?

It's been like this since at least 2.6.11 up to current 2.6.14rc4.

Roger While



