Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F91381AA;
	Wed, 10 Jul 2024 03:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720581901; cv=none; b=QmsSUVmTJkDhQaWgaVIYMfu2x/NeeGBHUfKmTNXRaX9Uo6kdQPf8kj2IwflxPxCVctR28kQduJ2S1hYtxCR+FXDXaUtQS8gzD3C9od2gtl9EkMPCfj7Or1M75uai3NcqnnCBVOX1R38xwLW7YevOv2AfC6hSZJEPDqcXIBWYtok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720581901; c=relaxed/simple;
	bh=QHegp8DOcSh8eZnGx+hO408fB/5GYkziaSmH3ahHvh8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JaM8es26FChfjvdR5dqvKHMt7DX75bGIB3A8nzdErHk+AJVpbzeja1HB3PF8eYuBxbqh1svjjCtbluJNP3F8+2qTtwEYYXZ8RfZTjBdCwFLkjQhrsHR6zqI3yI/4/mZ/q2/AICABGJJIhZZwSdDpB6IS8rK7UEd52ZZN8ZUTJF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowAAXHNQB_41mtPL3FA--.46778S2;
	Wed, 10 Jul 2024 11:24:49 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] scsi: qla2xxx: Convert comma to semicolon
Date: Wed, 10 Jul 2024 11:24:23 +0800
Message-Id: <20240710032423.2003805-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAXHNQB_41mtPL3FA--.46778S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4UZF15Zr47GrWUXw4ruFg_yoWfJrc_uF
	s0qrWIqrn0krnruw1xXrW3Zay2vFWvqr1ku3WYvry5uayUX347XF1YqFW3Xa13trWIyFW5
	Cw4UXrWjyF1rujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
	GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBMKZUUUUU=
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace a comma between expression statements by a semicolon.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8377624d76c9..e2ca9a14b643 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -423,7 +423,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	sp->type = SRB_LOGOUT_CMD;
 	sp->name = "logout";
 	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
-			      qla2x00_async_logout_sp_done),
+			      qla2x00_async_logout_sp_done);
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
 	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC explicit %d.\n",
-- 
2.25.1

