Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793286947;
	b=H1H/CgwgAIrgyURsLyzS5Rm2G1UmIn5FfQVSmmLKJYoJS5w6DObingztN0twk3vhXYxc
	 4I9ylCOtqFAzyx/0q4oFc4JegoiMPayGxZam9go2E4jeZSc+/TtSO9DFWUS3eQzsWyYZ6
	 INRQEtIt3lS9V+jjXq7MaBBWXIJNlHRL7/2OYxBBHeayWSJj+VzV1oskfabPAitzvzfyw
	 tnarJK2J/PipmQmCVmOHwZkqzf+zmBDA+drlJtYdMKrFpQtjOOiu0zOPMUiVwaePidZVJ
	 UYSotPacc0b8RZ98vCWHWn8hi1gXG0hDNYPy3DnshlhUXmGpBqIcz0P2JBrBFk+e4QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793286947;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=IPw0/BwW5p18oDLi2WLGpDus6SNGg/LLfcJaEGzwHNY=;
	b=37i6mKpDABKt2vNd/OWpG0ItRVmz+v6dfx1kv0mMqJvdKJH1+STtjJlNZPWGYCImt3J1
	 9Xg5lzsyiAXF79Y/Wbdg5xB2qvMwqAkyqRGdBIpn0jWElMQBZvHzp6mNF1+LOBXEgGI2S
	 FuKxg19VJGCvnojKvzHAfLxCN71m3n3r+rhKDlKuHhdG4gkOdUTrm7MT1wv1ZokUMTJWw
	 8+4vvfs7eg3PXlV70hKKO1N1hZKiaWQdzchywACfafoqRhG1NFZ5EfdmEoZ+5iHZWAcBl
	 X0xoTIUVqW95TwoFaRam73FWbEIxoyab+SK3UFcLtGw1UAUBEfWT5zUlHH6GHCIhfiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="YQyg/dT/";
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FB8606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 15:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57FB8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YQyg/dT/
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so4874845e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 08:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793286945; x=1793891745; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IPw0/BwW5p18oDLi2WLGpDus6SNGg/LLfcJaEGzwHNY=;
        b=YQyg/dT/ujL28wE43zB9C71dKTfJvrpo1KO7D/jy0jgZk57/H3YiRCfnPIdlEjtefB
         cm9TH64FFLTV7C6TnCMnOyD69bLOmwueKLUc9AfG/hzzZqbDa49UOJllTF0SoFzz151M
         robsLl7IiNBMSLdqR4zpZ6WtNnotbqIHkq8A78rrWjUChIlyzIAsrH5AWqD9i/bb5KrZ
         puWCXXX+R5t56iuBpzEJqbITqy6+NolpzxgqagrHv9//AyxV8xI7MhWEOdrhukzfEDVh
         asADL3kyxGxBlSuRdtn4HdxQ2oJR+jbVezVHz7O6CXgyBbRhjhFg4tPIioMJs5PuVTI8
         UrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793286945; x=1793891745;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IPw0/BwW5p18oDLi2WLGpDus6SNGg/LLfcJaEGzwHNY=;
        b=TTNSgDU+IWRatUQ+dEYo1CM0laEdKGndWDapzFZtgKqZIrJkKNQ9zO/9iDcUTwXizf
         7nNVZzx4zEfKMi8rZ42dbccTFRjVRcExHM2Bo7VtatisXybzQ5aNxW+uYk8+F/6wlBqW
         BrkeTf6wHL6b5DBWlvmjFzHqYJaPD3wqaNyYfd+LWiYA7jSwSTR2w+W6PzkErcZE46Ct
         FPEefgC4dgIgcgLWwgyfXBG+LzP6RucWC8Tmu+Q4ioEHl6jskqZTAPtfaUfYlSxAXKl/
         fqngXtggpTyoycBVVkkCk3CJ3FUG3jG6jNI2hp/SUSWozY5hHikzrKrK9dhobnj30New
         fRVA==
X-Forwarded-Encrypted: i=1; AKwUvByHpzpsTEsdinvs4rSyA6w2Bl6DW2Z6geYiss6kWvDPfdx/dlNeyDLa6al3UW6ZfANTfpHhegiHYgXC@vger.kernel.org
X-Gm-Message-State: AFq9FYIHCEa60lSnbivkN7W5u2USk6GaCp2XnMiKEKWzD/oVVzNpBJFc
	tjUUaf2phkccKyv2xrEhSdU3aHror/+y3Ki4VBodNBYgcLklfJiZsTDj
X-Gm-Gg: AYBFou0efAEK5n2HJbPfLxhwxKOMH/hXy6zn7R0dsoHIJEDxn64SQYwzdQx2UCf6C+O
	BRKefe5eS98Mgv9j1VWxQIihJk9mdoyc6N95jNi8fCAj8evGlAS9j1CaRObknwmty5Jgj8TNPhb
	OLcddz3UB7kOkM+oFFbn46HfGOSd7GX5oUzNPn0FTC54IeSsPtdiASeIuGFtqoMa2J6+5JKU+6n
	MZJtl8DVc267Aqan+wFJUI5iCxCMkVQM3YJP0RntZXOwVJtttdpjwwhSxhzcjoS6tbIMYIyRS4f
	ikgMmalv4RYSFhvt4oMAi9D7K6SlqrSsriOnC/cRh0SayVwQkBTUto2PzeQDeiroC1weize4+zJ
	D8YEqKCiS/K5tHfOeWN2eNOAFkOkkgnCWMrn1PqYcNt6DADKGEIRnCO8ecWeESZvtc7K71TDAZA
	lPPLi56ccrq+oEQc7ZauHq0Xw4nuTr05UC7P0p/FEhxRsZZaCytVd6EoJFmHtqLQ7y8eHqL0MJd
	KtjCDSqyc4Yqsb17Q3Z9+eq4VsfXRovgDgdXU8t5zGBjt+B8Q4frRigJ1mz9CWx0AMPCjkQvizA
	UiLv40W5R7z4yP53tJT0NXOdHonJoEcAzbywfLajPc76n5mw0pV94r5uR6LINuGaGXqnDVxUoho
	eWYc+
X-Received: by 2002:a05:600c:3e15:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4aa871e8bc9mr81472915e9.6.1793286944585;
        Thu, 29 Oct 2026 08:15:44 -0700 (PDT)
Received: from ?IPV6:2a02:810d:7e03:5f00:f9b7:8364:5700:ca7c? ([2a02:810d:7e03:5f00:f9b7:8364:5700:ca7c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a966a56abesm88595065e9.0.2026.10.29.08.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:15:41 -0700 (PDT)
Message-ID: <57e4f2c2-d692-4130-835f-e507574c7252@gmail.com>
Date: Thu, 29 Oct 2026 16:15:40 +0100
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
Subject: Re: [PATCH] scsi: target: tcmu: Fix divide-by-zero in
 data_pages_per_blk store
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org
Cc: michael.christie@oracle.com, bvanassche@acm.org,
 linux-kernel@vger.kernel.org
References: <20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn>
Content-Language: en-US, de-DE
From: =?UTF-8?B?Qm9kbyBTdHLDtsOfZXI=?= <bostroesser@gmail.com>
In-Reply-To: <20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/10/2026 12:52, shao.mingyin@zte.com.cn wrote:

> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> tcmu_set_data_pages_per_blk() only validates the upper bound of the value
> parsed from data_pages_per_blk=. Zero passes that check and is then used
> as the divisor when computing udev->max_blocks:
>
>    divide error: 0000 [#1] SMP
>    ...
>    tcmu_set_data_pages_per_blk
>    tcmu_configure_device
>
> Reject non-positive values, as the neighbouring max_data_area_mb and
> cmd_ring_size setters already do.
>
> Fixes: 08976cb548d6 ("scsi: target: tcmu: Make data_pages_per_blk changeable via configfs")
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> Cc: stable@vger.kernel.org
> ---
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 425ad1246a75..07b514678176 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2524,6 +2524,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
>   		return ret;
>   	}
>
> +	if (val <= 0) {
> +		pr_err("Invalid data_pages_per_blk %d.\n", val);
> +		return -EINVAL;
> +	}
> +
>   	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
>   		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
>   		       val, udev->data_area_mb,

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>

Thank you.

Regards,
Bodo Stroesser

