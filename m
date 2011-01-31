From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Add target_core_stat.c configfs code
Date: Mon, 31 Jan 2011 02:29:52 -0800
Message-ID: <1296469795-27632-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6.bullet.mail.ac4.yahoo.com ([98.139.52.203]:26794 "HELO
	nm6.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755343Ab1AaK3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2011 05:29:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

This patch series adds support for TCM backend, fabric port/LUN,
and MappedLUN/LunACL context struct config_group based statistics in
target_core_configfs.c and target_core_fabric_configfs.c code using
CONFIGFS_EATTR() based struct config_item_types.

This is based on target_core_mib.c procfs + seq_list based logic
broken up into individual configfs groups and attributes following
RFC4455.

Please have a look for review and comment,

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  target: add initial device backend context target_core_stat.c code
  target: add initial fabric port context target_core_stat.c code
  target: add initial fabric MappedLUN context target_core_stat.c code

