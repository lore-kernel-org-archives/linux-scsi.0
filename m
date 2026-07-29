Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96281480973;
	Wed, 29 Jul 2026 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336419; cv=none; b=DOS+YzDqbAG4ht3Er8oo8ZjK4he85V6dyjSMkLYXk+h7f4IvpGEAhJ5RcXAYamD0HpIYkjYDghAsiPqeHVkeHK5ODPOfwoQ9FmYUZiIHiG+jj15dw12B5Mnq3bXjZGnURe16vISkCKdidnAmiDhMYQx6/5zDrTVkXxVHu+tNxPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336419; c=relaxed/simple;
	bh=fY4LvueJPuQB2XUcqfYsgBzV3um78gdOFqUcHwW1Luc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m+4GbQzbB9Eyiv1z5cEwo1alzf1c4089ehFRg/oNkM01uYd5gkBTMuiMYBFmhyqtkh5q+zqIb00B5zzz034CxRu35lilOL6TtnvrPK0mLrTUNebaw43MPDR/OjGOXfxUzEy1rbq+UnvK1x8NfIohodp89WUJ9pDUpzALljLBx+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=gXK+rBB9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CgyNRIdO; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="gXK+rBB9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CgyNRIdO"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A2301140026C;
	Wed, 29 Jul 2026 10:46:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 29 Jul 2026 10:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1785336416; x=1785422816; bh=nKK1klZmeIjDzgqem15a3
	PEY6uAsuhF9L+kDnRP8l9w=; b=gXK+rBB9yP7JzkS7fQNaIPVZeaJX934N9ZHyu
	sJ2GYJPDZokoZ8QD/cp2AlsJbLSotHsEDCjNfm2kB83dGV3InQCxT6wxPsYZ1BFL
	JOIo434s6PvPwZj4iL3yZ155CB3M6jgsNlbM+lp5X/PXjqg+BpGJwebjNQ0UrVfB
	lQIDpIBgcDdXXm/zpo1MyiRchYLBBOllQPd9d29g6TSlJrtBarubMcrrJ0pqEOP6
	sqEoWHKWIdA6aOGYi6Nq5kuAFty8AtdlVNXWKM1688cC9KB66EPfkwWTdeMHCxqY
	M1iZAMCrDhbvNe2nYjxxuOpmNXmLbSqbzSk3dLKKWKGq3DsVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1785336416; x=1785422816; bh=nKK1klZmeIjDzgqem15a3PEY6uAsuhF9L+k
	DnRP8l9w=; b=CgyNRIdOZFJ8txl6HYt2QhBWHRsVQix52jx6e2/rbz4Ej8qVnMN
	rdYjS3DJ3OT57RD8NcpUkv5Mr9yBw+rYLrKEUQTiwBDf3rn5aLs7jtLf3j5FA0NF
	r4txmGNFu9w4yDt6VZeaygwECvLuxZN7Ty9l8Ai7zGzw1ksvPx1kdJ8rO+FXjL5n
	Pl5jP3Qwq8YWbVHuhC+fscmgWmEjENDjkZ6OpkVQ9pxwK9ct2I4/YMBD7xeHxGB5
	Fhckopgo2Z7a1Mww7psGHKEhuT4IlNP6mJSUivknTH7eThSN+hoV6hlO32yDhYvL
	AGqBIPRXSLXuz6aQzTb+uKkXLWv3l2gQiOQ==
X-ME-Sender: <xms:YBJqavqnHvqMQnUX3RlhSt2xIxw0enMxAX8HxAhdXRtN9_hztv7OAg>
    <xme:YBJqaqHXEcK3AK2lnKjvGMIHPrFjX-6okT2ddqsCKTpc-iShlX5xcY7-K00SoKPKr
    xR45tprihW1Ie4iDxLexjeflSgqC4ND6efAYsskNwKeGrRBBFS15jHl>
X-ME-Received: <xmr:YBJqas5xxtiBJBWrVbRLZ5wUWZaN5SHz24F4znHKsbGD7cvtf_dfzsmDwv8>
X-ME-Proxy-Cause: dmFkZTFgCFPPghjny/iwPpEcL6UKUzYmTQib+AyxcEGe7YpUq7r6DQc+y5IdHAptOCdEmP
    fMw++SvKwFAbcQ3PpgP01YHXjsPhLnHiOAIaJMEPBRud+lzFafRGd0oLo4p+0oEzZeOQdK
    /mYF2DiiUILqEIfdLej9PwWbv3Et4vxTRsgA2LsnPHjxw8vV7mPa/6obEYzyzlxZsKogxf
    F/JsBeYscBe7Xln75Wq0jow54AvwmkDz1R8byQdn3CkILyWlMY6V04Y7ynZEJNfrCD2JGM
    0lDU63YZWXj5o0f6W5dmXXLpGjO2eqZsQ2M0di2PtRWEglRlZGsGzoyk6nwjQ3GZBYrosF
    FSq75ghY2R3LewnnXHUyJFKzXd+8gw/SZddCx6gjMg8vwak+uzU0VQYK9mtps+6k1hSfTA
    aRAPCEqyUTG7kMJciEn2aO9rWB08iIcjNPjnurVEAMmcW3O6prud54MLyBDMG69gV80IOj
    YmtSJNZ6DTVsAjzkBVGNyPPuJck5i1g1UBiY7N0o+lihYI6Q4L+MKpeaSTzOcMbZDbewyj
    VNlEZzrHecbO81CP1SIFxMRkoMp9iSftnQmimN8W0v9FQy81ZzsSloQ2aHTbRQSgdlkCbc
    4X/4S4H+2F2z7sKUFCAzCrvaiXwslY31ZQjarzh8c3Mofk3NXkbxu8MgMSgg
X-ME-Proxy: <xmx:YBJqaqdvcZzBcArbIT1sZkCHeo8zOSsfZ0XVTyoYOnzLB3QYWfP1Xg>
    <xmx:YBJqav7MNroC3XeulmzaXuWXGCZVulVVy4csnymQCF7AeTeW1lDdlw>
    <xmx:YBJqan99HvT2V_-1RIhswtdqEBilCxdcw4Mbid7BJglTZ8CgzHHkig>
    <xmx:YBJqahFh7YTKDHNjb3dK-FKHL9gN2g0JouZmV-wEbXbB1kXftU1QjQ>
    <xmx:YBJqaiRseCCQnTFhL2oV679nwDrhHW8If0DngF6ofyQ8Crv5FT962sbz>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 10:46:56 -0400 (EDT)
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
Subject: [PATCH 0/5] scsi: lpfc: Remove all strlcat() uses
Date: Wed, 29 Jul 2026 09:46:12 -0500
Message-ID: <20260729144617.1388646-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for removing the strlcat() API[1], this series replaces
its 81 remaining call sites in the lpfc driver. The sites live in nine
string building functions across five files, and each patch converts
one source file.

Functions that accumulate a variable number of fragments move to
seq_buf. The three sysfs show functions move to sysfs_emit_at(), the
designated helper for sysfs output. lpfc_vport_symbolic_node_name()
builds five fixed fragments and becomes a single scnprintf() call.
The intermediate tmp buffers and the per fragment overflow checks
become unnecessary in every scheme. Each loop that appends keeps one
overflow exit, so a full buffer stops the iteration.

One cross-cutting behavior change applies to several patches. The old
code formatted each fragment into a fixed size tmp buffer before
appending it, so a fragment longer than that buffer was silently
truncated even when the destination had room for it. The replacements
format each fragment directly into the destination. Truncation is
still bounded by the destination size. The per patch changelogs call
out the affected functions.

The patch series was tested as follows. No hardware testing was
done. Testing on real adapters is welcome.

- W=1 builds of the whole driver directory, zero warnings.
- A userspace differential harness. The old and new function bodies
  are extracted verbatim from the two trees and compiled side by side
  against the real lib/seq_buf.c. 472000 randomized cases across all
  nine functions, including oversized inputs, undersized buffers and
  prefilled destinations, compared byte for byte under ASan and
  UBSan. All outputs are identical except two behavior changes.
  Those are the format string interpretation removed in patch 1 and
  the fragment cap removal in patch 2. The harness classifies every
  observed difference as exactly one of those two.
- A KUnit corpus. The nine functions run as compiled kernel code in a
  QEMU guest with KASAN, UBSAN and FORTIFY_SOURCE enabled, against
  fabricated adapter state covering both branches of every converted
  conditional that is compiled in. The LPFC_MXP_STAT debug block is
  disabled at compile time and was build tested with the macro
  defined. The same 40 test cases run on the unpatched base and
  on this series. The base run matches the old expected outputs, and
  the patched run is byte identical everywhere except the two
  documented changes.

[1] https://github.com/KSPP/linux/issues/370

Ian Bridges (5):
  scsi: lpfc: Replace strlcat() with seq_buf in lpfc_info()
  scsi: lpfc: Replace strlcat() with scnprintf() in
    lpfc_vport_symbolic_node_name()
  scsi: lpfc: Replace strlcat() with seq_buf in lpfc_rx_monitor_report()
  scsi: lpfc: Replace strlcat() with seq_buf in the debugfs dump helpers
  scsi: lpfc: Replace strlcat() with sysfs_emit_at() in the sysfs show
    functions

 drivers/scsi/lpfc/lpfc_attr.c    | 555 +++++++++++++------------------
 drivers/scsi/lpfc/lpfc_ct.c      |  29 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 202 +++++------
 drivers/scsi/lpfc/lpfc_scsi.c    |  49 +--
 drivers/scsi/lpfc/lpfc_scsi.h    |   3 -
 drivers/scsi/lpfc/lpfc_sli.c     |  43 +--
 6 files changed, 361 insertions(+), 520 deletions(-)

-- 
2.47.3

