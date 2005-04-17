From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.28 available
Date: Sun, 17 Apr 2005 10:16:07 -0500
Message-ID: <1113750967.5011.3.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AB99@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:60120 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261317AbVDQPQM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Apr 2005 11:16:12 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AB99@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-04-14 at 08:39 -0400, James.Smart@Emulex.Com wrote:
> We have been working with Christoph over the last few weeks to address
> some last comments, and believe that this release is ready for
> inclusion with the upstream kernel.

As Christoph said, you could have made my job quite a bit easier by
having a patch for the kernel tree as well...

However, this is the form I chose:

 Documentation/scsi/ChangeLog.lpfc  | 1865 +++++++++++++++++++++
 Documentation/scsi/lpfc.txt        |   83 
 drivers/scsi/Kconfig               |    8 
 drivers/scsi/Makefile              |    1 
 drivers/scsi/lpfc/Makefile         |   32 
 drivers/scsi/lpfc/lpfc.h           |  384 ++++
 drivers/scsi/lpfc/lpfc_attr.c      | 1291 ++++++++++++++
 drivers/scsi/lpfc/lpfc_compat.h    |   97 +
 drivers/scsi/lpfc/lpfc_crtn.h      |  216 ++
 drivers/scsi/lpfc/lpfc_ct.c        | 1237 ++++++++++++++
 drivers/scsi/lpfc/lpfc_disc.h      |  206 ++
 drivers/scsi/lpfc/lpfc_els.c       | 3258 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 2537 ++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hw.h        | 2687 ++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c      | 1739 +++++++++++++++++++
 drivers/scsi/lpfc/lpfc_logmsg.h    |   41 
 drivers/scsi/lpfc/lpfc_mbox.c      |  646 +++++++
 drivers/scsi/lpfc/lpfc_mem.c       |  179 ++
 drivers/scsi/lpfc/lpfc_nportdisc.c | 1842 ++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_scsi.c      | 1246 ++++++++++++++
 drivers/scsi/lpfc/lpfc_scsi.h      |  157 +
 drivers/scsi/lpfc/lpfc_sli.c       | 2885 ++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.h       |  216 ++
 drivers/scsi/lpfc/lpfc_version.h   |   32 
 24 files changed, 22885 insertions(+)

We can fix up any remaining issues in-tree.

James


