From: <sreekanth.reddy@lsi.com>
Subject: [v2 PATCH 0/20][SCSI] mpt3sas: Driver submission v01.100.01.00
Date: Fri, 30 Nov 2012 07:41:36 +0530
Message-ID: <20121130021136.GA10134@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:33693 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab2K2POL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Nov 2012 10:14:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This is new scsi lld device driver from LSI supporting the SAS 3.0
standard.

Here is list of new 12gb host controllers:

  LSI SAS3004
  LSI SAS3008
  LSI SAS3108

Here are the changes in the 2nd posting of this patch set:

 (1) Fix compile errors when SCSI_MPT3SAS_LOGGING is not enabled.
 (2) Set the task attribute field to "Simple" if the mpt3sas driver receives CDB with
     untagged task attribute field.
 (3) Fix for an issue due to which the phys are not discovered when volume members are
     hot removed and added while performing diag reset.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---
Here is the brief description of patches:
[PATCH 01/20] [SCSI] mpt3sas : Makefile, Kconfig and scsi_transport_sas file changes to support new driver mpt3sas
[PATCH 02/20] [SCSI] mpt3sas : MPI API headers. This patch is part 1 of MPI API headers.
[PATCH 03/20] [SCSI] mpt3sas : MPI API headers. This patch is part 2 of MPI API headers.
[PATCH 04/20] [SCSI] mpt3sas : MPI API headers. This patch is part 3 of MPI API headers.
[PATCH 05/20] [SCSI] mpt3sas : MPI API headers. This patch is part 4 of MPI API headers.
[PATCH 06/20] [SCSI] mpt3sas : MPI API headers. This patch is part 5 of MPI API headers.
[PATCH 07/20] [SCSI] mpt3sas : Fusion MPT base driver providing common API layer interface
						for access to MPT (Message Passing Technology) firmware.
						This patch is part 1 of mpt3sas_base.c
[PATCH 08/20] [SCSI] mpt3sas : This patch is part 2 of mpt3sas_base.c
[PATCH 09/20] [SCSI] mpt3sas : Fusion MPT base driver providing common API layer interface
						headers for access to MPT (Message Passing Technology) firmware.
[PATCH 10/20] [SCSI] mpt3sas : Common API for accessing firmware configuration pages
[PATCH 11/20] [SCSI] mpt3sas : Ioctl Support for MPT (Message Passing Technology)
						based controller
[PATCH 12/20] [SCSI] mpt3sas : Ioctl Module Support headers for MPT (Message Passing Technology)
						based controllers
[PATCH 13/20] [SCSI] mpt3sas : Logging Support for MPT (Message Passing Technology)
						based controllers
[PATCH 14/20] [SCSI] mpt3sas : Code related to Scsi Host Layer for
						MPT (Message Passing Technology) based controllers
						This patch is part 1 of mpt3sas_scsih.c
[PATCH 15/20] [SCSI] mpt3sas : This patch is part 2 of mpt3sas_scsih.c
[PATCH 16/20] [SCSI] mpt3sas : This patch is part 3 of mpt3sas_scsih.c
[PATCH 17/20] [SCSI] mpt3sas : Code related to SAS Transport Layer for
					MPT (Message Passing Technology) based controllers
[PATCH 18/20] [SCSI] mpt3sas : Common API to set Diagnostic trigger for MPT
					(Message Passing Technology) based controllers
[PATCH 19/20] [SCSI] mpt3sas : Common API headers to set Diagnostic trigger for MPT
					(Message Passing Technology) based controllers
[PATCH 20/20] [SCSI] mpt3sas : Adding support for MPT3SAS_MINOR(222)
