From: Eric Moore <eric.moore@lsi.com>
Subject: [RFC 0/12] mpt2sas - new device driver
Date: Mon, 3 Nov 2008 01:34:00 -0700
Message-ID: <20081103083358.GA3337@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40336 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYKCW1r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 17:27:47 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id mA3MMZ9L019090
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 14:22:35 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id mA3MRhYC006559
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 14:27:43 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

* Here is first draft of mpt2sas for your review and comment. 
  This is new scsi lld device driver supporting the SAS 2.0 standard.
  This driver source sits in the scsi-ml tree.	
  (We went with new device driver due to major changes in the driver-firmware transport interface)

* Here is list of new 6gb host controllers:

  LSI SAS2004 - Spitfire
  LSI SAS2008 - Falcon
  LSI SAS2108 - Liberator
  LSI SAS2116 - Meteor

* Here is a summary of the patchs:

[PATCH 1/12] mpt2sas_base.c - Common API layer interface to MPT (Message Passing Technology) firmware.
[PATCH 2/12] mpt2sas_config.c - Common API for accessing firmware configuration pages.
[PATCH 3/12] mptsas_ctl.[c,h] - Storage Management Module.
[PATCH 4/12] mpt2sas_scsih.c - SCSI Host Layer.
[PATCH 5/12] mpt2sas_transport.c - Common API for accessing the Kernel SAS Transport Layer.
[PATCH 6/12] mpt2sas_base.h - Header shared structs.
[PATCH 7/12] mpt2sas_debug.h - Header for debug logging.
[PATCH 8/12] mptsas/mpi/* -  Common MPI (Message Passing Interface) Headers.
[PATCH 9/12] Kconfig: Kernel configuration file.
[PATCH 10/12] Makefile - Driver Makefile
[PATCH 11/12] Kconfig, scsi-ml - Adding mptsas.
[PATCH 12/12] linux/miscdevice.h - Adding suport for MPT2SAS_MINOR


Signed-off-by: Eric Moore <eric.moore@lsi.com>
