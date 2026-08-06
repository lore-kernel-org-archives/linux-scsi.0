Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F67338D3F2;
	Thu,  6 Aug 2026 20:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786047833; cv=pass; b=Qhom5iBV1il71WnDxZ4+NmvapGY3pq7bdeA/w6G91ZLY5TN9DpHTltg0xmlw5o0l/t3oYq7V6clyuGCaWSW92ofDwRaT/MB1A0NRMXF1ZF5nHh8UFdObsKuX064vbNoTPFXFT7do2k3mOxskYy0Y/FMs4wAJsU8xI0hyZ01niEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786047833; c=relaxed/simple;
	bh=wnKu+FgPijdgZ7wQCNpgJJnUvujcvv4NLraMqraCZiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDqNNTir1IlBC/Ywr6dxb2APTLdi9hXUXwpIxbJDcJ8XJ8be+7yEe0Ga0itrHbaCCqqJJ+lbyBJ3JOdRb6dVluy4UwMeLmCqZND2w+fgA8xJ2ZDCESY/EJtC7OPyxQX9gskVE96K3qFk1c11mTQx5GJCKqCwV7OOnxTBW5HO0t0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=CrgAgF6F; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="CrgAgF6F"
ARC-Seal: i=1; a=rsa-sha256; t=1786047818; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=JptTWq7RgETPc8dpG9kGmYzrUTEH+9boJUoQKHiMAb7m82YjZGb0vLCLEhAFyUy0uosP+tKuZYw1Tv/kKr8cHTBLzX6u8qTMpbIBfI/LhKhe+6FgjrYpUfO+jIlHW2+ng9LdyTL/4Y36imjptfWwC8j9y+AOgdWq+7wiDwG8saw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786047818; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rIxsQTrJGRlSuvbcERHIP5fAC7xK052RKLG0Z9nVQa0=; 
	b=hAWKSc7MJqWSwTvvXa0gEPoM4WSEvz1+qC9FXVfT73I2Y+lyCA6wqJQGmoM4KXsKQCcwvLhh+JzjudwBS/PRubn73HvacK5oX0QHUxhC8diccd5MepgcmNSX4unDQCHlfa1lvhSbvdYZIQWtk/WxDlF8R1OGGg/ISbDOJgBiGgY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786047818;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rIxsQTrJGRlSuvbcERHIP5fAC7xK052RKLG0Z9nVQa0=;
	b=CrgAgF6FqOVG+cb/rUCvk/iu7kjwZvGSO8aXCHsY8+DHPqvOv7hx+2nnsJbdpyAq
	u1vJNhDMPzpSjGhWzh9Nn4HnCbrNCk5AL7u1AxR+mO8vD/iSEtmUlalpg9ki/0v45R5
	X0ifeh0GQTJ1xFzCH+zyP9OPg/vVNMuwdSK43vS4=
Received: by mx.zoho.eu with SMTPS id 1786047816776585.1538283020542;
	Thu, 6 Aug 2026 22:23:36 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] scsi: elx: efct: free the HIO when the WQE cannot be built
Date: Thu,  6 Aug 2026 20:22:02 +0000
Message-ID: <20260806202205.345326-3-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806192345.328621-1-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

efct_els_hw_srrs_send() and efct_hw_bls_send() allocate an HIO, ask sli4
to build a WQE into it, and give up when that fails without putting the
HIO back:

	if (sli_els_request64_wqe(&hw->sli, hio->wqe.wqebuf, hio->sgl,
				  &els_params)) {
		efc_log_err(hw->os, "REQ WQE error\n");
		rc = -EIO;
	}

Nothing has been submitted at that point, so no completion will arrive to
release it, and the entry sits on hw->io_inuse until the adapter is torn
down. Each failure costs the pool one entry, and once it is empty
efct_hw_io_alloc() fails and no further ELS, CT or BLS frame can be sent.

Release the HIO on those paths. The efct_hw_wq_write() failure below is
deliberately left alone: it can return an error while this request is
still queued on wq->pending_list, so the HIO cannot be handed back there
without more care.

Fixes: dd53d333aadb ("scsi: elx: efct: Hardware I/O submission routines")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 38 ++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 15c37ff1d52e..6cc48fa3e656 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2609,6 +2609,7 @@ efct_hw_bls_send(struct efct *efct, u32 type, struct sli_bls_params *bls_params,
 	if (sli_xmit_bls_rsp64_wqe(&hw->sli, hio->wqe.wqebuf,
 				   &bls, bls_params)) {
 		efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE error\n");
+		efct_hw_io_free(hw, hio);
 		return -EIO;
 	}
 
@@ -2820,24 +2821,27 @@ efct_els_hw_srrs_send(struct efc *efc, struct efc_disc_io *io)
 		rc = -EIO;
 	}
 
-	if (rc == 0) {
-		hio->xbusy = true;
+	if (rc) {
+		efct_hw_io_free(hw, hio);
+		return rc;
+	}
 
-		/*
-		 * Add IO to active io wqe list before submitting, in case the
-		 * wcqe processing preempts this thread.
-		 */
-		hio->wq->use_count++;
-		rc = efct_hw_wq_write(hio->wq, &hio->wqe);
-		if (rc >= 0) {
-			/* non-negative return is success */
-			rc = 0;
-		} else {
-			/* failed to write wqe, remove from active wqe list */
-			efc_log_err(hw->os,
-				    "sli_queue_write failed: %d\n", rc);
-			hio->xbusy = false;
-		}
+	hio->xbusy = true;
+
+	/*
+	 * Add IO to active io wqe list before submitting, in case the
+	 * wcqe processing preempts this thread.
+	 */
+	hio->wq->use_count++;
+	rc = efct_hw_wq_write(hio->wq, &hio->wqe);
+	if (rc >= 0) {
+		/* non-negative return is success */
+		rc = 0;
+	} else {
+		/* failed to write wqe, remove from active wqe list */
+		efc_log_err(hw->os,
+			    "sli_queue_write failed: %d\n", rc);
+		hio->xbusy = false;
 	}
 
 	return rc;
-- 
2.55.0

