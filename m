From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target-pending/3.3-urgent
Date: Wed, 14 Mar 2012 22:05:22 -0700
Message-ID: <1331787922.5969.129.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Martin Svec <martin.svec@zoner.cz>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Please pull the following two urgent v3.3 target patches here:

    git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.3-urgent

This series addresses two recently reported regression bugs related to
legacy SCSI reservation usage in target core, and iscsi-target
reservation conflict handling.

The second patch in particular addresses possible data-corruption with
SCSI reservations that is specific to iscsi-target fabric LUNs with
multiple client writers.  Both patches need to go into v3.2 stable ASAP,
and the branch based on the last target-pending/3.3-rc-fixes HEAD. 

Again, thanks to Martin Svec for his help to identify and address this
regression bug with iscsi-target.

Please let me know if you have any issues pulling.

Thanks,

--nab

Nicholas Bellinger (2):
  target: Fix compatible reservation handling (CRH=1) with legacy
    RESERVE/RELEASE
  iscsi-target: Fix reservation conflict -EBUSY response handling bug

 drivers/target/iscsi/iscsi_target.c    |    2 +-
 drivers/target/target_core_pr.c        |   34 ++++++++++++++++++++-----------
 drivers/target/target_core_transport.c |    1 +
 3 files changed, 24 insertions(+), 13 deletions(-)
