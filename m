From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/2] hpsa: fix a couple of minor bugs
Date: Fri, 03 Jun 2011 09:57:24 -0500
Message-ID: <20110603145639.17254.54228.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

The following series fixes a couple of minor bugs in the hpsa driver. 

---

Stephen M. Cameron (2):
      hpsa: fix dma unmap error in hpsa_passthru_ioctl
      hpsa: fix potential overrun while memcpy'ing sense data

-- 
-- steve
