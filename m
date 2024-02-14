Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11161DDC1;
	Wed, 14 Feb 2024 21:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707946890; cv=none; b=Cis0y71KfbZLvN3/g+8IB31AlDKqPwJHKCqy+tNfcfMF4JSSa/NpfLpK5yHAvqiaFoEaiP+U5Ca+K3wbOLiZFQfHaSULY1dttDFSSnDJoIOJ9JiW8exAFwhS9pcZGtfl3J+pT/0TxydOz/JaFM0BppZVrZRG3snvq7pFwmzvyTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707946890; c=relaxed/simple;
	bh=USAMHb5Lc3KHzMNKyog7LxDBXuChMu/TA0N3FfeNrx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BWVpdzGKrEBT9ky7TGPUIKJlxkpm/wY0SwijFtxdWs1p/7/ZxZ/rMZCtmxgjb23lAuh4Bs/2sJPqYQC57SqG4PEmZ8mf+jU7dH7/0SURHle0q01t1UG3Mkf44X25eTJagWdJLXSB9TxoIpAmHpRlyQiK50nVd9rlOZTKftsqvIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e0cc8d740cso212680b3a.3;
        Wed, 14 Feb 2024 13:41:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707946888; x=1708551688;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UdZGCyYcbUt1nHuI1BHrCvgXmwb2NwTzncbFWjfEht8=;
        b=r8D1B0LyXnv3dDMKDPxs+kX+ICZaWg2PiFkZmDMVi2TPBB5SkapwbKD+UpQBt/2SUm
         p+6wfpMZK/x5ln4VwWoXF+wG4kLPMqvmbPTdGcbk7m9SWLePo8egDy0VOXdUgCcXZYcS
         bR2Du9ir41Cdj27zbzD5JP7IkTdvBIUd8iJ+ZJyMVOXHijrZ5L+VNmR448HvhDkpSNFp
         dB4o2gsfQt4DepZD7EVBDq5Fb2duH9ADqCYak+DmmAflyD2kgSGgcJJArJcIVRxUQtxR
         NnnmSNOGcZDSn/bTdUwUwt/MpMh4vkHu3w0LjVePu5DGKbGZKFq9tWJchpc2sImU/rNx
         OOVw==
X-Forwarded-Encrypted: i=1; AJvYcCXEhyK70kNECabfA1vlq2pjy0Z5iAQSDsxjumuzZldEqa+tbKrvJIpBPVwbjCs1zc8DY7xlOZNC4og5qxUiVeEQ1GVFEp6GKArkRFU/viSpKdxBhy09LFUs4dcycaRY6yHg
X-Gm-Message-State: AOJu0YzweOasnb2IkmsR8qHe1DCvP2nXXu+aQPLYwu/at0S/VdtL/0cm
	Us547WPTb8eUW+XxXuYKzhWC3Psn/RTr8859c3MwdS+edRNoFTiQ
X-Google-Smtp-Source: AGHT+IE0HZOLfBYHe734ZO8wNK+6UYDx2Id8Ab+IDOEArOTnHMjg6tp949DtT+hIq++qDD2ghANuqQ==
X-Received: by 2002:a05:6a00:17aa:b0:6e0:9d0b:fb4c with SMTP id s42-20020a056a0017aa00b006e09d0bfb4cmr68930pfg.26.1707946888107;
        Wed, 14 Feb 2024 13:41:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVELsMHGCmbrxbT9Fbbmwe4EeAHPWNxp1Q4/5mAXGNox442xzKSWz3MRt3Gck7vstj/W4wOelHFqTMRkVsNpGl7SAcyilJ/SBVt2P+B1N7gKnM/KFn27ec29Sx8HU085uzYL9bHw7jYNsKQ+7mFyvbF1u/Vp9s=
Received: from ?IPV6:2620:0:1000:8411:cc45:481:45f0:7434? ([2620:0:1000:8411:cc45:481:45f0:7434])
        by smtp.gmail.com with ESMTPSA id s23-20020a632c17000000b005dc816b2369sm3930115pgs.28.2024.02.14.13.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 13:41:27 -0800 (PST)
Message-ID: <1669f330-836b-4747-ba4b-dec0a78768b6@acm.org>
Date: Wed, 14 Feb 2024 13:41:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Consult supported VPD page list prior to
 fetching page
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
 belegdol@gmail.com, stable@vger.kernel.org
References: <20240214182535.2533977-1-martin.petersen@oracle.com>
 <a0f6d397-8162-4e89-a1ff-99540c70fa00@acm.org>
 <yq1plwyhlc6.fsf@ca-mkp.ca.oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1plwyhlc6.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/24 12:20, Martin K. Petersen wrote:
>> On 2/14/24 10:25, Martin K. Petersen wrote:
>>> +		for (unsigned int i = SCSI_VPD_HEADER_SIZE ; i < result ; i++) {
>>> +			if (vpd[i] == page)
>>> +				goto found;
>>> +		}
>>
>> Can this loop be changed into a memchr() call?
> 
> Would you prefer the following?
> 
> 	/* Look for page number in the returned list of supported VPDs */
> 	result -= SCSI_VPD_HEADER_SIZE;
> 	if (!memchr(&vpd[SCSI_VPD_HEADER_SIZE], page, result))
> 		return 0;
> 
> I find that the idiomatic for loop is easy to understand whereas the
> memchr() requires a bit of squinting. But I don't really have a strong
> preference. I do like that the memchr() gets rid of the goto.

Although I slightly prefer the memchr() variant, I'm also fine with keeping the
for-loop.

Thanks,

Bart.

