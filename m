Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18B04DB568;
	Wed, 29 Jul 2026 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336476; cv=none; b=ueFCFpNDz21nMq4pICkHv1PrkhC7DmrHrS9UQ23QEBsFisY05d4iNjxFgxW/eB7VlpNNFdHs4tRi0PTuAa+Mm9uxI+r7cilPkPq4NLrWsWHPAXFaQCRPU5osSDwI+bWeExmlqIXRMFvQKbDkWV37NePjiBGapISLzry9fGbk090=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336476; c=relaxed/simple;
	bh=IztdwbAqSfJrw1l7R7vADaXupnyD7+E9ndpd+O5po7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xel36yLlMUweBVBqfDEjQYKGOLo8giIEMHhgeDQghnWeh4GlhtuNM+rdhLhZ77efpLygoYQByVd8DPBw7njEIfqJe8fXZ6h5BjBkpMtnrQt6uy8DBPWI/p1UuHOS3x1xVZxN+gL6R3tfBh9XwMILWMcFC01Ifferv089sxeM8Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=V62xRXwE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BRzPrtRR; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="V62xRXwE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BRzPrtRR"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CBDE914002DF;
	Wed, 29 Jul 2026 10:47:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 29 Jul 2026 10:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1785336473; x=
	1785422873; bh=PuCtJ6uadRt2xhx5TxmYnk+vs/s1wEZBBQadjqZ+ZxE=; b=V
	62xRXwENa0K12zr4L9eWMFhXsq03k1RxUzk2NI4pte3vGucDgl+QLSQkkWjoXgLR
	j8dsia3MlxBKsWmSzx3qfs1y9BU/PPiQVPpswQgtb7vw2vLsP1HHM3fYHOBf9jrE
	5RzzQ8YDzRr0QecXwSSv1IJuR8V6YXYVQTkO7ktETnDq+EHO01eG3utvE8GMtj/k
	hjT7n/dkCTEiHRDWOLZakHjh19FlEn5x/NNVDCsyIzMdKsmt77s6oT1+aL5jTynT
	I942Pg2HCW7t4Z01xVPdbOYX/uBemD99uZDp0/MaLVlkN3A9Y7koqTON2cv6w5EF
	+R9iCDxj4FoQMyymPF0Jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1785336473; x=1785422873; bh=P
	uCtJ6uadRt2xhx5TxmYnk+vs/s1wEZBBQadjqZ+ZxE=; b=BRzPrtRRBDeMrqQRt
	cosq9yTj//lLoqhvYVA3ycP2JXLdyFduwj6PQHk+a8YzmynbXfJVRyvOgMeSJtNW
	VOP7/r2VWf1j6Ej+VhWQYrTvgxskf/TdLuCBrW4KKq0Q22OvcdLJGDsE/pxhZto9
	gnZ88vahdKrvZ8IznOGLKotA7W4x5fZSPf2Z7p7fKo0XjnvR5TK0oACzHxhLC8mO
	JLaaxecO/DZiWoCNMZEb4Tv+/MO+CMQ7O/2oCQyuox+flNxbpYLCpxH3nlmraNkX
	ErQ+muzUcPAkutbgWVpmnbeqPZWk0scGoyzPOwE/kSrzj0aNX3gWq7fQ2ZA6H87f
	ZAboQ==
X-ME-Sender: <xms:mRJqahH9BcUsSp7Dp-QpHASG5-AJNVffxCbXdJ1o2jrjQmawJ8O0Sw>
    <xme:mRJqamy8N2A9SW4ktGtJb4eVk_w65VcpzoWH6SQZvVARdVC8u9yjb1eleMS-hs66b
    0X_aOBA71v_WZZfYQcSw7AzcnABUkvRBQnQf4Q2JIcW3qxkvFK1NTSV>
X-ME-Received: <xmr:mRJqaj0-my9af97iABolrxC9aZmnU4VnStMKB-fKfFjdA1-Wfe7inE6m42s>
X-ME-Proxy-Cause: dmFkZTE5wi+MJyxorOdh+JrXF7qz5KRVreYk35RR2Kg6L8Et7FGxNH+4pMHnx93nafKHyg
    mv2tR7lAEbIoRz1AaZsSvvlPQKJK7bt33Sz3Aow9iVuGPdr4i9KQQtJnM4PD+2PoSaNouj
    65yuTZA7PqrcryfwhUlBNGkxFv/vYmJ+B8BoPCKGKAejbleK+5nBVPZAoNLs8FcOCFrg6A
    r5QKWS+pYvCbxGzqyJjj5ybN05UdgNV57Oa2ThEkCzTW9P9tRm25QrASBpOKsEs92hpXn1
    Vq7jFlXxxKOMHt692f9GUyIun7LeiMce8N6zKO3+Nmo5qUk0E5elX2yTQ8fFB7zbZyJnH3
    A6+Bw0ie1heUIo645MDGLfKG7cNHx8ijg9Q/Bm0O3GJnyLLol5QCMyl6EU6+r/ZQ0kS0yi
    OMLcPDZYCP6ajwyLhqamcPUxYidLGmoMjEyZLS+bJBiKiyvw+2ym44Tm4sAwMqHh5/G7Xq
    g9skxhSE8RyLBsY8QUcU92mSJdmMFJwxCQB0R0dPzeyGsV6ZzIYNluqFfkNKG/kd6/1fgH
    5rNpGK29Pd1XKYEw4Jqiu/zI6ayj1cOVglpq3WfF+i8rd1qQOSkOM8ddiFSrAIAz7vJUp3
    HhomLb2/YAAf+cKLqLLZ8DZBzVarfKmerl9iCBBiINjWEYe8B0oWZhDyXq/Q
X-ME-Proxy: <xmx:mRJqauo0DH3P-eNbgvVocFTjhh1T31lFhuCwpFzvzy_v32fTN6RZiA>
    <xmx:mRJqaoX8Gl10iuolFtd2TA1e-T30L7ML1sWKyW54FQUuk-BvtD4Ekw>
    <xmx:mRJqavoDbjTmrI0oenQl8tTc5ImV2HiIyM0zoWaciiw-rpEdQ5a-7A>
    <xmx:mRJqanAlAP0_E0aHXMJKjL_34r__MXqGzSxtSXsMFnDKflpZrzQDbQ>
    <xmx:mRJqamcnS9ug29g4z3y3L3wbqchmu_u5aL2KAZlj4aiy41mmVt5Jshx0>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 10:47:53 -0400 (EDT)
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
Subject: [PATCH 2/5] scsi: lpfc: Replace strlcat() with scnprintf() in lpfc_vport_symbolic_node_name()
Date: Wed, 29 Jul 2026 09:46:14 -0500
Message-ID: <20260729144617.1388646-3-icb@fastmail.org>
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
lpfc_vport_symbolic_node_name().

The function builds five unconditional fragments, so one scnprintf()
call composes the whole string. The intermediate tmp buffer and the
per fragment overflow checks become unnecessary. scnprintf()
truncates at the buffer size and returns the number of bytes it
wrote, which equals the length that the removed strnlen() call
computed.

The old code capped every fragment at MAXHOSTNAMELEN bytes before
appending it, independently of the room left in the destination. The
replacement formats each fragment directly into the destination, so a
fragment longer than MAXHOSTNAMELEN is no longer truncated when the
destination has room for it.

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
The MAXHOSTNAMELEN cap can bind on three fragments. A model name
longer than 56 characters, a host name longer than 59 characters or
an OS name longer than 59 characters now reaches the symbolic node
name in full instead of being cut at the old tmp boundary. The
firmware revision and driver version fragments are too short for
the cap by their own bounds. The differential harness swept
eighteen buffer sizes between 1 and 300 across 4000 randomized
field sets and found the outputs identical everywhere the cap did
not bind, with every difference classified as this cap removal.
The KUnit corpus executed representative cases of the same
truncation behavior as compiled kernel code.

 drivers/scsi/lpfc/lpfc_ct.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c7853e7fe071..0734ab3be3e3 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1823,34 +1823,15 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	size_t size)
 {
 	char fwrev[FW_REV_STR_SIZE] = {0};
-	char tmp[MAXHOSTNAMELEN] = {0};
-
-	memset(symbol, 0, size);
-
-	scnprintf(tmp, sizeof(tmp), "Emulex %s", vport->phba->ModelName);
-	if (strlcat(symbol, tmp, size) >= size)
-		goto buffer_done;
 
 	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
-	scnprintf(tmp, sizeof(tmp), " FV%s", fwrev);
-	if (strlcat(symbol, tmp, size) >= size)
-		goto buffer_done;
-
-	scnprintf(tmp, sizeof(tmp), " DV%s", lpfc_release_version);
-	if (strlcat(symbol, tmp, size) >= size)
-		goto buffer_done;
-
-	scnprintf(tmp, sizeof(tmp), " HN:%s", vport->phba->os_host_name);
-	if (strlcat(symbol, tmp, size) >= size)
-		goto buffer_done;
 
+	memset(symbol, 0, size);
 	/* Note :- OS name is "Linux" */
-	scnprintf(tmp, sizeof(tmp), " OS:%s", init_utsname()->sysname);
-	strlcat(symbol, tmp, size);
-
-buffer_done:
-	return strnlen(symbol, size);
-
+	return scnprintf(symbol, size, "Emulex %s FV%s DV%s HN:%s OS:%s",
+			 vport->phba->ModelName, fwrev,
+			 lpfc_release_version, vport->phba->os_host_name,
+			 init_utsname()->sysname);
 }
 
 static uint32_t
-- 
2.47.3

