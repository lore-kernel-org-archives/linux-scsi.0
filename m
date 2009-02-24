From: Eric Moore <eric.moore@lsi.com>
Subject: [RFC 0/11] mpt2sas: LSI SAS 2.0 6gb device drivers
Date: Tue, 24 Feb 2009 02:31:04 -0700
Message-ID: <20090224093102.GA11758@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:51399 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZBXXMn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 18:12:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

* This is new scsi lld device driver from LSI supporting the SAS 2.0 standard. I have split patchs by filename. Please consider this for drivers/staging merge.

* Here is list of new 6gb host controllers:

  LSI SAS2004
  LSI SAS2008
  LSI SAS2108
  LSI SAS2116

* Here is a summary of the patchs:

[PATCH 1/11] mpt2sas_base - Common API layer interface to MPT (Message Passing Technology) firmware.
[PATCH 2/11] mpt2sas_config - Common API for accessing firmware configuration pages.
[PATCH 3/11] mptsas_ctl - Storage Management Module.
[PATCH 4/11] mpt2sas_scsih - SCSI Host Layer.
[PATCH 5/11] mpt2sas_transport - Common API for accessing the Kernel SAS Transport Layer.
[PATCH 6/11] mpt2sas_debug - Common Header for debug logging.
[PATCH 7/11] mpi headers  -  Common MPI (Message Passing Interface) Headers.
[PATCH 8/11] Kconfig: mpt2sas Kernel configuration file.
[PATCH 9/11] Makefile - mpt2sas driver Makefile.
[PATCH 10/1] scsiml Kconfig - Adding mptsas to the common scsi ml Kconfig.
[PATCH 11/11] linux/miscdevice.h - Adding suport for MPT2SAS_MINOR(221)

 Kconfig              |   66
 Makefile             |    7
 mpi/mpi2.h           | 1067 +++++++++
 mpi/mpi2_cnfg.h      | 2151 +++++++++++++++++++
 mpi/mpi2_history.txt |  294 ++
 mpi/mpi2_init.h      |  420 +++
 mpi/mpi2_ioc.h       | 1295 +++++++++++
 mpi/mpi2_raid.h      |  295 ++
 mpi/mpi2_sas.h       |  282 ++
 mpi/mpi2_targ.h      |  440 +++
 mpi/mpi2_tool.h      |  249 ++
 mpi/mpi2_type.h      |   61
 mpt2sas_base.c       | 3403 ++++++++++++++++++++++++++++++
 mpt2sas_base.h       |  781 +++++++
 mpt2sas_config.c     | 1863 ++++++++++++++++
 mpt2sas_ctl.c        | 2519 ++++++++++++++++++++++
 mpt2sas_ctl.h        |  416 +++
 mpt2sas_debug.h      |  181 +
 mpt2sas_scsih.c      | 5663 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mpt2sas_transport.c  | 1207 ++++++++++
 20 files changed, 22660 insertions(+)

Signed-off-by: Eric Moore <eric.moore@lsi.com>
