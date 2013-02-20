From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/5] hpsa: Add error handling checks to DMA mapping operations
Date: Wed, 20 Feb 2013 11:24:27 -0600
Message-ID: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:42512 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3BTQYd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2013 11:24:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, shuah.khan@hp.com, mikem@beardog.cce.hp.com

The following series adds error handling checks for dma mapping
operations to the hpsa driver.

---

Shuah Khan (1):
      hpsa: Check for dma_mapping_error in hpsa_map_one

Stephen M. Cameron (4):
      hpsa: Check for dma_mapping_error for all code paths using fill_cmd
      hpsa: check for dma_mapping_error in hpsa_map_sg_chain_block
      hpsa: reorganize error handling in hpsa_passthru_ioctl
      hpsa: check for dma_mapping_error in hpsa_passthru ioctls


 drivers/scsi/hpsa.c |  117 +++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 84 insertions(+), 33 deletions(-)

--
-- steve 

