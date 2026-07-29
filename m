Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38B74C77CA;
	Wed, 29 Jul 2026 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336468; cv=none; b=mxF7VpVttZ912zjNmzWDOxo5UZxL1vxLmow8sGGvomGxGlZUqWyyB5yvOYRkUS24hIaTTYUOjus6KKaE6PgXyPs6lOhGrEUI5HzJ9xG1rEp2jQkh8Spse1NYkAYWykeUm6em3tL0SzCaHGZ2IhyDY/vIN2DByEbyuCyKAJ16iOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336468; c=relaxed/simple;
	bh=Fkev6iuT/8DE68Yn04zq7iUqHVQyawWSazRq4pQ/bSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jd73OfQ4zvT6dXXet+S7vM8VHbOvOlaSiiCNsqGJUUyMcl4tkRqBWec2O1HY5qEh9AKSv8CknCbqueY5DyBGfLxLL6lN6hu21pl5wWr87ynx0pvhmdNhLitssnfPEzU0TqEuLD0TPDhYbndMa0/RE2jCmy9dcow/+FVBw+1+uUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=bStDnGJ8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BsB/A5Gq; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="bStDnGJ8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BsB/A5Gq"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8F7F614000EA;
	Wed, 29 Jul 2026 10:47:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 29 Jul 2026 10:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1785336465; x=
	1785422865; bh=l5ar1LtJqeoFf+dKhr5b4RlPBhpC1YORct+Vno2KhiQ=; b=b
	StDnGJ8XdRE6c8xo48RJbqYvxDp8NustwSy1yl3FnonaYNBRzvbzwVbslmTorOmM
	gUpcIP9c9aK85vgGtTTkINkRNoy9KG0CiWbunxnGwFUC+oK5Whpbm22IPF5Xk6ee
	X1dZA1xp9SoW2znEGxF8r/8C25zFwtG8Y0xFI++L59H/YhU9Y3akwFmRcqttUGsa
	7GUMsA9StJ5VRAkcB6m5FKQUtqAgxhVLdvX5jUFP84zmVvtIdUuHUWZ1tgr4CKOP
	fjU+n5q8AcdMTUbLbZLi10JRimD+Pc4yCuMqPB5rjil/UQ0VDzTxmqtv48Xvh0C4
	IBn4Qe8PcWl3Caek+DPvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1785336465; x=1785422865; bh=l
	5ar1LtJqeoFf+dKhr5b4RlPBhpC1YORct+Vno2KhiQ=; b=BsB/A5GqXc7/wYcM+
	J4SP65vF+WCTko/i02ykC19t7d/PqN0DHlvpgx6mTU1SEIIU7zMGWVSqLx45pW3G
	D/YVfphk0Ta/IrA/aXxMJ1CcrQRZzjJTBdv2lupD1hiCh4pn2olDsfXoujfuHxkr
	Dbd3HlYKbXBATh50oRJKQXaiG38JKuswF7AIamvKrmP9T1uOeoFgi7qM12oLiDOO
	t7dUrfJOHCb+2XfOAUPPJ1vz0idBp0kvQ6NEyG4gor7DDBlydkXuB0OA2Lkf5PUV
	BjsOh74lmI3/nDUrtBBToveUwYjQ85QCiLZd7d5AXbMzNOrTnZ16HAO87mDjDwUs
	LPBOA==
X-ME-Sender: <xms:kRJqatjxldDrHeTk_5jyIHz9Rr1hny0uKdN3R2ys5e_X7bwZpG_Z3Q>
    <xme:kRJqaie_4dsD4unyH1Yk2SWgOzu1SiDrnzAnf0B-QTcNbrnZc0CcAb8StdSBoJP7m
    Ap4HpWxwWjvR2nunFPJRk-OoYSbIXJ6qtbNanFGWElzdC7iInMkVzmX>
X-ME-Received: <xmr:kRJqatxp1kNKtRuG0dKBK4jcp60ev4-hdxh-tytrzWb7xFju6J_WA1-Y4bI>
X-ME-Proxy-Cause: dmFkZTE5wi+MJyxorOdh+JrXF7qz5KRVreYk35RR2Kg6L8Et7FGxNH+4pMHnx93nafKHyg
    mv2tR7lAEbIoRz1AaZsSvvlPQKJK7bt33Sz3Aow9iVuGPdr4i9KQQtJnM4PD+2PoSaNouj
    65yuTZA7PqrcryfwhUlBNGkxFv/vYmJ+B8BoPCKGKAejbleK+5nBVPZAoNLs8FcOCFrg6A
    r5QKWS+pYvCbxGzqyJjj5ybN05UdgNV57Oa2ThEkCzTW9P9tRm25QrASBpOKsEs92hpXn1
    Vq7jFlXxxKOMHt692f9GUyIun7LeiMce8N6zKO3+Nmo5qUk0E5elX2yTQ8fFB7zbZyJnDP
    DbMhhT+lcGC4hDxVIupAWH4XT+KQa+fvMxxkitTK+et3d+tXwkdA4rb/iRE8w2D4l7nzwo
    ZbldagO5Ydep2ueXnsp7Y+LeZbqMui6UBbQwPRbAQSSrn6KG6zK/KmZAoHlSek4SvDwBoW
    ykjcdXFFsBD4tAPUC60dYCuvy3wavD8pBKleBLwMMTBqVtvZKkEB4lbcZgJOHT/ZMep803
    H0gDEQomO2y6xP0A3OER23OGidZK3qvxmcpXJoXdevah0q0EMVQ7WbxmgMm9o/+smKxjQM
    gaFixJIWwyXPgmDLBO7yKS6wKyQzZq1jHhRIFWuneT18Xa60kOO5mkX1KzYA
X-ME-Proxy: <xmx:kRJqap2hAlziI-KEX4k9ZlSCY6EJIQYLVzGXyMTicpvnFr2QmLtTag>
    <xmx:kRJqarwWtCDyRrAqcp67bItT8dQqroAUTTHLaI6tp1iHmvuKUeeh5Q>
    <xmx:kRJqamWX3-Y-RSdoMv9ogvEgLy8uIEDeLIEzj_XH-7z8ZTH6TJW73Q>
    <xmx:kRJqav8LcrLZ26-TOYnoJo5gfP4fiwzXwqmbHflDh2iqAU-34vgGhQ>
    <xmx:kRJqahpqg0QZRzhcXlWu2rdv41-KL47EdlL17tGJkyMMJQXv0rQ4MbCN>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 10:47:45 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH 1/5] scsi: lpfc: Replace strlcat() with seq_buf in lpfc_info()
Date: Wed, 29 Jul 2026 09:46:13 -0500
Message-ID: <20260729144617.1388646-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144617.1388646-1-icb@fastmail.org>
References: <20260729144617.1388646-1-icb@fastmail.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for removing the strlcat() API[1], replace its uses in
lpfc_info().

The function accumulates a variable number of optional fragments,
which is what seq_buf is for. The intermediate tmp buffer and the
per fragment overflow checks become unnecessary. seq_buf is memory
safe by construction and silently truncates in the same way as the
replaced pattern.

The old code passed phba->ModelDesc as the format string of the first
scnprintf() call. The model description comes from adapter VPD data.
seq_buf_printf() takes a format string, so the replacement prints it
through "%s". A model description containing conversion specifiers is
no longer interpreted.

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
A model description that contains percent characters is now emitted
literally. The old code interpreted it as a format string, which is
undefined behavior for any conversion that consumes an argument. The
differential harness confirmed byte identical output for 200000
randomized percent-free model strings across all fragment
combinations, and demonstrated the old interpretation with a directed
"%%" input. The KUnit corpus confirmed the same as compiled kernel
code.

Once the seq_buf overflows, later appends write nothing, so removing
the early exits does not change the produced bytes. The harness
confirmed identical output over the full field ranges.

 drivers/scsi/lpfc/lpfc_scsi.c | 49 +++++++++++------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f2cab134af7f..8a795c65e3c3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -21,6 +21,7 @@
  * included with this package.                                     *
  *******************************************************************/
 #include <linux/pci.h>
+#include <linux/seq_buf.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/export.h>
@@ -5103,57 +5104,37 @@ lpfc_info(struct Scsi_Host *host)
 	struct lpfc_hba   *phba = vport->phba;
 	int link_speed = 0;
 	static char lpfcinfobuf[384];
-	char tmp[384] = {0};
+	struct seq_buf s;
 
 	memset(lpfcinfobuf, 0, sizeof(lpfcinfobuf));
+	seq_buf_init(&s, lpfcinfobuf, sizeof(lpfcinfobuf));
 	if (phba && phba->pcidev){
 		/* Model Description */
-		scnprintf(tmp, sizeof(tmp), phba->ModelDesc);
-		if (strlcat(lpfcinfobuf, tmp, sizeof(lpfcinfobuf)) >=
-		    sizeof(lpfcinfobuf))
-			goto buffer_done;
+		seq_buf_printf(&s, "%s", phba->ModelDesc);
 
 		/* PCI Info */
-		scnprintf(tmp, sizeof(tmp),
-			  " on PCI bus %02x device %02x irq %d",
-			  phba->pcidev->bus->number, phba->pcidev->devfn,
-			  phba->pcidev->irq);
-		if (strlcat(lpfcinfobuf, tmp, sizeof(lpfcinfobuf)) >=
-		    sizeof(lpfcinfobuf))
-			goto buffer_done;
+		seq_buf_printf(&s, " on PCI bus %02x device %02x irq %d",
+			       phba->pcidev->bus->number, phba->pcidev->devfn,
+			       phba->pcidev->irq);
 
 		/* Port Number */
-		if (phba->Port[0]) {
-			scnprintf(tmp, sizeof(tmp), " port %s", phba->Port);
-			if (strlcat(lpfcinfobuf, tmp, sizeof(lpfcinfobuf)) >=
-			    sizeof(lpfcinfobuf))
-				goto buffer_done;
-		}
+		if (phba->Port[0])
+			seq_buf_printf(&s, " port %s", phba->Port);
 
 		/* Link Speed */
 		link_speed = lpfc_sli_port_speed_get(phba);
-		if (link_speed != 0) {
-			scnprintf(tmp, sizeof(tmp),
-				  " Logical Link Speed: %d Mbps", link_speed);
-			if (strlcat(lpfcinfobuf, tmp, sizeof(lpfcinfobuf)) >=
-			    sizeof(lpfcinfobuf))
-				goto buffer_done;
-		}
+		if (link_speed != 0)
+			seq_buf_printf(&s, " Logical Link Speed: %d Mbps",
+				       link_speed);
 
 		/* Support for BSG ioctls */
-		scnprintf(tmp, sizeof(tmp), " BSG");
-		if (strlcat(lpfcinfobuf, tmp, sizeof(lpfcinfobuf)) >=
-		    sizeof(lpfcinfobuf))
-			goto buffer_done;
+		seq_buf_printf(&s, " BSG");
 
 		/* PCI resettable */
-		if (!lpfc_check_pci_resettable(phba)) {
-			scnprintf(tmp, sizeof(tmp), " PCI resettable");
-			strlcat(lpfcinfobuf, tmp, sizeof(lpfcinfobuf));
-		}
+		if (!lpfc_check_pci_resettable(phba))
+			seq_buf_printf(&s, " PCI resettable");
 	}
 
-buffer_done:
 	return lpfcinfobuf;
 }
 
-- 
2.47.3

