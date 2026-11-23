Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795477040;
	b=jTlSsUqWKpjQU1lnyp+I1a33WVod/WOXyYbooFJsoaNuHNY3IJCvNq7nfYkSQ7+TEJxW
	 h7B2xa3gCVGHubmmFM1pFU/tDeej3seoYlfhU0hl/lpA/qzhia395+Qn2hULfhog9boy2
	 tm7T1iJSgFnIMmBQU3YKLPVpZGUFrwI4PY2XE3Xhv/vIRL77x2dunSgWnPe7mA+BTY9C3
	 mQln9dhTl8IMMZWsnp4SjRzhprGKGMcGxVR3YxpMJXi4txSLLcHCSE5SW9XBDu3BkTRkR
	 6VadVsU/6PcLd2b8T5OEOB91NfVBB+o0gSVWwfwQzhU4r2Kvh5Fcv6+16BX0Rcxfldg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795477040;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=vZhwtoY0rC9tiCZjGnjs0trKwj1W0j+uoO6PhMytwUs=;
	b=MyedLQBZcw2DXqeh9NkseT4ht0Z03pvsLbrk8rsMFms1NNUYGhgEBRMKe0x6JGMHpCxe
	 lZPm5lDUQGcXkdQByuH0d/KwnCzoWAbvzOGXtmxaxxEP4irb3yX9cNzBijUKI+pYGeEcw
	 Wz/eTAaKLxkiWA9WcBtmL/Lw0+KGFFxh5t02WJqgH59bg10XyRPQdXn/dbCx1aqMyG6ac
	 xdCxw41zSfotfZ6SSlh88biSq3AF4gZ0YMNqnJ2mhUVzYvGHZ0zPDnIeCe3NO7sJ/oQl4
	 CWbXDX4WxHopVrTYvCk0F5f7eXn9e4B0K2bBaROp/+GfHCZe+UxpYC+YXg2KYxLt0Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=STkenfZj;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD07F606A31E;
	Mon, 23 Nov 2026 23:37:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD07F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=STkenfZj
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jYMmb1Hz2zlfvqM;
	Mon, 23 Nov 2026 23:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795477032; x=1798069033; bh=vZhwtoY0rC9tiCZjGnjs0trK
	wj1W0j+uoO6PhMytwUs=; b=STkenfZj4VkbVQLHeDA3XMnNB6jkg7p1pv3acqQL
	xWYVRpEfS0spAZLFnHD8/R7/Q5lF/lkNSDTU+UCrWMtlnqyGg27K3HbAQLmGTOwb
	jgn8KzoBzVaZnayMIizHneXNIFV8jyo6tZ7iMl0q6tWdXL7bpbSpeNBrOs77QKTw
	jhE0nCnBZFVnnWEFpEeIQnvV+t7/8RdsItTcEJFR8DXTLi93Ap30n9Wz5ko52yqB
	405kclQYg+Ccp1puRKAM7b/3h/34ybQWDe6wE76U2UWLwa+hsOt+v1/NePhzrgpA
	nHO/rn4nNX4In8GsF7qRR25ngg6s040aJzgMYByVIXiFyQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vk9VGeuZSzFz; Mon, 23 Nov 2026 23:37:12 +0000 (UTC)
Received: from [100.80.227.185] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jYMmS40TJzlfvqS;
	Mon, 23 Nov 2026 23:37:12 +0000 (UTC)
Message-ID: <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
Date: Mon, 23 Nov 2026 15:37:11 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
To: Finn Thain <fthain@linux-m68k.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Arnd Bergmann <arnd@arndb.de>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com>
 <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
 <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
 <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/26 3:05 PM, Finn Thain wrote:
> Yes, two alternative solutions were submitted in March (either remove the
> assertion or rework it). The build bot reported the problem again in
> September so I resubmitted the "rework" alternative. Sashiko-bot didn't
> have much praise for that*, so now I'm leaning towards the "remove"
> alternative. I have been advised to keep re-submitting, and I will do so
> after a suitable back-off in retry rate i.e. 2027 or 2028.
> 
> *
> https://lore.kernel.org/r/93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org

What an LLM came up with after I asked it to fix
https://lore.kernel.org/lkml/202603030747.VX0v4otS-lkp@intel.com/ can be
found below. One of the comments of the LLM is "This is essentially Finn
Thain's "Rework BUILD_BUG_ON() assertion" patch with your two review 
comments from this morning applied". Sashiko reports "No issues found"
for the patch below. No Signed-off-by from me because I think Finn
should be credited for his work instead of I.

Bart.

     scsi: qla2xxx: Fix the qla_tgt_sess_op layout assertion

     qlt_queue_unknown_atio() allocates a struct qla_tgt_sess_op followed by
     add_cdb_len bytes and copies an ATIO plus its additional CDB bytes into
     the 'atio' member. Hence no other member may follow 'atio'. The
     BUILD_BUG_ON() that is supposed to verify this compares the end of
     'atio' with sizeof(struct qla_tgt_sess_op). That is wrong because it
     also triggers if the compiler adds tail padding. This is what 
happens on
     m68k since atomic_t is aligned on a four byte boundary: 'atio' ends at
     offset 102 and the structure size is 104 bytes. This breaks the build
     for CONFIG_COLDFIRE=y and CONFIG_SCSI_QLA_FC=y:

       error: call to '__compiletime_assert_431' declared with attribute
       error: BUILD_BUG_ON failed: offsetof(struct qla_tgt_sess_op, atio) +
       sizeof(u->atio) != sizeof(*u)

     Additionally, the BUILD_BUG_ON() does not detect all members that could
     be added after 'atio', e.g. a zero-length array.

     Fix this by adding a flexible array member after 'atio' that represents
     the additional CDB bytes. The compiler rejects any member that is added
     after a flexible array member. Assert that the flexible array member
     follows 'atio' immediately instead of making assumptions about the
     structure size. Use kzalloc_flex() to allocate the structure. This does
     not change the allocation size.

     This patch is based on a patch from Finn Thain and on a suggestion from
     Tony Battersby.

     Do not modify the memcpy() call in qlt_queue_unknown_atio(), which
     still writes past the end of the 'atio' member.

     Compile-tested only, for m68k (Coldfire) and x86_64.

     Reported-by: kernel test robot <lkp@intel.com>
     Closes: 
https://lore.kernel.org/oe-kbuild-all/202603030747.VX0v4otS-lkp@intel.com/
     Closes: 
https://lore.kernel.org/oe-kbuild-all/202609301230.CauIUXCF-lkp@intel.com/
     Link: 
https://lore.kernel.org/all/4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org/
     Fixes: 091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory 
access with big CDBs")
     Fixes: e428b013d9df ("atomic: specify alignment for atomic_t and 
atomic64_t")

diff --git a/drivers/scsi/qla2xxx/qla_target.c 
b/drivers/scsi/qla2xxx/qla_target.c
index 5a7caff61b16..afa96551c13c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -212,9 +212,6 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
  	unsigned long flags;
  	unsigned int add_cdb_len = 0;

-	/* atio must be the last member of qla_tgt_sess_op for add_cdb_len */
-	BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) 
!= sizeof(*u));
-
  	if (tgt->tgt_stop) {
  		ql_dbg(ql_dbg_async, vha, 0x502c,
  		    "qla_target(%d): dropping unknown ATIO_TYPE7, because tgt is 
being stopped",
@@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
  		add_cdb_len =
  			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;

-	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
+	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
  	if (u == NULL)
  		goto out_term;

diff --git a/drivers/scsi/qla2xxx/qla_target.h 
b/drivers/scsi/qla2xxx/qla_target.h
index 71bc1affb1bc..c1559f034f85 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -845,9 +845,16 @@ struct qla_tgt_sess_op {
  	struct rsp_que *rsp;

  	struct atio_from_isp atio;
-	/* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
+	/*
+	 * The part of atio.u.isp24.fcp_cmnd.add_cdb[] that extends past the
+	 * end of atio. Must follow atio immediately.
+	 */
+	uint8_t extra_cdb[];
  };

+static_assert(offsetofend(struct qla_tgt_sess_op, atio) ==
+	      offsetof(struct qla_tgt_sess_op, extra_cdb));
+
  enum trace_flags {
  	TRC_NEW_CMD = BIT_0,
  	TRC_DO_WORK = BIT_1,

