From: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
Subject: [PATCH] bug fix for 42142
Date: Tue, 13 Mar 2012 11:59:27 -0700
Message-ID: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
List-Id: linux-scsi@vger.kernel.org

Minor change to weed out the intended loginfo messages.

Sathisha Nanjappa (1):
  mpt2sas: Corrected the constant in comparison to a hexadecimal.

 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
1.7.7.6
