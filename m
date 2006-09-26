From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 0/3] [SCSI] Small scsi fixes and cleanups
Date: Tue, 26 Sep 2006 10:06:51 +0200
Message-ID: <11592580111076@messid.opensource.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51394 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1750783AbWIZIGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 04:06:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

This small series sends out my current minor SCSI fixes.

01: aic7xxx: mark ahd_pci_ident_table and ahd_num_pci_devs static
02: remove extra newline from info message
    This extra newline causes dmesg and syslog to contain a completely 
    empty line for every scanned controller
03: Fix scsi/scsi_transport.h compile error
    If you don't get the magic include order for this file right it will 
    fail compilation. Pull in the correct include to this file so it will 
    always work.

Eike

