From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL 0/4] target patches for scsi-post-merge .38
Date: Mon, 10 Jan 2011 16:02:21 -0800
Message-ID: <1294704141-26135-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:25604 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752749Ab1AKACi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 19:02:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Gustavo Panizzo <gfaraway@gmail.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

Please pull the following set of target patches rebased against scsi-post-merge
for .38 here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git master

This includes an improved version of your patch to address the 1024+ byte stack
usage warning and two other PR releated bug-fixes to address issues reported by
Gusatvo Panizzo with Vertias Cluster on RHEL5 + Open-iSCSI clients in the last
weeks.  These changes have been tested, verified externally, committed into
upstream lio-core-2.6.git and posted to linux-scsi for review.  At this point
with the addition of the MAINTAINERS entry, the core target pieces will be in
sync with scsi-post-merge from upstream TCM code.

Thanks again to Gustavo for his testing with lio-4.0 code over the holidays
and all his help to get the Vertias Cluster working with a generic PR bugfix
that applies to all SCSI target fabrics!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  target: Fix excessive stack usage
  target: Fix T_TASK(cmd)->t_task_cdb assignement breakage
  target: Add missing core_scsi3_put_pr_reg() for explict REGISTER key
    change
  target: Add drivers/target/ entry to MAINTAINERS

 MAINTAINERS                            |   10 ++++++++++
 drivers/target/target_core_pr.c        |   15 ++++++++-------
 drivers/target/target_core_transport.c |   16 +++++++++-------
 3 files changed, 27 insertions(+), 14 deletions(-)

-- 
1.7.3.5

