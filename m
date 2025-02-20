Received: from 001.mia.mailroute.net (001.mia.mailroute.net [199.89.3.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBDD1CEADB;
	Thu, 20 Feb 2025 18:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740076218; cv=none; b=o8Qzh1abLl7e5llK3f2MTn/w5lgAFayJOE3Kev6r6C1D68U/1slP9cwOtavqjlpXV8RrP1VfPeOEmayQtbL2UOhy3iJpaIAkLKzUexY7AUvawdMNEDxNC1icY9mLjg5MlX5V8xSb4/Uf+QlR2UusQDMnetlXto5CW7j+gQmqcoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740076218; c=relaxed/simple;
	bh=UtW3BbYcHewIriI87i7aJj+75+ue5txW9A63FG5qeNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jCqN9WAIKrSyJHv2Xtw2DpDk+X7CRQDgMe/evEtjAMehldd4M+22+I1lB2UhmbLP+PvuK0xSxUEUT6MC9ZOikvkFayAgzjQ9WauG+yZj/7h+Sg1v6nIg9W8PGXtSd/tJzBHO84PwZquuYGTqApTpRBT9ahtVMllUiTrUmNtbpIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aAM/MZ02; arc=none smtp.client-ip=199.89.3.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aAM/MZ02"
Received: from localhost (localhost [127.0.0.1])
	by 001.mia.mailroute.net (Postfix) with ESMTP id 4YzMJ068Fpz1Xb87R;
	Thu, 20 Feb 2025 18:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740076206; x=1742668207; bh=Co9r2t88YTUANtBpkO3mV3lh
	1eJwPtplBuWUuGhsPwg=; b=aAM/MZ02V8aK90aDtdiFxJr29a7PAhly0O++Juw9
	46fDsyB9oBSh0nxWqq3ZXYZJHNV6Gor1BJSb7GeflBU9sdZSUsBy6OX14LY0K1Jd
	6sFbBh1uLU1O2f01H5hawR2ibKm9pbAHwofoZwpIcy0PwiXYq69p0T4Qpt0nGcmV
	6Nzjovh7DZK1KWswsFWqcQrRyWyj8i6JfQSfgBtQIIqHD7yBUGkNL6RgcGRROMok
	VRiPmN1FYHN7d9fNVQts2uKPkQ2ucoDQIdZORjINc51m/C6NwWf6ki+yWayfg28r
	OweDQZXL8PQ+bp9JAS7do58hiqgXYKpaA+/VCuqNW2I0Bw==
X-Virus-Scanned: by MailRoute
Received: from 001.mia.mailroute.net ([127.0.0.1])
 by localhost (001.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 23RpagGbZVNW; Thu, 20 Feb 2025 18:30:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 001.mia.mailroute.net (Postfix) with ESMTPSA id 4YzMHg72Brz1Xb87P;
	Thu, 20 Feb 2025 18:29:50 +0000 (UTC)
Message-ID: <f4ad0222-d08b-4a57-8c8c-569fbe50f63a@acm.org>
Date: Thu, 20 Feb 2025 10:29:48 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 1/1] scsi: ufs: core: Add device level exeption support
To: Avri Altman <Avri.Altman@sandisk.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Keoseong Park <keosung.park@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Gwendal Grignou <gwendal@chromium.org>,
 Andrew Halaney <ahalaney@redhat.com>, Eric Biggers <ebiggers@google.com>,
 open list <linux-kernel@vger.kernel.org>
References: <fdebf652abb4734d37f957062a2b4568754db374.1740016268.git.quic_nguyenb@quicinc.com>
 <PH7PR16MB61967197DC9C471F95536229E5C42@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB61967197DC9C471F95536229E5C42@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/25 2:01 AM, Avri Altman wrote:
>> @@ -419,6 +421,7 @@ enum {
>>   	MASK_EE_TOO_LOW_TEMP		= BIT(4),
>>   	MASK_EE_WRITEBOOSTER_EVENT	= BIT(5),
>>   	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
>> +	MASK_EE_DEV_LVL_EXCEPTION	= BIT(7),
>>   };
 >
> I think you need to rebase your work - most probably for-next is best.

Hmm ... I think that Martin expects this kernel branch to be used as
basis for SCSI kernel patches intended for the next merge window:

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=staging

Thanks,

Bart.
