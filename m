From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: DIF/DIX updates for 2.6.32
Date: Wed, 26 Aug 2009 02:17:56 -0400
Message-ID: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:56078 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbZHZHd6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2009 03:33:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, Ihab.Hamadi@emulex.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

Updates to the DIF/DIX code for 2.6.32:

 - Add support for 32-byte CDBs to SCSI layer

 - Deprecate the DIX CONVERT ops

 - Detach pure DIF support from CONFIG_BLK_DEV_INTEGRITY

 - Add support for DIF Type 2 devices in sd

 - Add DIF Type 2 support to scsi_debug



