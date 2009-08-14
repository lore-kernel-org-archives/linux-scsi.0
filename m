From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: Version 1.0.1.1 of SCST core, target drivers for iSCSI
 (iSCSI-SCST), QLogic 22xx/23xx (qla2x00t) as well as fileio_tgt user space
 backend handler released
Date: Fri, 14 Aug 2009 23:35:09 +0400
Message-ID: <4A85BC6D.9070803@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:65078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbZHNTfB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2009 15:35:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I'm glad to announce intermediate stable release 1.0.1.1 of SCST core, 
target drivers for iSCSI (iSCSI-SCST), QLogic 22xx/23xx (qla2x00t) and 
fileio_tgt user space backend handler.

SCST is an alternative implementation of SCSI target subsystem for
Linux. It provides unified, consistent interface between SCSI target
drivers and Linux kernel as well as between Linux kernel and storage
backend handlers, connecting target drivers with real or emulated
storage backend.

SCST allows creation of sophisticated storage devices, which provide
advanced functionality, like replication, thin provisioning,
deduplication, high availability, automatic backup, etc. Another class
of such devices are Virtual Tape Libraries (VTL) as well as other
disk-based backup solutions. SCST created devices not limited by IP
network interface only, but they can use any link supporting SCSI-style
data exchange, including Fibre Channel, SAS and parallel SCSI. It might
well be that your favorite storage appliance running SCST in the firmware.

More info about SCST core and modules you can find on:

   - SCST core: http://scst.sourceforge.net

   - iSCSI target driver iSCSI-SCST:
http://scst.sourceforge.net/target_iscsi.html

   - QLogic 22xx/23xx Fibre Channel target driver:
http://scst.sourceforge.net/target_qla22xx_23xx.html

   - fileio_tgt backend handler on
http://scst.sourceforge.net/handler_fileio_tgt.html.

SCST aims to be included in the mainline kernel. You can find the first
iteration of SCST patches review in http://lkml.org/lkml/2008/12/10/245.

Main coming features in the next major release 1.1.0 include persistent 
reservations, automatic sessions reassignment on management actions 
(i.e. connected initiators will see all the made configuration changes 
in a PnP manner, without any reconnects) as well as new SYSFS-base 
management interface.

You can download SCST core and modules from
http://scst.sourceforge.net/downloads.html.

Summary of changes in SCST core between versions 1.0.0 and 1.0.1.1
------------------------------------------------------------------

  - Issues cased by change of cdb_len to unsigned fixed

  - INIT ELEMENT STATUS WRANGE added to the list of known commands

  - Possible miss of UCMD_STATE_ON_FREEING event in scst_user fixed

  - Fix possible crash in scst_copy_sg()

  - Races on scst_user devices cleanup fixed

  - Incorrect errors reporting on scst_user devices unregistration fixed

  - Possible double free in scst_user fixed

  - 64-bit cleanups

  - Other minor fixes and cleanups


Summary of changes in iSCSI-SCST between versions 1.0.0 and 1.0.1.1
-------------------------------------------------------------------

  - Fixes in handling of initiators.allow and initiators.deny files

  - Wrong usage of parent request's fields in the response fixed.

  - Unneeded mutex_lock(&scst_mutex) removed, because it can be done on
    atomic or SIRQ context


Summary of changes in qla2x00t between versions 1.0.0 and 1.0.1.1
-----------------------------------------------------------------

  - Fix possible crash with too fast target mode enabling/disabling or
    module unload


Summary of changes in fileio_tgt between versions 1.0.0 and 1.0.1.1
-------------------------------------------------------------------

  - 64-bit cleanups

  - Other minor fixes and cleanups

Thanks to all who made it happen!
Vlad
