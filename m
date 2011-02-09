From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Updates for .38-rc5
Date: Wed,  9 Feb 2011 14:01:44 -0800
Message-ID: <1297288907-23066-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm29-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.248]:24844 "HELO
	nm29-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755907Ab1BIWBw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 17:01:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

The following three patches should also be included into for-38 mainline from
upstream LIO target code in lio-core-2.6.git.  These patches are against my
scsi-post-merge-2.6.git/for-38-rc5 tree containing the original 24 and 12 part
for-38 series here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc5

Please review and let me know if these need to be rebased.

Thanks,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Fubo Chen (1):
  target: Fix generated *_drop_nodeacl() handler in tcm_mod_builder.py

Nicholas Bellinger (2):
  target: Fix SCF_SCSI_CONTROL_SG_IO_CDB breakage
  target: Fix bogus return in transport_add_device_to_core_hba failure
    path

 Documentation/target/tcm_mod_builder.py |    1 +
 drivers/target/target_core_transport.c  |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
1.7.4

