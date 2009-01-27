From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] [Target_Core_Mod]: Updates for TYPE_ROM and
	VARIABLE_LENGTH_CMD
Date: Tue, 27 Jan 2009 14:06:46 -0800
Message-ID: <1233094006.6442.101.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:48558 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751957AbZA0WHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 17:07:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Greetings all,

This series updates adds the VLC_SA_RECEIVE_CREDENTIAL define per James's feedback,
and converts target_core_mod to use include/linux/cdrom.h:GPCMD_* prefixed MMC Opcode
defines for TYPE_ROM.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

[PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to VLC_SA_RECEIVE_CREDENTIAL
[PATCH 2/4] [Target_Core_Mod]: Change RECEIVE_CREDENTIAL -> VARIABLE_LENGTH_CMD
[PATCH 3/4] [Target_Core_Mod]: Remove LOAD_UNLOAD_MEDIUM usage from IBLOCK/FILEIO/RAMDISK
[PATCH 4/4] [Target_Core_Mod]: Convert TYPE_ROM support to use include/linux/cdrom.h GPCMD_* defines

>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating e384da7..a4bcd2c
Fast forward
 drivers/lio-core/target_core_base.h      |   59 ------------------------------
 drivers/lio-core/target_core_file.c      |    1 -
 drivers/lio-core/target_core_iblock.c    |    1 -
 drivers/lio-core/target_core_rd.c        |    1 -
 drivers/lio-core/target_core_transport.c |   31 +++++++++-------
 include/scsi/scsi.h                      |    4 ++-
 6 files changed, 20 insertions(+), 77 deletions(-)

--nab

