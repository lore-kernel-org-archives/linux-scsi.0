Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795546048;
	b=k1AIlD8K8ZdcZghS8ka8m6uESqe7xXDQexM7mc+9sME++boqWdFnlr+8NooeTqYlIrth
	 NsH6zIkvJsFeqOWX6BlAeOI+fq4gsjaDXQiaCZsN/y0iTH/7+Dp1HwwdTnCV4Ij/gxjHi
	 2kXJetnmZOLApv2esOYO7kJilybrVJAZKnP5L4zfTY30dt0vyKWz9S/I6Qfs9Qm8a74Ve
	 tVguhNmTvjq/pVCGo9mca0CUukE3RiN31Nle4Z/sl9HJE2yCfOQVeoAYvSG6iBF1Amolj
	 ddfC+TOeHLAPhtUAoHoWy0QUBuivxwLFKta4i3vf4W7wUqkLdYf9eX9HHH+/qaUqabQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795546048;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=pxqaOIl3y8m+NcD9JxB0/2XOKtk2qG69zXikgpiO/6s=;
	b=AQaD+CKhZtOwtve+vOP/JQdIwxwM+D+2+Z6IKHtdk4VH2CMuNkFIzonWQwjJYjTMn1mo
	 ulA9T7LVh+aNS5QVKRCezt6TvRDnOqB2MWZZcjY+8pmwbCGSe/VUy3S2RxKQZcS9ZKHfe
	 7HiXYgVW05kAFeIvDS7acsVCuWEekG1FECwViDOxEP3QRgsuSqRWmM0pqVNH0w1KftUmR
	 FF4j10ayJag6MxHKioWCKOUvKOef0RHTpR81xUAODWgfYSJIPtCY4cV2UO5PFAOp5o1Us
	 qicwd36oVJ8Hdso8Iyod3zIGBbcX6s3LIVB17Ojfy+6iCpK+r3XJN+7sdDFFpNDzfBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=3Wst0cvj;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E160C606A32A;
	Tue, 24 Nov 2026 18:47:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E160C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=3Wst0cvj
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jYsHg2vfBzllB6K;
	Tue, 24 Nov 2026 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795546042; x=1798138043; bh=pxqaOIl3y8m+NcD9JxB0/2XO
	Ktk2qG69zXikgpiO/6s=; b=3Wst0cvjNuA8A+j92CbKfbrkasPXQg+jYq4wfIvZ
	mfcOIbXqO87ADaog31kZkYeDThwkaIH6qy5mJ+R1cIn4I+OBNujw0xdY4EkanRfd
	V/bZvC92EdF0uXu14MZ5rJOLMSs7hoJAp7E02QbiEg4lDq6JZKhfzU3C0C7z7Phe
	hZg6xJ8+6qEPEJb5EvOrqZft+27v7eEsrGpVy99ExRGDngLXXmx9Iyjdmhd2wNyQ
	d7aVsb7ZdWJiunz3FM+yKda8N70R8FMT5mt5Th1wtwxwbKpYTX7ssaETkbyGQ1Rx
	Bi5fnGbscW/mCTDn6B/dG2smbq2/foibJ4krnZUWR6MCAQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uE7rlzqzQucy; Tue, 24 Nov 2026 18:47:22 +0000 (UTC)
Received: from [100.80.227.185] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jYsHY3B22zlpHx2;
	Tue, 24 Nov 2026 18:47:21 +0000 (UTC)
Message-ID: <8413e7bc-f647-40ab-9633-0515863f3dd4@acm.org>
Date: Tue, 24 Nov 2026 10:47:19 -0800
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
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Add debugfs for PA TFS/FEC error
 counters
To: Po-Wen Kao <powenkao@google.com>, linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>, Peter Wang
 <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, John Garry <john.garry@linux.dev>,
 Li Qiang <liqiang01@kylinos.cn>
References: <20261124012951.3143833-1-powenkao@google.com>
 <20261124012951.3143833-3-powenkao@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261124012951.3143833-3-powenkao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/26 5:29 PM, Po-Wen Kao wrote:
 > +static int ufs_pa_err_read_rec_cnt(struct ufs_hba *hba, u8 peer, u64 
*val)
 > +{
 > +	u32 hi_before, lo, hi_after;
 > +	int err, retry;
 > +
 > +	for (retry = 0; retry < UFS_PA_ERR_REC_READ_RETRIES; retry++) {

Does the UniPro v3.0 specification define whether or not reading
PA_TFS_RecErrorCountL latches PA_TFS_RecErrorCountH? If it does, this
retry loop is not necessary. If it doesn't, please mention this in a
source code comment.

 > +	/*
 > +	 * Per MIPI UniPro v3.0 Section 5.6.7, setting PA_TFS_RecErrorCountL
 > +	 * clears the entire 64-bit PA_TFS_RecErrorCount counter to 0.
 > +	 */
 > +	err = ufshcd_dme_set_attr(hba, UIC_ARG_MIB(attr->mib_attr),
 > +				  ATTR_SET_NOR, 0, attr->peer);

This comment only applies to one of the four attributes while the code
below it applies to all attributes. Please make that clear in the
comment.

 > +static const struct ufs_pa_err_attr ufs_host_pa_err_attrs[] = {
 > +	{ "fec_err_cnt", PA_TFS_FECERRORCOUNT, DME_LOCAL },
 > +	{ "crc_err_cnt", PA_TFS_CRCERRORCOUNT, DME_LOCAL },
 > +	{ "format_err_cnt", PA_TFS_FORMATERRORCOUNT, DME_LOCAL },
 > +	{ "recovered_fec_symbols", PA_TFS_RECERRORCOUNTL, DME_LOCAL },
 > +	{ }
 > +};
 > +
 > +static const struct ufs_pa_err_attr ufs_dev_pa_err_attrs[] = {
 > +	{ "fec_err_cnt", PA_TFS_FECERRORCOUNT, DME_PEER },
 > +	{ "crc_err_cnt", PA_TFS_CRCERRORCOUNT, DME_PEER },
 > +	{ "format_err_cnt", PA_TFS_FORMATERRORCOUNT, DME_PEER },
 > +	{ "recovered_fec_symbols", PA_TFS_RECERRORCOUNTL, DME_PEER },
 > +	{ }
 > +};

These two arrays only differ in the value of the .peer member. Has it
been considered to use a single array?

 > +static void ufs_debugfs_pa_err_create_dir(struct ufs_hba *hba,
 > +					  struct dentry *parent,
 > +					  const char *name,
 > +					  const struct ufs_pa_err_attr *attrs)
 > +{
 > +	const struct ufs_pa_err_attr *pa_attr;
 > +	struct dentry *sub_dir;
 > +
 > +	sub_dir = debugfs_create_dir(name, parent);
 > +	if (IS_ERR_OR_NULL(sub_dir))
 > +		return;
 > +
 > +	d_inode(sub_dir)->i_private = hba;

The comment above hba_from_file() says that @file corresponds to a
debugfs attribute in directory hba->debugfs_root. That comment is no
longer accurate. Please update it.

 > +static void ufs_debugfs_pa_err_init(struct ufs_hba *hba)
 > +{
 > +	bool host_sup = hba->ufs_version >= ufshci_version(5, 0);
 > +	bool dev_sup = hba->dev_info.wspecversion >= 0x500;

The PA_TFS_* attributes are UniPro attributes. Has it been considered
to check the UniPro version (PA_LOCALVERINFO and PA_REMOTEVERINFO)
instead of the UFSHCI version and wSpecVersion? That would require
adding a UFS_UNIPRO_VER_3_0 constant in include/ufs/unipro.h.

Thanks,

Bart.
