Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8B927442;
	Sun, 29 Mar 2026 03:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774754182; cv=none; b=GBhrhwFMps3j3xaR7Ib4pJrUPsruv3vJwbryeJEUiD/GboYWtTpwCum8w298ZSQIbT+Rc+7XfWOh5yxquhQASdP8KZctMIUYkQha0BhwuNTVsopCXac3PSOcZHOYE8RXxVoKdP5mlRW04dcdC7okbq4sN+wColBm9RKw4ipyBlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774754182; c=relaxed/simple;
	bh=kxI31Q6x/h6gFBTpOFUYOBNbqQwFfLhXRao4rZoUv40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S6DZZcpdZFF3h7DJJrYwGvbY0ZvpzEKk9KGmUpDU5p1SuaM62iRWXXujeCvpFoIDXmM0It0EnqmBgg4G4W2bWJhBjKPQkuMBnToRD6yZJxhOr1xvpbpKIxEhosRGAOeDLc0qS90JHYSEuW3SLEsZFKPZWrfw8/ZJDAfOlgVOo70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.197])
	by APP-01 (Coremail) with SMTP id qwCowABXAW37l8hppOd8Cw--.811S2;
	Sun, 29 Mar 2026 11:09:47 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: don.brace@microchip.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: elliott@hp.com,
	kevin.barnett@pmcs.com,
	JBottomley@Odin.com,
	thenzl@redhat.com,
	scott.teel@pmcs.com,
	hare@Suse.de,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pengpeng@iscas.ac.cn
Subject: [PATCH] scsi: hpsa: use bounded formatting for controller and IRQ names
Date: Sun, 29 Mar 2026 11:09:47 +0800
Message-ID: <20260329030947.32427-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABXAW37l8hppOd8Cw--.811S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCrWxCw1rJry3Jw43Cr47CFg_yoW5AFW7p3
	y3XFWagrs7Kr12g39Ivw1UZr4fC395Ja47Kr4Dtas7ZFn7uryYvF4rCry8XFZ7GrWxZr4Y
	kF45XFyUG3WUGrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r
	4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUL0edUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

hpsa stores the controller name in h->devname[8] and derives fixed
16-byte interrupt names from it with sprintf(). Once host_no reaches
four digits, h->devname no longer fits and the derived IRQ names then
build on top of that already overlong string.

Switch these name builders to scnprintf() so they stay inside the fixed buffers.

Fixes: 2946e82bdd76 ("hpsa: use scsi host_no as hpsa controller number")
Fixes: 8b47004a5512 ("hpsa: add interrupt number to /proc/interrupts interrupt name")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/hpsa.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1b116cd4723..479abb23c536 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8100,16 +8100,16 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 	if (h->intr_mode == PERF_MODE_INT && h->msix_vectors > 0) {
 		/* If performant mode and MSI-X, use multiple reply queues */
 		for (i = 0; i < h->msix_vectors; i++) {
-			sprintf(h->intrname[i], "%s-msix%d", h->devname, i);
+			scnprintf(h->intrname[i], sizeof(h->intrname[i]),
+				  "%s-msix%d", h->devname, i);
 			rc = request_irq(pci_irq_vector(h->pdev, i), msixhandler,
-					0, h->intrname[i],
-					&h->q[i]);
+					 0, h->intrname[i], &h->q[i]);
 			if (rc) {
 				int j;
 
 				dev_err(&h->pdev->dev,
 					"failed to get irq %d for %s\n",
-				       pci_irq_vector(h->pdev, i), h->devname);
+					pci_irq_vector(h->pdev, i), h->devname);
 				for (j = 0; j < i; j++) {
 					free_irq(pci_irq_vector(h->pdev, j), &h->q[j]);
 					h->q[j] = 0;
@@ -8122,19 +8122,19 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 	} else {
 		/* Use single reply pool */
 		if (h->msix_vectors > 0 || h->pdev->msi_enabled) {
-			sprintf(h->intrname[0], "%s-msi%s", h->devname,
-				h->msix_vectors ? "x" : "");
+			scnprintf(h->intrname[0], sizeof(h->intrname[0]),
+				  "%s-msi%s", h->devname,
+				  h->msix_vectors ? "x" : "");
 			rc = request_irq(pci_irq_vector(h->pdev, irq_vector),
-				msixhandler, 0,
-				h->intrname[0],
-				&h->q[h->intr_mode]);
+					 msixhandler, 0, h->intrname[0],
+					 &h->q[h->intr_mode]);
 		} else {
-			sprintf(h->intrname[h->intr_mode],
-				"%s-intx", h->devname);
+			scnprintf(h->intrname[h->intr_mode],
+				  sizeof(h->intrname[h->intr_mode]),
+				  "%s-intx", h->devname);
 			rc = request_irq(pci_irq_vector(h->pdev, irq_vector),
-				intxhandler, IRQF_SHARED,
-				h->intrname[0],
-				&h->q[h->intr_mode]);
+					 intxhandler, IRQF_SHARED,
+					 h->intrname[0], &h->q[h->intr_mode]);
 		}
 	}
 	if (rc) {
@@ -8715,7 +8715,8 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto clean2_5;	/* pci, lu, aer/h */
 
-	sprintf(h->devname, HPSA "%d", h->scsi_host->host_no);
+	scnprintf(h->devname, sizeof(h->devname), HPSA "%d",
+		  h->scsi_host->host_no);
 	h->ctlr = number_of_controllers;
 	number_of_controllers++;
 
-- 
2.50.1 (Apple Git-155)

