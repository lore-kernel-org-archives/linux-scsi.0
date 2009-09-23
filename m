From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/20] mpt2sas : Description patch
Date: Wed, 23 Sep 2009 17:20:21 +0530
Message-ID: <20090923115021.GE6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:53701 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbZIWMee (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:34:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver updates. 03.100.03.00

Please consider patches for next kernel version.
These patches are generated considering MPT2SAS 02.100.03.00.
patches for 02.100.03.00 version were submitted on 2009-09-14.

[PATCH 1/20] mpt2sas: 	Driver will use sas address instead of handle as a lookup
[PATCH 2/20] mpt2sas: 	Expander remove fails when it is proccessing another
			expander add.
[PATCH 3/20] mpt2sas: 	Add support in the driver to check for valid response
		      	info

[PATCH 4/20] mpt2sas: 	New device SAS2208 support is added.
[PATCH 5/20] mpt2sas: 	Adding MPI Headers - revision L
[PATCH 6/20] mpt2sas: 	Support for stopping driver when Firmware encounters
		     	faults
[PATCH 7/20] mpt2sas: 	Fixed some of the comment.
[PATCH 8/20] mpt2sas: 	Added command line option diag_buffer_enable.
[PATCH 9/20] mpt2sas: 	Add Extended Type for Diagnostic Buffer support - MPI
		     	2.0 Rev. L change
[PATCH 10/20] mpt2sas: 	Added support to set the TimeStamp when sending
		     	ioc_init.
[PATCH 11/20] mpt2sas: 	Limit the max_depth to 32 for SATA devices which are
			not part of Volumes.

[PATCH 12/20] mpt2sas: 	Added new info messages for IR and Expander events.
[PATCH 13/20] mpt2sas: 	Retrieve the ioc facts prior to putting the controller
		     	into READY state
[PATCH 14/20] mpt2sas: 	Return DID_TRANSPORT_DISRUPTED in nexus loss and
		     	SCSI_MLQUEUE_DEVICE_BUSY if device is busy.
[PATCH 15/20] mpt2sas: 	mpt2sas_base_get_sense_buffer_dma should be returning
		     	little endian
[PATCH 16/20] mpt2sas: 	PPC (power pc) endian bug fix's
[PATCH 17/20] mpt2sas: 	Freeze the sdev IO queue when firmware sends internal
		     	device reset
[PATCH 18/20] mpt2sas: 	Add support for RAID Action System Shutdown Initiated at
	             	OS Shutdown
[PATCH 19/20] mpt2sas: 	No link rate change, do not call update links nor
		     	unblock device.
[PATCH 20/20] mpt2sas: 	Bump version 03.100.03.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
