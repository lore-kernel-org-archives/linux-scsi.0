From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
Subject: MPT2SAS deadlocking on failed disk
Date: Sun, 24 Oct 2010 11:36:18 GMT
Message-ID: <0AF91KJ@briare1.fullpliant.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from briare1.fullpliant.org ([78.227.24.35]:42458 "HELO
	briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932440Ab0JXKpb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2010 06:45:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi@vger.kernel.org

Hi,

In stock Linux 2.6.35.7 kernel,
with mpt2sas driver connected to two disks (no raid at controler level),
and Linux MD software RAID1,

if I hot unplug one of the disks,
instead of the failed disk beeing removed from the MD raid set,
I get locked disk subsystem with all applications trying to write to
the disks beeing locked. No kernel message related to disks, only
to applications beeing locked.

This bug is probably not related specificaly to kernel 2.6.35.7
because I had not used LSI controlers for years.

Regards,
Hubert Tonneau

