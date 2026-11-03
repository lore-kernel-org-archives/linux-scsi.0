Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698709;
	b=zpjNeer2jPvKtQ/cbb5YhseAm3EBMASJz3yoPyjTLLS7IKZUIx+WPRIAecT5cYC7ryMy
	 r9P1gdpfz7uimhz8wFV5Pzyk38kpGH6QNnaxK8514UqX6O0fFF329B6PtEyhos4BOYsYj
	 KyGHOU9OjE2/emdC4pyhO2G63Qz2JCV8ZHMRQCnRaQ1hBfMc1jDHQfZOWe9LmonKEtwaj
	 vmkyTYNda4aM/bFCLSwJ7SZCufftdAdNNGcsEJCnx0ymTk/pmLQjGGTVbowGC2XeqNUL8
	 qSLDQTXqf9fPhaey2M01q4B4CYafjPrRs7sQB2p94u84qfy7QTlX/uewf8V/SKybGfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698709;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=KVy14myF4mRZ5Al3DN/5JiuYBIeU6oA6zQbK4opNW+c=;
	b=Jh2EkuVD0J6FA6XAZJWtNveMf3htsKlnBMPElH/JrpbV+dbKFqK+eagX5ne2OGVEWh4O
	 DKHJYW56uQ5aK+ocdUXLSAqx863rtfyAz7L5sXiUz16UHw7z5rKMJJm0WPJhODyhonuj/
	 xT9h2IymVl9uRuIqOUxxBF9fBLD4hr8lPaM35Lb8kS8VQ2DEzKbVCH3IkI+C13I1pG47l
	 1pI27wd7oqv74cmPpei0rdT/ZYMHHduvUPj7Syh4KSKCXSNSzobjd/QoS2s+FrG2eidXo
	 k/vRw3cxSi9Dvcz4Ysyss6c3nGUkINH2GdJNjJ68WIX/XrTKbBEQOi44arO9Lre41ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=py97u9mN;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD23606A326
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 09:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BD23606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=py97u9mN
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261103093826epoutp049b95d89faea80cd16b8aec63a108db0b~kf3hSS-mo1279812798epoutp04f
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 09:38:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261103093826epoutp049b95d89faea80cd16b8aec63a108db0b~kf3hSS-mo1279812798epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793698706;
	bh=KVy14myF4mRZ5Al3DN/5JiuYBIeU6oA6zQbK4opNW+c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=py97u9mNO6VBk7vjbRqfBvdtYo6uc8imEA2TTAB4bpUWjdFjwam4Fo3DL531GCjkI
	 9uXCHZBzdXlKzkpMHb6odhVmQ2V7ViRMySsluf9HJN2J6hXsmApQj8X/02ijGg7V5b
	 oOne+pFeZ1pZ1+n7tB5OtGbHCCWk7NlN5YE6z8TA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261103093826epcas2p255c10a6e087d5568f27af306550c57f0~kf3g-Pn670701907019epcas2p2V;
	Tue,  3 Nov 2026 09:38:26 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.211]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jJk5s4ybQz6B9m4; Tue,  3 Nov
	2026 09:38:25 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261103093825epcas2p3d741e7c61c82ea89cbd63299b853732d~kf3gN0RcN2578925789epcas2p3U;
	Tue,  3 Nov 2026 09:38:25 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103093825epsmtip1091e8620de6999e5bafe61133514c023~kf3gHwW5c0972309723epsmtip14;
	Tue,  3 Nov 2026 09:38:25 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Subject: Re: [PATCH v3 0/2] scsi: ufs: core: Avoid redundant link recovery
 during system resume
Date: Tue,  3 Nov 2026 18:33:58 +0900
Message-Id: <20261103093358.1835628-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1792989286.git.hy50.seo@samsung.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261103093825epcas2p3d741e7c61c82ea89cbd63299b853732d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103093825epcas2p3d741e7c61c82ea89cbd63299b853732d
References: <cover.1792989286.git.hy50.seo@samsung.com>
	<CGME20261103093825epcas2p3d741e7c61c82ea89cbd63299b853732d@epcas2p3.samsung.com>

Hi Bart, Peter, Stanley, Bean,

A gentle ping on this series. It fixes a small race during system
resume: if a LINERESET is reported and the hibern8 exit fails in
__ufshcd_wl_resume(), both ufshcd_err_handler() (through its early
pm_op_in_progress path) and __ufshcd_wl_resume() call
ufshcd_link_recovery(), and nothing serializes the two.

  1/2 makes ufshcd_link_recovery() clear the saved errors the way
      ufshcd_reset_and_restore() already does, so the error handler
      does not act on errors that have already been recovered.

  2/2 makes the error handler wait for host_sem instead of recovering
      the link early when hba->is_sys_suspended is set. The early path
      added by commit f966e02ae521 is kept for runtime PM, where
      host_sem is not held.

Since v2 only the commit message of 2/2 changed, following the Sashiko
review. Sashiko did not report any issues on v3.

Any review or comment would be appreciated, especially on 2/2 and the
system PM vs. runtime PM difference.

Thanks,
Hoyoung
