Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795195920;
	b=LtteJW0sOFek30bMED/9+oBAnPTdMMd02Ezwiia11PQuL0jdTTy3bY3kF865Plw0r//a
	 I/XxijbTGU1MmfzpWTPtXkDOmW/5OOroZ3Cr6Ky25jnPn0QfXK569lvtKemKpkC6t7pyn
	 NQsnp0Q+hTq0C8h92XZ4oraB13EMBX0NLVZnKjdllRHJWHqHwFdCWfZaj6ZmMVHgJ3X7y
	 FLM4FLAA+r1npFXAk5cCvFl47jKrZnXLLMNHqPaAj0hXIjjoDmkjt2rwZfpohtIOBVMfN
	 EsOK3YLURn04ALHZtmkl63nucl9hW4zyRSNifVWS9Cngqhe7oy4wdG8lsT4ay3R05cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195920;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=1lx0wfNVXkVLhymhPDkbH3mU8AtjMWYu6LBXWtj8f/4=;
	b=IDMQnuiteh7VeFjCDUKrNuPXSFXo1U51nYrFjWr1e67zUvq1xV1cTYqy8Mi1i97797sp
	 enBcyjqirxIl9v415Oa9QNSmbfZeSHEjGuy4rIYTLnbbaYP5zrTJ4UTaOAd3ISjMiqgmQ
	 AcOWG3M/U21v21PMB2oZTBZc0Z1cmXL27YCX9gtfuaN6zDF8epvWdzpNz5btaahCa6O99
	 kFhBPE7hI7lDvrGVEFRtzKRmKcpdaGKueljWnZVWRquuofWmmwchsTTheHQUTuf4UOnpF
	 QgJy3TVXyk79sr34gz0GSyVEhZtMYR9+0ekmZPqDqCTliaenzhLp7JINLRZVUtROOeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=b0qxGouI;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196BB60A2613
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 17:31:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 196BB60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=b0qxGouI
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2f02f04a426so9862555ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 09:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795195919; x=1795800719; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1lx0wfNVXkVLhymhPDkbH3mU8AtjMWYu6LBXWtj8f/4=;
        b=b0qxGouI01Q7g58R9t1IKaNFoPtO5CPrzo1lzGcWMit8lN+PlOZCcryx7ToHCut/Og
         H8Su3OtrxNac4NOe/NofEMPOJOEhfuQ9ksjjiMPYoJtxdnF9MKbQvFddZld2c5Ee9lHu
         AUUl9SR1pUXuANVSqZG6XSfl92xkn0sGw6TljNfzh4QWDygXXwWxTu0CCM61s/EZOWTl
         btScX3GWFRVcXzTepMj0/TA6bYmRt8W+7Gn0+yefjQ8Nn4xyMz98arTq4a3OdQ9MFfzo
         UE8ZRMxSBD1ZBKJ9wVB4pQJG/XfiQBP2l3zjAL9jKClf9yiMOFzuyc6ybmZSHZD22Roz
         qBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795195919; x=1795800719;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1lx0wfNVXkVLhymhPDkbH3mU8AtjMWYu6LBXWtj8f/4=;
        b=Rm2AMBHp/j9RzjtKkVicTDT0dS+ZBTKJN+VXk/ofAgrGVAHRMIoNBekJVH1W40qpZ3
         BeS5ThEordvFRaG8NSPo4Tyw1vjh6tDumPR8D/8unnXm+z7Y/raSpS6QTOICnEgAYgsD
         rFcr4TbM7ZaUowxzpwzl3422TTHam+iV42u0cb3pMXdIOAHxHRRXzakGI36W4YeTXplb
         k703t0Y8glxvRLujwEGcYilnPXCGTH/XXG/ZOK60MMyQCSYLPTp26ZnxkI/DBdjWj5ar
         76L+Ou29Gnl/cruQbWDANutJNodK91QreFSAT4x92Brn72AhcugfaYjuKJGGyWZkIyMf
         GcYg==
X-Gm-Message-State: APuU4Z+R9+XFyP+JB2xNvZQUVHbfDVylbRpLTkCYJiV9vKCkQqKSsnO8
	yUJZkx1L42NO1Th7+ldmNwJFk+O6eTN3Ll865rIYycLhoj0OLNy79H3NsrdAaH8Fv4eIN4yy+SA
	nh/Sz
X-Gm-Gg: AZFdTZe96jd/LaVJsOwxVkBQ8VR+jVOBpKkxF8NPvERDULdq9MC8aShSvL6qtTv48i5
	+/22sh6X4ycDkyvYL3KSzGrjMxd4OsTPhX+rdY2qAavdTqCZZ+sn1l+dFAO9vBOMEwNiln/P4Z7
	963Nqm5boeYGGRdI33unn4IUKc3Uj/FxINfEN+hx9ZBys7CnvGbZ6nkez0YkhwXvA673DfYUSiL
	cvd85UklsKXXU4Ls49RPmy1iOcSSU2kgwF7hT/BBnHidgklArLq3SPzXnj+PSV0hFJMolab2LMJ
	RcY18Da5LwrubbTWyzkEkzxOh2MAsowUSClikybxqILqBr2oylf7fNiEwFw3PUI5WteI2zhy+eS
	KSj3cnzw9iCXDtSDiKeIHni7urSEdAALTzF3f60wJsTUxwm/6LXEnguedzG3kEq9KnsFohkquQa
	w9QtoQxg8cRz6+8OW13oJgT/VPwZaJA1aJO6grhxULYeBnJ+Zgi/7p8i/WB3XFc+bvMuTtId27v
	RPjbfmVERqfpE5qUEMTazksR8ixi6E/HBi+6uZgSG7bkfcn5Hav7JeOEtKsKC8ocy+FmHxxmSbL
	q2TNu0f0P8jpgoNK4hzEtEhx67jBdQLxfGzXbWtsIS1yWwubbs27Ewdrv9Encan2M+EZVOV+Cjg
	r70288MxkAYsK2jfbXL3H4zlh2QQrhIz1PI5n
X-Received: by 2002:a17:902:f642:b0:2ef:da10:bea3 with SMTP id d9443c01a7336-2f03f1cf4c1mr41222865ad.11.1795195919434;
        Fri, 20 Nov 2026 09:31:59 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f04eaffad5sm7422655ad.14.2026.11.20.09.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 09:31:59 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2] scsi: libiscsi_tcp: hold back_lock across the copy of a Data-In
Date: Sat, 21 Nov 2026 02:31:54 +0900
Message-ID: <20261120173154.3286585-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-225621@kernel.org>
References: <20261120163857.3238489-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-225621@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Nov 20, 2026 at 05:04:52PM +0000, sashiko-bot@kernel.org wrote:
> Can iscsi_tcp_hdr_dissect() aim tcp_conn->in.datain_task and
> tcp_conn->in.segment at a task that is not in ISCSI_TASK_RUNNING?
>
> In this tree, neither iscsi_itt_to_ctask() nor iscsi_tcp_hdr_dissect()
> checks task->state == ISCSI_TASK_RUNNING.

Same answer as on v1: this follows up on the v4 series, where 3/4 makes
iscsi_itt_to_ctask() refuse ISCSI_TASK_PENDING and ISCSI_TASK_FREE and
4/4 tests ISCSI_TASK_RUNNING in the Data-In arm.  On plain mainline the
PENDING case predates this patch.

> If the pending task on cxgbi is
> instead aborted or failed before cxgbi_conn_alloc_pdu() sets
> tcp_task->dd_data, cxgbi_cleanup_task() returns early without calling
> iscsi_tcp_cleanup_task(), leaving tcp_conn->in.datain_task dangling

That needs datain_task to point at a task that never went through
cxgbi_conn_alloc_pdu().  With the series above only a running task gets
there, and a task is marked running only after iscsi_prep_scsi_cmd_pdu()
has called ->alloc_pdu(), so cxgbi_cleanup_task() does reach
iscsi_tcp_cleanup_task() for it.

> Can dropping session->back_lock before segment->done() let
> iscsi_tcp_process_data_in() complete an aborted or reused task in the
> same slot?

Not something this patch changes.  iscsi_tcp_process_data_in() does not
touch the scatterlist, digest case included, and a status that races
with the error handler failing the same task behaves as it did before
this patch.  Answered in more detail on v1:
  https://lore.kernel.org/all/20261120163948.3238659-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
