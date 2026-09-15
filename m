Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F97040F721;
	Tue, 15 Sep 2026 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484359; cv=none; b=YK06Q5WgQ4ezyFDjL++y7CKCfQFe0tvKaHjhNSD1PC3NFvYgXyD487h6s1pTqa7JE9+t4ZhV8zggGnlYWembEa7yCiHlBQooFrpwk7w18r7dQsJkV7WdHEg715+v/FLifZls/Y+WO7SvgZjUZewOnFwamm0XWT43gk1ESPd0fWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484359; c=relaxed/simple;
	bh=6A3fkvOVypHAQY7yZaA3BvO93uUwC3FmlQIuT+LFEX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ajTi/lGlwHlBun5GxGWo2SlDqj2mRDYgs7KzyB1CF1gsoRyf4k6daoBwVkpEfiPYNA+vEybNofDBLiuMPmwIYo9MYeXdjKa3BvfAdsZXhOHEFCZ0W1BOT1qv+jNxLtZOXRyc4e6TDUSvOoBGrlluPQf5VdbIrGbureWv/ZPHl8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=radxa.com; spf=pass smtp.mailfrom=radxa.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=radxa.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=radxa.com
X-QQ-mid: esmtpsz17t1789484284tfacfe6c7
X-QQ-Originating-IP: W7YKFDwrm1wCk8E2F4UksRhNvAEgugBiA1YE/17EEbY=
Received: from [127.0.0.1] ( [180.159.160.209])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Sep 2026 22:58:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 4487614015071532080
Message-ID: <B6ED6CADE807138B+422dda6a-301a-4bd1-befd-b932ea9f46e0@radxa.com>
Date: Tue, 15 Sep 2026 22:58:00 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sophon@radxa.com
Subject: Re: [PATCH] scsi: ufs: core: Disable timestamp for Kioxia
 THGJFJT2T85BAT0A
To: Stanley Jhu <stanleyjhu@google.com>, Alim Akhtar
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260910-kioxia-ufs4-fix-v1-1-ac796423057a@radxa.com>
 <CAE14pddvwycWnGNd_VNTzphsDTk+XbYwf6BDFkBnQFaw9hm7+w@mail.gmail.com>
Content-Language: en-US
From: Xilin Wu <sophon@radxa.com>
Organization: Radxa Computer (Shenzhen) Co., Ltd
In-Reply-To: <CAE14pddvwycWnGNd_VNTzphsDTk+XbYwf6BDFkBnQFaw9hm7+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:radxa.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: OBUGnm9pFasA9Qomm9LNLNVyhTAsyuSIChuX/f1HO4f0IWmi5l3SPs49
	9U41tJkZrXygF5RuVZGprRpWkB6Sj1lz0TSi2Pp6pqQgcaZ3cI8zB9cJnv2oatoO1dHc6xR
	AjhO4ZzRCecjkqSG/RUHGx+RCgQJA+K19KDkQOGTf4mZr461d9Yprz2aj2q6vedw182OzhZ
	OS0A227jgJ2/oSKFeEhp3emH0dF+eZJyy8JCctVtegRBq7HI+7qs8Ilr76eY/LsW8JTxcAj
	La2RIC2ySnzuyzPmROtLookXcPQGOB9WbdMeLZkgV1MKuT1rlQ6/DDrmqdSnBLxz1PKzWhm
	goONAZuQG5sqoXffI/BtnmffHtZcN3T+FkuWfNAwyNRmkZv2zXdK71j8uGTxx1g3RuaBP7b
	48tsGZPbsZQ8gULE/3/P8kAX44HmxUEHBOYZnlGGS3oS2wOGAPhRb5Axck5/B+XQxy8eAFK
	rmxJDgSCtq5x3bRp8d4BxiN23FnvYbeTcRSLg3pSHHCJRUWXkWMAP/b8GTvZ71n5mATGh5J
	2Zpxlhzi17gdKFGmLmlAbqIBGYoi3nlkeFM7SbRChCPgJvArykXu3Ia+t9hWbv21IP75ovt
	DeW53p4WRcmNMkz52CsLWJcY/y3ZLICv+aoX+HUzoiiK6nNaNVY2GaSlbc7fGFCXGEjXGee
	1bMmvI+mHzMcuuoGq8aiosmTvz1sBRp8zC9vabiwG6YnYHOcP8fJTRNN7w4vGHiyMm6qpgG
	WQwLhmPF5Q6Pi2avGActHfPC2IJLGUDbjj1fkCMDL/1TKG4tGwnqJmfsENd93pDj8kEg7eA
	XOXbr3YyVLchi1AUyYMLB9YvR6FQ1lKM97x0sq0CbIjvqPsE2oKgL6xA9J7lrJ6kvxVO9Cd
	jMIWMtBuzkw/VqN7ztO04MxQXsty9L0/nqyfeGLLoc3lr2+t9BQU93tgvuqMWc+Y0pDWyUs
	eosZIgLsgol3FnqzhQdnuDnDUspaQIX2ZyYDBtwG9fvIr/vmsCeb09tXGLCI6DFIsfMYEGQ
	5OCo84TO++YW4Z0nWAtYnkw57s/Lm0B+NsM4Qy5w==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

On 9/11/2026 11:07 AM, Stanley Jhu wrote:
> Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
> 
>> ufshcd_dev_cmd_completion: unexpected response in Query RSP: fd
> 
> 0xFD is QUERY_RESULT_INVALID_IDN. JESD220F has a device answer that
> when an optional IDN is not implemented, so the device is declining
> qTimestamp rather than failing on it, and the condition can be
> recognised at runtime instead of by model. This is the third model
> needing an entry for the quirk.
> 
> I have sent a series that decodes 0xFD as -EOPNOTSUPP and disables the
> timestamp write on that basis:
> 
>    https://lore.kernel.org/linux-scsi/20260911024319.1346706-1-stanleyjhu@google.com/
> 
> It does not conflict with this patch; the quirk still skips the first
> query. If the part is handy, could you try the series without your
> quirk entry and check whether the errors stop? I have no such device
> here.
> 
> Thanks,
> Stanley
> 

Thanks for the series. It does make the error disappear.

-- 
Best regards,
Xilin Wu <sophon@radxa.com>
