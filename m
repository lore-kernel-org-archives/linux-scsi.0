Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEE9494824;
	Thu,  8 Oct 2026 23:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503144; cv=none; b=G3FMvb9BnvPaT/96gcXfbLgYnlpcryxk4wKezpnSLDGtiUiwkIr+B32mbZnpOlPDQ58m6ASz7b06FXjsnQZXbiAMMZwLy1qky8VnBn6dwfyJdEhxa+7qTG5O6l/ntErmk+REhavHqY8QHsBI+2PWn3DGXtEGsk8KVMz3n7vLoi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503144; c=relaxed/simple;
	bh=PO+0RXx4lwrvrHU81bFw1D1ou7ZGqZY/X5LjLl9Tyqc=;
	h=To:Cc:Message-ID:From:Subject:Date; b=Ndv7xmzwGbq4inWfqV1/OdK96hnJpTAKw9stunobms2ChphFTOYg2gAD2Xlq8wu/tVal8DqwKMsaJKqk9ebXUcB7vo1teQkgQbp5jz3ahD43ZSFzoZdj/MG24fZUCzDtQivXN3T/eXkF3pJrh3sZnZ8R/0l6ZpqU7lXRNgBiAXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vH67yRsx; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vH67yRsx"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8EB7E14000B0;
	Thu,  8 Oct 2026 19:45:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 08 Oct 2026 19:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:message-id:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1791503139; x=1791589539; bh=GiDSulDVk9/8g+hsX7u0PInAfzwI
	5wbfRuyS7gRyoiY=; b=vH67yRsxNqowrQ6J+zgAIviNuAMXo1TH7R7m15TFeoAn
	g5jYKPErO3M2EWXUM/CGp1aY4T9SWQOUeAwh0ThMOqROirNcojfYvFPsm6ncKQwY
	NIK7asPvUimfAthGlqoJwHuOGDN+WuX7JcBpYI6C8ujvmA0NpRKR/EN5BCIxTwMP
	hC45aGBRDmJ8TxGCkGnC2UQSpyM2hxMyKIJdBJtZ4pSIt/50kKOdNnLZWLy0DLkk
	3fbB4ugAaepqXhae4/nLwPpEevLeo8SITEPAjbls8nt2xZ3sdlR+iY18zB0ZYf7I
	4wyiTx8KrMb2qAwKLuQRlYb1OVl+VL4QJKvIC62Iww==
X-ME-Sender: <xms:IivIam8IBS8IsWMkXwSexqJVaCluib7qBrtUqQIcriRzbqq7vKyVsA>
    <xme:IivIahJfpVy3iY1_2kblrBQq_eFod-0JRVTwdgV8U8VOCiW_My6IQVTxCocJX5h_t
    G1s3Dt8RsMWUK2pNG0VyOmHhlzl_6bTjlj9Jyx2OQj9iVXFSYSQLIrS>
X-ME-Received: <xmr:IivIajgl1pizeXnxFdtF6_J5oZrnY1sjY6mIFLCvGkTti73cWwNpGGGPEbONoTVGJz2IDSZtSmx7QRnndGlWBxZwvi8H4UvYZGM>
X-ME-Proxy-Cause: dmFkZTGeHkFjRsYgxADtbgwMp//B0EhCDZj4JSjgNujfkKl0rSsDgx0koy687zN5HBnneA
    72OW6sJA74lKPqHbDAZ5CjlEWuJeyXML6U71ie+dE0SIcfsNUxElGhEXd8NsGaqTJDxM4C
    zc80Elfz1MZrOd53bPk4yjLZky/7QrBro1tLpcTPjPHlP9AaHuQeKLjBVpLeJzaIQO4tuh
    2kCDa8MLTD2IqK2VozwO52kWnzXA+l7a52N+5+xvW92jLkEuekRagIzRZah7Ro9Zw6xgYU
    g++RRCxP+YmsmXGdqe48a67ZWC7YFnuZYoIlDo/qYni/ggW+3FODDnChwxAKtG3kfeIYDY
    snXJoxYKtc+pym8ci5V3RXs+sf9dRmaLDQ54zsRkOqrL+BnXOKvL3A8PWTRmUn3/HCRCRo
    nVJW+aTfhIJsIXgqRaJfiQUe4OaRZXTD1Fug2UbFY0Db5rgKPlU+xlTqCtj3moFPiEqDkL
    JwBbRxHJ7hkQb0TRQ8uH4rnNt0Gmvbfn4voggvdZ6xqfyRyf0B/s/OgXDsPQF6s9mpUyIu
    P+UuuBLJDxdflRQPAqpKpcSFtoOIeXPqchlw4V6b9NVFEu3Ih/53i8WSlJy80yUmYT6Ul3
    93Q3P8xwM6LXihs5XyhlsnM3gxZptzhygvU7+8GWn5l/iNYeeVoerVJACh0w
X-ME-Proxy: <xmx:IivIal9KLtVqfUzO7WlPKZzGPtFv3Lvx39m-0Mn8OSGa01DSkmGQkg>
    <xmx:IivIagOkiLJRkvVl3NyndQJ_eO5kSjFQrQpZl9GcYKQBiipDTZQd6Q>
    <xmx:IivIahCSNi2cCPbBv1d-ymIGp7mx9AAqAt2m26HIARcWC5jU15MsJA>
    <xmx:IivIasPc4NsBBG5cElXAaZGXf08CEKNtzZxGLXXME3nctZpaXmw2dg>
    <xmx:IyvIanhBGdq_UxnIFuOU_A7EbQo6gCDH8dyQkXqbS3O5KAjpC2HbDhEq>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Oct 2026 19:45:36 -0400 (EDT)
To: Nilesh Javali <njavali@marvell.com>,
    GR-QLogic-Storage-Upstream@marvell.com,
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <mkp@kernel.org>
Cc: Gustavo Silva <gustavoars@kernel.org>,
    Tony Battersby <tonyb@cybernetics.com>,
    Andrew Morton <akpm@linux-foundation.org>,
    Arnd Bergmann <arnd@arndb.de>,
    Geert Uytterhoeven <geert@linux-m68k.org>,
    linux-m68k@lists.linux-m68k.org,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-ID: <4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH] scsi: qla2xxx: Rework BUILD_BUG_ON() assertion
Date: Fri, 09 Oct 2026 10:41:26 +1100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The LKP bot reported a build failure with CONFIG_COLDFIRE=y together with
CONFIG_SCSI_QLA_FC=y. The failure is caused by BUILD_BUG_ON() but there's
no valid reason for it -- the assertion in qlt_queue_unknown_atio() is
simply checking the wrong thing.

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

The location of the last member is subsequently used as the destination
for a memcpy() that's expected to fill in the extra bytes beyond the end
of the struct, which explains the loud warning in the comment above.

That ought to be sufficient to prevent some newly-added member from
accidentally getting clobbered. But, in case that comment was missed
somehow, we have this assertion:

BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
             sizeof(*u));

Unfortunately, this doesn't guarantee that 'atio' is the last member.
Indeed, adding a zero-length array member at the end does not increase
the struct size. Moreover, that BUILD_BUG_ON can fail even when 'atio'
really is the last member, and that's what happened after commit
e428b013d9df ("atomic: specify alignment for atomic_t and atomic64_t")
which added two bytes of harmless padding to the end of the struct.

To resolve those issues, place a flex array at the end of struct
qla_tgt_sess_op (any new member added after a flex array will produce a
compiler error). Then have the BUILD_BUG_ON correctly assert that the
'atio' member ends at the offset of the flex array (compilers won't insert
any padding there).

Cc: Gustavo Silva <gustavoars@kernel.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603030747.VX0v4otS-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202609301230.CauIUXCF-lkp@intel.com/
Fixes: 091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory access with big CDBs")
Fixes: e428b013d9df ("atomic: specify alignment for atomic_t and atomic64_t").
Suggested-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
The build bot prodded me again me again about this last week, so I'm
re-sending the same fix I sent on March 10th, with a few clarifications
made to the patch description.

The use of a flex array here is not unlike the work that Gustavo Silva
did last year on this driver, so I've added Gustavo to the Cc list.

I don't have the necessary hardware to regression test this patch.
However, the only change to object code comes from __LINE__ values.
If the new line break is omitted there's no change at all. So this fix
looks quite safe to me.
---
 drivers/scsi/qla2xxx/qla_target.c | 5 +++--
 drivers/scsi/qla2xxx/qla_target.h | 9 +++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 53a505df8da0..44720f5c0346 100644
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
