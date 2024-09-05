Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5117D1FDA;
	Thu,  5 Sep 2024 02:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725503754; cv=none; b=C/vKEzbVih685VGGgPaGv70Xvkk0Ls6eX5OnxvrDmK8lWj/RoK+998vbX8+/9HNs8qDcP+TlpZ2OggdjQZPDlH9B9VtXFQhaB6yOMdz2n2Eh+d3LPPtIr9ZCaaCtveMYBfXyXlMAa1KzFUkZaftkqpzKLIC3yJDqP/T2xKzMMcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725503754; c=relaxed/simple;
	bh=JtgM5zR8Dpo0Gd3F3WSNXLiQwiL+8n7eU4oMY0eh77g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BLonokGjmxR5UZx2qePbkEG7YmxycMSGGcjP866hANXgeNQgsZdzOhBVQkT3DS9IWdyGfx80yf4hk4FDGsNWFw+S8DaZtEFDw+zZSkrHCw/rjuoB9oVR+no3gOq5SOIIvBQUbGbzUo5xCUdK/91NAH8YrcPX87/2axbO9ctgaIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowADnzSAEGdlmLilaAQ--.10052S2;
	Thu, 05 Sep 2024 10:35:48 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] scsi: pmcraid: Convert comma to semicolon
Date: Thu,  5 Sep 2024 10:35:21 +0800
Message-Id: <20240905023521.1642862-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADnzSAEGdlmLilaAQ--.10052S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4rCw4kuw4kuw1xGrW3ZFb_yoWDCrbEgr
	1jq347AF1jq343KF15uw47Zr90gF1qvF4I9r42qay3A3y7XrZ8W3ZYvrs8Aw1fWr45Kry5
	C3s0qFnI9wn3ujkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS
	14v26r126r1DMxkIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUqfO7UUUUU=
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace comma between expressions with semicolons.

Using a ',' in place of a ';' can have unintended side effects.
Although that is not the case here, it is seems best to use ';'
unless ',' is intended.

Found by inspection.
No functional change intended.
Compile tested only.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index a2a084c8075e..8f7307c4d876 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -1946,7 +1946,7 @@ static void pmcraid_soft_reset(struct pmcraid_cmd *cmd)
 	}
 
 	iowrite32(doorbell, pinstance->int_regs.host_ioa_interrupt_reg);
-	ioread32(pinstance->int_regs.host_ioa_interrupt_reg),
+	ioread32(pinstance->int_regs.host_ioa_interrupt_reg);
 	int_reg = ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
 
 	pmcraid_info("Waiting for IOA to become operational %x:%x\n",
-- 
2.25.1

