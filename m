From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/5] hpsa: driver updates, Oct 25, 2011
Date: Wed, 26 Oct 2011 16:20:47 -0500
Message-ID: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

The following series implements:

Scott Teel (2):
      hpsa: rename HPSA_MAX_SCSI_DEVS_PER_HBA
      hpsa: fix potential array overflow in hpsa_update_scsi_devices

Stephen M. Cameron (3):
      hpsa: set max sectors instead of taking the default
      hpsa: remove unused busy_initializing and busy_scanning
      hpsa: fix flush cache transfer length


 drivers/scsi/hpsa.c     |   37 ++++++++++++++++++++-----------------
 drivers/scsi/hpsa.h     |    5 +----
 drivers/scsi/hpsa_cmd.h |    5 ++++-
 3 files changed, 25 insertions(+), 22 deletions(-)

-- 
-- steve
