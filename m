Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCCB3D34B3;
	Tue, 10 Mar 2026 06:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773122454; cv=none; b=eRJIbglIkjAaDGqk/WjMzbLuPLpGLCYjLplrr/HLLQt+JwnoqVgZP2UQeq7GIW8Q9B3Ic/lTu9zM+TE2ClANUE+cNtakSCT8FWO37QuAO97JePR5ggA7LKfwXchhNhqb4rWQEHgoMDLQ8ntHHNyD7JFR6135DBlLDWwIwEukpyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773122454; c=relaxed/simple;
	bh=E13WlNOoJj2s3HxXsiNspZsCL6eSoOAJ+pLou8tnRsg=;
	h=To:Cc:Message-ID:From:Subject:Date; b=uIGbBJZswVfj9fw6KK4N53+s2P48WKd7GMwNqyD0NyF+8/0y/M7vlERk3dzZZ8HMs55o4y3DNsmxlRlxWcq+xp6Yos73BRz1sCbtGfy2WkqIWjQZddaEUI0XIC08nGw+DKW3BLAoimSEBUV0zXDepymXwbc+OerbarHp+QeA46A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rE5yIGWZ; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rE5yIGWZ"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C08D57A0148;
	Tue, 10 Mar 2026 02:00:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 10 Mar 2026 02:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:message-id:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1773122446; x=1773208846; bh=IDNapaTs0bZV5cZwDXM9HDN4a9Aw
	idSQkOXdqAPub80=; b=rE5yIGWZT/pMkafKN8fIHGYaNjBjkLclt+zBnxhfj9p5
	xmMplkFARbuSoPelf8tXAmV8uE+xgekAvW0Jnutf3scueHocYOpwTDh71GklqWh8
	wFcBRlSULXziQhqqico0qg1fEBv37MCc7AtrpciUqhJIWJmC754QI2b3/gvkF2Dp
	dSg05M/BHMvZYzpFyRmx3W6h42tgOj1YrMlB7ZWWXCcwRms7qexBlzZUBftVMa3T
	0CrC/knoyrxTtIpkOQq7Wx8deB4mDsWqI6teHyiWpsO4Hmpqu3XcCF/b23X1HL75
	smnCnZMcbuxGhwnuS2W+7KM04aX/n9eqRuYqW4GMeg==
X-ME-Sender: <xms:jbOvaRA26ZoGukK_FaLrIqaFfAxa1C_p0_pdZAPpSxF2JLOCRNa4Qg>
    <xme:jbOvabY3gymqukVEPUH2IyFPJAt-S0LvBwDlHayxJBtHlRBEzs3rniSNC6cBHdKeA
    9GSvohgHyRQHNDDgJFxb4A95opsfpiDwhdc6gMlC3_Z_t51a_MRhbc>
X-ME-Received: <xmr:jbOvaZlXf5BowZXKSVTuGG80xT6Ampisd_bChj5_KKoFJFrmiZAqMOcpaPiBpOcv5V_vkINMHpY_emHbF7stMHL0vwZeQxLwZf4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkedtvdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepvfevkffhufffsedttdertddttddtnecuhfhrohhmpefhihhnnhcuvfhhrghinhcu
    oehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekffejgfehheehkeekffffveekteevvddvveelhffgffetteefgfeutdehleetheenucff
    ohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepfhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrghdp
    nhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehnjh
    grvhgrlhhisehmrghrvhgvlhhlrdgtohhmpdhrtghpthhtohepghhrqdhqlhhoghhitgdq
    shhtohhrrghgvgdquhhpshhtrhgvrghmsehmrghrvhgvlhhlrdgtohhmpdhrtghpthhtoh
    epjhgrmhgvshdrsghothhtohhmlhgvhieshhgrnhhsvghnphgrrhhtnhgvrhhshhhiphdr
    tghomhdprhgtphhtthhopehmrghrthhinhdrphgvthgvrhhsvghnsehorhgrtghlvgdrtg
    homhdprhgtphhtthhopehtohhnhigssegthigsvghrnhgvthhitghsrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegrrhhnugesrghrnhgusgdruggvpdhrtghpthhtohepghgvvghrtheslhhinhhugidq
    mheikehkrdhorhhgpdhrtghpthhtoheplhhinhhugidqmheikehksehlihhsthhsrdhlih
    hnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:jbOvaQotKRvCmBXCFdCMNX8GUeog03tY5QvL7PU9G5rDtcDwLapW3w>
    <xmx:jbOvabBiiIhPA8OVqGzmLiVjAM6UXcsjUJGjj6KC6j3OLanTfM06Hg>
    <xmx:jbOvaTFiqnf7AcCEhAIOaw4s1DSTUv5W_2Wqy37C5dpKjKEBnkV-Pg>
    <xmx:jbOvaV1relHVU54TI_ZBPktoVFZ01thRhNG1Z47sFF4556ENVDPBlA>
    <xmx:jrOvaeNreBXzPjNCiY76lOAUFyUQJgfS7uyPjz02_3vaHW3cBocjuYsS>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Mar 2026 02:00:43 -0400 (EDT)
To: Nilesh Javali <njavali@marvell.com>,
    GR-QLogic-Storage-Upstream@marvell.com,
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tony Battersby <tonyb@cybernetics.com>,
    Andrew Morton <akpm@linux-foundation.org>,
    Arnd Bergmann <arnd@arndb.de>,
    Geert Uytterhoeven <geert@linux-m68k.org>,
    linux-m68k@lists.linux-m68k.org,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-ID: <ed3e6d1536bced61166ef408bd3327acc340216e.1773122366.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH] scsi: qla2xxx: Rework BUILD_BUG_ON() assertion
Date: Tue, 10 Mar 2026 16:59:26 +1100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The LKP bot reported a build failure with CONFIG_COLDFIRE=y together with
CONFIG_SCSI_QLA_FC=y, that is attributable to the BUILD_BUG_ON() in
qlt_queue_unknown_atio().

That function uses kzalloc() to obtain memory for the following struct,
plus some extra bytes at the end.

struct qla_tgt_sess_op {
        struct scsi_qla_host *vha;
        uint32_t chip_reset;
        struct work_struct work;
        struct list_head cmd_list;
        bool aborted;
        struct rsp_que *rsp;

        struct atio_from_isp atio;
        /* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
};

The location of the 'atio' member is subsequently used as the destination
for a memcpy() that's expected to fill in the extra bytes beyond the end
of the struct.

That explains the loud warning in the comment above, which ought to be
sufficient to prevent some newly-added member from accidentally getting
clobbered. But, in case that warning was missed somehow, we also have the
failing assertion,

BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
             sizeof(*u));

Unfortunately, this size assertion doesn't guarantee that 'atio' is the
last member. Indeed, adding a zero-length array member at the end does
not increase the struct size.

Moreover, the assertion can fail even when 'atio' really is the last
member, and that's what happened with commit e428b013d9df ("atomic:
specify alignment for atomic_t and atomic64_t"), which added 2 bytes of
harmless padding to the end of the struct.

To resolve those issues, place a flex array at the end of struct
qla_tgt_sess_op (as any member after the flex array would result in a
compiler error) and then use the BUILD_BUG_ON to ensure that the 'atio'
member ends at the offset of the flex array (as compilers aren't expected
to place any padding between the two members that would mess up this
calculation).

Cc: Tony Battersby <tonyb@cybernetics.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603030747.VX0v4otS-lkp@intel.com/
Fixes: 091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory access with big CDBs")
Fixes: e428b013d9df ("atomic: specify alignment for atomic_t and atomic64_t").
Suggested-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
This patch is submitted as a possible alternative to "[PATCH] scsi: qla2xxx:
Remove problematic BUILD_BUG_ON() assertion", dated 2026-03-06.
Either one would do the job. Compile-tested only.
---
 drivers/scsi/qla2xxx/qla_target.c | 5 +++--
 drivers/scsi/qla2xxx/qla_target.h | 9 +++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d772136984c9..eb1de988f69c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -212,8 +212,9 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
 	unsigned long flags;
 	unsigned int add_cdb_len = 0;
 
-	/* atio must be the last member of qla_tgt_sess_op for add_cdb_len */
-	BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));
+	/* atio_u_isp24_fcp_cmnd_add_cdb follows immediately after atio */
+	BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(struct atio_from_isp) !=
+		     offsetof(struct qla_tgt_sess_op, atio_u_isp24_fcp_cmnd_add_cdb));
 
 	if (tgt->tgt_stop) {
 		ql_dbg(ql_dbg_async, vha, 0x502c,
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 61072fb41b29..11a406ee2187 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -309,7 +309,8 @@ struct atio7_fcp_cmnd {
 	/*
 	 * add_cdb is optional and can absent from struct atio7_fcp_cmnd. Size 4
 	 * only to make sizeof(struct atio7_fcp_cmnd) be as expected by
-	 * BUILD_BUG_ON in qlt_init().
+	 * BUILD_BUG_ON in tcm_qla2xxx_init(). See also, BUILD_BUG_ON in
+	 * qlt_queue_unknown_atio().
 	 */
 	uint8_t  add_cdb[4];
 	/* __le32	data_length; */
@@ -845,7 +846,11 @@ struct qla_tgt_sess_op {
 	struct rsp_que *rsp;
 
 	struct atio_from_isp atio;
-	/* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
+	/*
+	 * DO NOT ADD ANYTHING ELSE HERE.
+	 * atio.u.isp24.fcp_cmnd.add_cdb may extend past end of atio.
+	 */
+	uint8_t atio_u_isp24_fcp_cmnd_add_cdb[];
 };
 
 enum trace_flags {
-- 
2.49.1

