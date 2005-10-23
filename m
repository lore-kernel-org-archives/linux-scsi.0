From: Jeff Garzik <jgarzik@pobox.com>
Subject: [patch 0/6] marginalize HCIL a bit
Date: Sat, 22 Oct 2005 21:36:18 -0400
Message-ID: <20051023013618.GA18201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:27102 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751296AbVJWBgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:36:19 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 3DDD71C0960B
	for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2005 21:36:18 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N1aIbi018272
	for linux-scsi@vger.kernel.org; Sat, 22 Oct 2005 21:36:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch series makes a tiny bit of progress on the marginalize-SPI
todo list.

Patches:
1) s/scsi_scan_target/spi_scan_target/
2) remove unused scsi_scan_single_target()
3) add scsi_scan_target()
4) kill all uses of spi_scan_target()
5) kill spi_scan_target(), __spi_scan_target()
6) misc cleanups

