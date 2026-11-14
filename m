Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794620688;
	b=OHmQXQLZeYE1HHe3IxyzO7o78qyFt2tsjkUWSTMDHqzQ+4lqIdjwPSJzhnJzXTFMjY5t
	 VkPxUWz3UcsoI+AiMyUseJ1i9EPRkzZR7xd5c+J4/n15MvJNYB/tjAaMexn6pjXDvfMWD
	 9r4lyH0ZmYTGByTrOJoLW8Tj13LGo32v3Ya9uAOpIq5YDysKrmR4zazZUFVDSb4cym7Og
	 hb9+k3XkBOiOoPVPwgmj/BaX1QSzkCTBDrjCr+pKBHU3xLrmXMU5yQ2yi1be61jxeOG6Y
	 oZqDtRJOzjGt6cM5tM34r5gVJR/Cs1hgklzAy4sDpk+G0cc3mBVEqAUlJUV9xFumvjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794620688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oumOngWxVgBoBiHIJuwnUG306tH6QPa5rXLuw+ECr+g=;
	b=zi3Vkm2FQQejDgv/NUj4PcsEGa9mNJz6WzMvcy+g0EbbQcoEIACICYEXbYTgLDPjPACC
	 s6++Nm1M6fV+poEyd17H1B40ljxXwupnBMnisyvTsFW+Qw6dvp1VjE8cK83sAb9GwMY0V
	 /wf/bpl5a2bOJhb4tKo3uQ4uXJanGDBfvCbH0VijbtA7cgbOM8xmN3vEu4fujoDrVJLGf
	 hOP37vZW6qQh9CCxv4ep1SULm8/rZCPAH/yNNeXe2PzQZc0zx8Gzi9xCJCZth1ajYzC6E
	 rdt1inu6PMc1vqQK26OTPhk6FtMh1gqO49WQ9AzBsbGVU76JTU234L8sti7gsy+qcbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GGxSMtes;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F70B606A8B7
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 01:44:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F70B606A8B7
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GGxSMtes
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso1658510a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 17:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794620687; x=1795225487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oumOngWxVgBoBiHIJuwnUG306tH6QPa5rXLuw+ECr+g=;
        b=GGxSMtesc98XoZ9u7OkTqZEZly+so/0/Bz6PxsMPUVP43goefc/+fAvaRYRBysrYUD
         Nmupop2JBvwXsRVcfnEWbMABNdZKxhDvY6kRH9RgVqYAuoBxXizXiFIo0IbWgKlrBISR
         4ozNIbyL0qzylDmDq04TVtfHxk4rpTb0E/Mtfl05EeY8B0gxOf/oVeG/Bb7HalXWuI9I
         Ge+QJakROLn2W9plLoJzEw7pyxVAGo/kA0BjlQ41axay5V6/am0uSiOX3dPdxLrLYTl+
         IRzjsRGgjkdzYRi2i5XK6sT5S5yYoznKCG3B7h9hAIUCXyGyNAjR2mEgUzzqkiMAs/Ir
         hBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794620687; x=1795225487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oumOngWxVgBoBiHIJuwnUG306tH6QPa5rXLuw+ECr+g=;
        b=QBcB8CkLfzvdLdjIuKgm8vKDudz9Da+BNTbU22YGJKtcPsqqqznAoRQhWUXVplEpWe
         QGqSQOSPztkZs8S65J3QcpicK7l+ZXjwx4QNfEaLFyCt7Mx3yv8dsJi4f6gvBfriqXVX
         3G8Ul+53jbBMdrqKjnNqfZEJad2D6NvAwoF9/5awODeo1pbrG6ZW31c0fAvlu/6hKGvz
         nKD7kAoM+ELBTquKVldjs+cpBcXEWsYF9s6ZPa8IWFv3SEWq3oVob+IVppFSgyCENXWD
         +rpY+4bhpTzvafsUdyAWZTwZ0NTeoX+WB0mxqXH8Tt7lTveKdcTCVNSaGERnrLVbQvCH
         Lzdw==
X-Gm-Message-State: APuU4Z8Sr2NCaeWj+shEnfoRN6WI9RJ3Uq/yllGkZKYw3c3Ht6lOLrV/
	HHGhTMp37dUB4SScVX0yGgNA4xpx5pa5Oe0MTJ3jFMwbt2jmZJFVa8eXh7n2Dc8K5JI=
X-Gm-Gg: AYBFou0HY7ICWUrlJVVnGo5veRa1ucXbDwau1butiIK/tqbVvgKX8czVn/NyoKPUnGP
	O3gQRRq40ehPcM14WXV1JoBgbpX/mP7lYjd/T4rzcGrfXmx8eN63AmryvFmhL3CBXnXK63ERfxs
	0mdYj+gBd3x7kS6SII8FLdkTTPhe3eEsQl4fUgcZlk7x1/zlOSKSs3uyYH9z6+EX8kNKk/naXK+
	3cgBOaF+qC0dFfnS+9+m82ga7F7EtziiSVWtYNiwT0cJsFBgKtTm4fwKZ9iDYRROteJcppEuhJx
	3NbZ17GOy9bjOn25ut+lJozKjXixUEe80oK85k7g2f4T4vk/xZjlfZkKlSBBDtPrq+CIBUtHbsi
	kk0lbe93xX6xuFzeIgcuQ0hmEOqA2p8mhzrY4PnaW26P9oLxlrCi0tUwv/SIsbPY7EYY69IL3AH
	0j6lbtB4fskkS99By3ovU0jicCspXSp+dLvpT1o0ncK3veyNfnSNrJ+NHgv7dHjp83sz/k/Uw3V
	MeSx7DPe9tHFjPzYfyD+Evk8gK//c/tYBjkKon3r7Mstn1uyIWDRYZ5KTYEBje6bsW4vEizlxaT
	/AK5ha6/Sdg1p9KHtnCOzmjP3BRnyOxkfjKLPNjztU3UtOfQNet0RZ+ORPMhcuHy7jri18PwKIr
	yQssVxgcgdR7Fbk00wbLp1tKfaIgZ9Tb5pTscfg==
X-Received: by 2002:a17:90b:1b02:b0:3a4:b509:88bd with SMTP id 98e67ed59e1d1-3b1b087c16emr2674713a91.2.1794620686603;
        Fri, 13 Nov 2026 17:44:46 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm3437082a91.0.2026.11.13.17.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 17:44:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: mvumi: quarantine a timed-out internal command's buffers
Date: Sat, 14 Nov 2026 10:44:30 +0900
Message-ID: <20261114014430.489668-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
References: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_issue_blocked_cmd() waits 45 seconds for an internal command and,
if it has not completed, tidies up its own bookkeeping and returns 0, the
same value as success.  It writes nothing to the controller, so there is
no abort; the SCSI error handler is not involved either, because an
internal command has scmd == NULL.

The callers - mvumi_flush_cache(), mvumi_inquiry() and mvumi_get_event()
- cannot tell, and each goes on to mvumi_delete_internal_cmd(), which
frees the command frame and the data buffer.  The controller still has
both addresses: the frame as the source of a dynamic list entry on an
adapter with HS_CAPABILITY_SUPPORT_DYN_SRC, and the data buffer as the
target of the data-in transfer the frame's SGL describes.  One that
answers late writes into memory handed back to the page allocator.

Put both buffers on mhba->res_list instead.  The address and length are
taken where mvumi_delete_internal_cmd() takes them today, so nothing new
is trusted; mvumi_release_mem_resource() frees the list at unload, which
the preceding patch makes run after pci_disable_device().  The mark
cannot come from cmd_status, which is assigned from ob_frame->req_status
and can be left at REQ_STATUS_PENDING (0x80) by the controller.  The cost
is the frame and data buffer of each timed-out command, held until unload.

A KUnit test that writes to the buffers after the timeout, standing in
for the controller, gets a KASAN use-after-free in 5 of 5 runs without
this patch and none in 5 with it.  I have no mvumi hardware.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
The faulting function below is the test, which performs the late write the
controller would make.

  ==================================================================
  BUG: KASAN: use-after-free in mvt_timeout_write+0x5f8/0x730
  Write of size 1 at addr ffff8880097b6000 by task kunit_try_catch/71

  CPU: 1 UID: 0 PID: 71 Comm: kunit_try_catch Tainted: G                 N  7.4.0-rc2-00563-g97d73c825122-dirty #2 PREEMPT(lazy) 
  Tainted: [N]=TEST
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? mvt_timeout_write+0x5f8/0x730
   kasan_report+0xe5/0x120
   ? mvt_timeout_write+0x5f8/0x730
   mvt_timeout_write+0x5f8/0x730
   ? __pfx_mvt_timeout_write+0x10/0x10
   ? __set_cpus_allowed_ptr+0x178/0x230
   ? __pfx___set_cpus_allowed_ptr+0x10/0x10
   kunit_try_run_case+0x1ad/0x490
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? kthread_affine_node+0x15f/0x1e0
   ? __pfx_kthread_affine_node+0x10/0x10
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x2c8/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0xac3/0xdc0
   ? __switch_to_asm+0x33/0x70
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  The buggy address belongs to the physical page:
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x97b6
  flags: 0x100000000000000(node=0|zone=1)
  raw: 0100000000000000 ffffea000025edc8 ffffea000025ed48 0000000000000000
  raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffff8880097b5f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
   ffff8880097b5f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  >ffff8880097b6000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                     ^
   ffff8880097b6080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
   ffff8880097b6100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ==================================================================

A late completion is already dropped: the timeout path clears tag_cmd[], and
both mvumi_receive_ob_list_entry() and mvumi_check_ob_frame() refuse a
response frame whose tag has no command.

The same kind of exposure remains for a normal SCSI command.
mvumi_timed_out() unmaps the scatterlist and returns the command without
stopping the device either, and this series does not address that.

mvumi_detach_one() does not flush the event work, so an event command
still running at unload is a separate, pre-existing problem.

 drivers/scsi/mvumi.c | 40 ++++++++++++++++++++++++++++++++++++----
 drivers/scsi/mvumi.h |  1 +
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 8d22d370d8608f..dbbfa1cbae0086 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -177,6 +177,29 @@ static void mvumi_release_mem_resource(struct mvumi_hba *mhba)
 	mhba->fw_flag &= ~MVUMI_FW_ALLOC;
 }
 
+/* The controller may still DMA here; free it once the device is disabled. */
+static void mvumi_quarantine_buf(struct mvumi_hba *mhba, void *virt_addr,
+				 dma_addr_t bus_addr, unsigned int size)
+{
+	struct mvumi_res *res = kzalloc_obj(*res);
+	unsigned long flags;
+
+	if (!res) {
+		dev_err(&mhba->pdev->dev,
+			"leaking %u bytes the controller may still write to\n",
+			size);
+		return;
+	}
+	res->type = RESOURCE_UNCACHED_MEMORY;
+	res->virt_addr = virt_addr;
+	res->bus_addr = bus_addr;
+	res->size = size;
+	INIT_LIST_HEAD(&res->entry);
+	spin_lock_irqsave(&mhba->shost->host_lock, flags);
+	list_add_tail(&res->entry, &mhba->res_list);
+	spin_unlock_irqrestore(&mhba->shost->host_lock, flags);
+}
+
 /**
  * mvumi_make_sgl -	Prepares  SGL
  * @mhba:		Adapter soft state
@@ -298,11 +321,19 @@ static void mvumi_delete_internal_cmd(struct mvumi_hba *mhba,
 			phy_addr = (dma_addr_t) m_sg->baseaddr_l |
 				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
 
-			dma_free_coherent(&mhba->pdev->dev, size, cmd->data_buf,
-								phy_addr);
+			if (cmd->timed_out)
+				mvumi_quarantine_buf(mhba, cmd->data_buf,
+						     phy_addr, size);
+			else
+				dma_free_coherent(&mhba->pdev->dev, size,
+						  cmd->data_buf, phy_addr);
 		}
-		dma_free_coherent(&mhba->pdev->dev, mhba->ib_max_size,
-				cmd->frame, cmd->frame_phys);
+		if (cmd->timed_out)
+			mvumi_quarantine_buf(mhba, cmd->frame, cmd->frame_phys,
+					     mhba->ib_max_size);
+		else
+			dma_free_coherent(&mhba->pdev->dev, mhba->ib_max_size,
+					  cmd->frame, cmd->frame_phys);
 		kfree(cmd);
 	}
 }
@@ -734,6 +765,7 @@ static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
 	if (atomic_read(&cmd->sync_cmd)) {
 		spin_lock_irqsave(&mhba->shost->host_lock, flags);
 		atomic_dec(&cmd->sync_cmd);
+		cmd->timed_out = 1;
 		if (mhba->tag_cmd[cmd->frame->tag]) {
 			mhba->tag_cmd[cmd->frame->tag] = NULL;
 			dev_warn(&mhba->pdev->dev, "TIMEOUT:release tag [%d]\n",
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index 1306a4abf19ad2..e248dfc1dd1bb7 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -252,6 +252,7 @@ struct mvumi_cmd {
 	void *data_buf;
 	unsigned short request_id;
 	unsigned char cmd_status;
+	unsigned char timed_out;
 };
 
 struct mvumi_cmd_priv {
-- 
2.43.0

