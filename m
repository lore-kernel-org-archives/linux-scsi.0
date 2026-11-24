Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795545008;
	b=tpkPIkrkLxldG91ARFXhOWQpglhC/Ox/sycqpxxdBKbRJ6ARWBm8KVhiWhwW+MwPdUrk
	 kt9QPCBbFGEN9ikUJysXqvsMu2Ub0kY4xIQOclk55QXJvqbNUVw9vZY+ERKdpG2ep0MzE
	 s08WKDv9ko77fDr7eo1TGs+2mbW95V7yssV5ooU6Y8lnGTf4NiGv3BNV3UJumGjS1DfHF
	 LaRLFGxTFy58ta7xdOugUCuf6Am9N51Qxixmx0Lby73VAR3Hm+ioXaLtKODE8IKAtF070
	 MVpIpx5Sdaiqi4y9NwXKafHahYjxR60/HcKVuJ8H9L4HSiWdq547SFYFzf3YqBCkqzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795545008;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YnWuN+9P4kv0dA1kgDgkRqXu7Fw8rxytZA5FxjoyzUI=;
	b=bMmpPTR5EgPLa8eCoGXLYYNFIrjxMxkb7PAo7BdwynuVlCnabOF1E8cxBNEMwghH2Cln
	 36wOjei6KMQqH8sZVf1+Tg+zOHUblljy9plGXibZ1ifaeoVxz7FIvQc4N3Cy5y/q4L9n9
	 o8bbjx0uQSL3Ik2HHByt+DbuH2z+78qj5ExUOXR6OTBau8ipwyaHTUuwG1hjEm7G3Rdwa
	 QTNvk3zM7ovSfYT0U7JVYzkGndU9Va/gJhCmEKXVeVxhnG4nLRgHd6374gL2xQj+sJUMh
	 q2AQmFqK0zyg81Sc8GOyyWWGwZmdnCV8e+1o1W6ITCUPQwg1UUURRqDsi0Rtq32Yzfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Fy75rdwV;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643F8606A327;
	Tue, 24 Nov 2026 18:30:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 643F8606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Fy75rdwV
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jYrvg5NRnz1XM6JG;
	Tue, 24 Nov 2026 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795545003; x=1798137004; bh=YnWuN+9P4kv0dA1kgDgkRqXu
	7Fw8rxytZA5FxjoyzUI=; b=Fy75rdwVu4czCawpvwmQ6uq/Ibz/ZAjaFYimWiKF
	Gl1HDujaVTeSb9CjGxynvtaCnufl4YIrIrbR3lbeeRXwviLuQ5GrCWxUqaeNi7KI
	4fc9FsfTb4Q/LtUWgUm3XVRnVyEf6C/O+nuMaWdtbKem2ukPtIMzMMt5ULP4K5Gv
	VzSpE8sTtZTntIaSkdpMaqz4JQ9gmi2aCbx+OnPz4UJbMlrwQC12KmbdC8MXZNMV
	iUQ6gGRhADKH2ryygiRHL2v5YAVpnkA9EpNQEU+4+EPS8h75C1e8AvbzfGW8c3bU
	0+6FgOt9SxkhrepJHH47JdCqqRxvQxOdD5YIS8wP0LHMbQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id puXwS_9fS0zJ; Tue, 24 Nov 2026 18:30:03 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:b87d:aea9:8f72:a6cd] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jYrvb5FMRz1XMYJH;
	Tue, 24 Nov 2026 18:30:03 +0000 (UTC)
Message-ID: <187cbe4e-2efb-47dd-8b0c-0c433b05b3d6@acm.org>
Date: Tue, 24 Nov 2026 10:30:03 -0800
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
Subject: Re: [PATCH v4] ufs: sysfs: Add WB partial flush mode support
To: Daniel Lee <chullee@google.com>, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@sandisk.com, tanghuan@vivo.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261117004729.635562-1-chullee@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261117004729.635562-1-chullee@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/26 4:47 PM, Daniel Lee wrote:
 > Introduce UFS_ATTRIBUTE_RW and UFS_FLAG_RW to support writable attributes
 > and flags.

Thank you for having addressed my v3 comments. Please split this patch
into a series: (1) convert the UFS_FLAG() / UFS_ATTRIBUTE() bodies into
helper functions without changing behavior, (2) introduce
UFS_ATTRIBUTE_RW() and UFS_FLAG_RW() and (3) add the partial flush mode
attributes and flag.

That will make both reviewing and bisecting easier.

 > +	ufshcd_rpm_put_sync(hba);
 > +	if (ret > 0)
 > +		ret = -EINVAL;
 > +	if (ret)
 > +		goto out;

This changes the error code reported to user space for all existing
flag and attribute sysfs entries: negative error codes are now passed
through instead of being converted into -EINVAL. I'm fine with this
change but please move it into a separate patch and explain it in the
patch description.

 > +static bool ufshcd_is_wb_pinned_pfm_supported(struct ufs_hba *hba)
 > +{
 > +	return ufshcd_is_wb_allowed(hba) &&
 > +	       hba->dev_info.b_presrv_uspc_en &&
 > +	       (hba->dev_info.ext_wb_sup & UFS_DEV_WB_PINNED_PFM);
 > +}

Why does pinned mode require bWriteBoosterBufferPreserveUserSpaceEn
while FIFO mode doesn't? Please add a comment that refers to the
relevant section of JESD220G.

 > +/* Possible values for bWriteBoosterBufferPartialFlushMode */
 > +enum wb_partial_flush_mode {
 > +	WB_PARTIAL_FLUSH_NONE		= 0,
 > +	WB_PARTIAL_FLUSH_FIFO		= 1,
 > +	WB_PARTIAL_FLUSH_PINNED		= 2,
 > +	NUM_WB_PARTIAL_FLUSH_MODES	= 3,
 >  };

Please leave NUM_WB_PARTIAL_FLUSH_MODES out of this enum since the
enum documents values defined by the UFS standard. Using
ARRAY_SIZE(wb_partial_flush_modes) in ufs-sysfs.c instead should be
sufficient.

 > +	mode = sysfs_match_string(wb_partial_flush_modes, buf);
 > +	if (mode < 0)
 > +		return -EINVAL;
 > +
 > +	switch (mode) {
[ ... ]
 > +	default:
 > +		return -EINVAL;
 > +	}

The default case is unreachable because sysfs_match_string() only
returns valid indexes into wb_partial_flush_modes[].

 > +		Buffer.
 > +		The attribute is read only.

Please use "read-only" consistently in the new ABI entries.

Thanks,

Bart.
