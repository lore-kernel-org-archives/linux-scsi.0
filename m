From: Chuck Ebbert <cebbert@redhat.com>
Subject: SCSI devices with 256-byte sectors don't work?
Date: Mon, 26 Feb 2007 14:51:06 -0500
Message-ID: <45E33A2A.2050506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbXBZTvL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Feb 2007 14:51:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>

Apparently there really are such devices:

Sep 28 20:05:42 localhost kernel: scsi4 : SCSI emulation for USB Mass Storage devices
Sep 28 20:05:42 localhost kernel:   Vendor: Sandisk   Model: ImageMate SDDR09  Rev: 0100
Sep 28 20:05:42 localhost kernel:   Type:   Direct-Access            ANSI SCSI revision: 02
Sep 28 20:05:51 localhost kernel: sddr09: Found Flash card, ID = 98 EA 00 00: Manuf. Toshiba, 2 MB
Sep 28 20:05:51 localhost kernel: SCSI device sdd: 8160 256-byte hdwr sectors (2 MB)
Sep 28 20:05:51 localhost kernel: sdd: test WP failed, assume Write Enabled
Sep 28 20:05:51 localhost kernel: sdd: assuming drive cache: write through
Sep 28 20:05:51 localhost kernel:  sdd:SCSI error : <4 0 0 0> return code = 0x10070000
Sep 28 20:05:51 localhost kernel: end_request: I/O error, dev sdd, sector 0
Sep 28 20:05:51 localhost kernel: Buffer I/O error on device sdd, logical block 0

Last three lines just repeat over and over.
