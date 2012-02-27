From: LinuxDrvDev <ushmasonal-linuxmail@yahoo.com>
Subject: (unknown)
Date: Mon, 27 Feb 2012 12:33:46 -0800 (PST)
Message-ID: <1330374826.14558.YahooMailNeo@web160303.mail.bf1.yahoo.com>
Reply-To: LinuxDrvDev <ushmasonal-linuxmail@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:31467 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754276Ab2B0Udr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2012 15:33:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I am looking at the newer NVMe controllers for the SSD devices and evaluating appropriate driver interface for the device. Currently there is already a NVMe driver, which is designed as a block driver. However, since there is very little documentation available for the Block Interface, I am curious to know about the error handling capability of the block layer. Unlike SCSI interface, I don't see any reset that can be issued by the stack, in case if stack thinks the device is stuck. What is the error recovery capability of the block stack? Can someone please shed some light on this topic?
Thanks.

