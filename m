Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793842115;
	b=f9UdtXhqO8FQofk8aHamX+sZWzjqG68JvLVvJPY0FmFlV+J3YVeXCZ2YzLmZ1bZdWEtm
	 w6Dbhkh4X+MP7ix1u+i5dSEyoapo559ZsMIYPotdYA8SZDmrmf2xD5yxIJ5+XR46YKawC
	 xKFa5KKJr/vA3NiKhPohDWQbTAVhjtO4CLSH1P12Pvy93TTj1CqbgAWcFh0eIchGvP/cd
	 De15p7WfcckncEKKtwOurRimKmh6vTD2i0y+JcOMjuxmJLytQHBRsI+xz1XT8DBDhVHkg
	 U8A7wHlbcUwcpKKNfJ0klGaZC9pRm7fYfNABquNlcw/E0BWmcIjVgNMpmFrs/FPLVxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793842115;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=L9os5oOdoYpgwiqr1cRYqGlrpfZu4wWZxFxY1oxrqDo=;
	b=T2BU7/B/Id6G1i5bQXgkhHM99WtgBvih9PxIJHQDJy3GLJOHJhGdvgPqAD5SODbMKfXV
	 f74KKbewzk9sXkV3mWYvCA6/JzfulEXemP6h7Sgg8BWvBLgwKmyVIAA2EQJzgmX+fil3Y
	 zJK41wE7p68AFWExuKWmTCtUtti8R9TM6rvRIvjCmZyLJsE06PqD50CMyu6okJQ/fmqtR
	 AsG7tmkTYO4V/HlhhHUixwyVe7dXkm11HZ5Ti5s4cCIW8vZZsG0J+WNZcfpkx97jPVg4M
	 9SISapDMZZJo7RggagwWbgFUJpVciH3CtAVAHUMC0eXh5d4RbQeRAMBzhV9ORrcKTbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=G6aLBDom;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672EB606A31B;
	Thu,  5 Nov 2026 01:28:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 672EB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=G6aLBDom
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jKl7j0XFZzlkvPc;
	Thu,  5 Nov 2026 01:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793842110; x=1796434111; bh=L9os5oOdoYpgwiqr1cRYqGlr
	pfZu4wWZxFxY1oxrqDo=; b=G6aLBDomwJHiDHVbtHnzXG9vsdeey3+jSM6Vx17j
	PBGyH2T6p36C0QuV0adHkddtDKt07SXEbUkHek2NPDwj2VPE5bjskhshcxgJwjaO
	ZqSrgeUYTdM9T4ZZRSTQJ7I23wgW8CpipaH8AojgaAnJSyaRkx5bH7Oi8n8PJxKx
	ZdyAGMQMNRrHfN8IpnaPrUHefmE+sl10kHBvLcwWSSkZFxfP1rk3TrPsKgzsq8Z/
	Xslyvtdwf6y36PQY1xyAin3qSZ96mFXl6cR81JKgvBND1/0ybGKdJp/URqShoM+7
	mEVqyXWLF0HXj9zWLwqI6NcI7d1b8PDO+h3UKYmOhkucyw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jGOvxbWGXOTy; Thu,  5 Nov 2026 01:28:30 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jKl7d719KzlktnW;
	Thu,  5 Nov 2026 01:28:29 +0000 (UTC)
Message-ID: <8446dc27-9518-4b0c-b9e9-116458210616@acm.org>
Date: Wed, 4 Nov 2026 17:28:28 -0800
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
Subject: Re: [PATCH v6 1/2] ufs: core: skip ABORT TASK for device management
 commands
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, kwangwon.min@samsung.com, hy50.seo@samsung.com,
 cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com,
 Bean Huo <beanhuo@micron.com>
References: <20261105004333.1097899-1-kwmad.kim@samsung.com>
 <CGME20261105004352epcas2p307ea40aadb636015545cee6e79470a03@epcas2p3.samsung.com>
 <20261105004333.1097899-2-kwmad.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261105004333.1097899-2-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 4:43 PM, Kiwoong Kim wrote:
 > @@ -8046,6 +8046,9 @@ int ufshcd_try_to_abort_task(struct ufs_hba 
*hba, int tag)
 >
 >  	lrbp = scsi_cmd_priv(cmd);
 >
 > +	if (!ufshcd_is_scsi_cmd(cmd))
 > +		goto clear_cmd;
 > +

ufshcd_abort() already has the following code for the SDB path:

	if (blk_mq_is_reserved_rq(rq))
		err = ufshcd_clear_cmd(hba, tag);
	else
		err = ufshcd_try_to_abort_task(hba, tag);

and ufshcd_abort_one() skips reserved requests. Hence, ufshcd_mcq_abort()
is the only caller that can pass a device management command to
ufshcd_try_to_abort_task(). Please handle this the same way for both
paths. Either add the check in ufshcd_mcq_abort(), similar to the SDB
path, or keep it in ufshcd_try_to_abort_task() and remove the now
redundant check from ufshcd_abort().

If the check stays in ufshcd_try_to_abort_task(), please also update
its kernel-doc header. That header says that UFS_QUERY_TASK and
UFS_ABORT_TASK are sent unconditionally.

 > Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to 
scsi_get_internal_cmd()")
 > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
 > Reviewed-by: Bean Huo <beanhuo@micron.com>
 > Reported-by: Bart Van Assche <bvanassche@acm.org>

Please move the Reported-by: tag above the Signed-off-by: tag.
checkpatch also expects a Closes: tag after Reported-by:.

Thanks,

Bart.
