Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E22127B43;
	Wed, 14 Feb 2024 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707936279; cv=none; b=OG1idKjN18ZihoxijbI4GN7f73lSaxFh/3XGdtqFDUFDLuy/1GfpXAXNEpXXOORzv65Aax9pRPLM6j4DU/Qmfb7aBeiTBvmYvKZXbu9NvQ4TBwUYQfXz4BKGP4L3njlBLL2ngul7kHl2a/CHeMWNDkcIy5u5/QQyOYZ1tE6f0xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707936279; c=relaxed/simple;
	bh=+X0FloUbsegVqgAvK2TCIorZvQiYlNoG05piNcrQwJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CCowEzagOe4u4YYi2sRD3RF4f1GoqeeDMtJeRpvRJOW34tCxz+oMRi5gaHJmj34o37oKO/lZLopy0qMXD+4nKpIov34wYVBQLCvxkz4qvUWJWI82Xnl3eOKI+nKeQCcCAypNanCEvl+vK0QgUx8tjHTqadPQ5OuCws0TRNsF+RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d780a392fdso241165ad.3;
        Wed, 14 Feb 2024 10:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707936277; x=1708541077;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ab6rz456v2LneYUCzmeaWwz9ju2k0FrgP+8M7GgPKas=;
        b=g6rI67Ct0oULNtPSt1pr+9+TD5aqFJv7uJSPBbxvVnwNvTNcxwceNjw4JjT6hwbzB8
         DSPM3YT4lcbnjqra+mL+jyJeSbBLIs4XRoijEYklCKcAlACeCIXtGn9mCFJMPus0Z6oY
         MvHe8CWSuB8wLK5zr8rMaSIQVo/QkomcrLrZXs/dRkYg5mYKsmvXb4dIUdmALGZcLVN9
         e/wbLV8QABdvQGMH/Trd5fuXEgATdE90J3T+jezaX25xO8n2k8WbGUq+Zq0KXGXVkJJh
         LXEFo602DmWbXqGZ11v1f6/tA8JrgSlFeBhONu+WjEM8gGJqXSNPUcG4Pz06tHri99Kn
         nQ/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUCODGi84OMD0mpEvklAgvNf3y/EANPiN0LGlPhkj46TCPxfG3tx69+pL7UFp9oOUjZHyZJgUR5cSQi6fZwxwRovghKJWr31UPH/T9DQJ5JnazkQYbSKtOgO9fqxc3ksoKA0/ZNQOS8TyRmEbZcuLl1J8ECguye3U9bSSvd/g==
X-Gm-Message-State: AOJu0Yy//JG2wI25Ld8m4fGarvDXkkOE9w7QRxLLEFaYzpFbEeww3tew
	N5E8wsfxNJxnO+GVr1uBmeuU/shikVNDydBjCtMV3N86yJvata+f
X-Google-Smtp-Source: AGHT+IFVEOTyfCjg8k0UE97GjtqLcfGRXI8IGvdBKTyHXMQ9mZ1x+QYW4q/hEQreAxCfrWxGdy4OqA==
X-Received: by 2002:a17:902:82c6:b0:1d9:3101:c46d with SMTP id u6-20020a17090282c600b001d93101c46dmr3052119plz.55.1707936277347;
        Wed, 14 Feb 2024 10:44:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVKkSQqo7ukCx3TID/2vH80Jrs1+5giWyOj56xJ9A3A2SQGm1fYMZNmI2/uepMF1OZAmdec9/jguerbdQdB5P9zI3RK6iYbzaFsHlBAyr5DwPLgT8n0TY/eatKiHMPk/rAuTyLLtkBWF7fZ2kvvF13kDe/x3AWzUinWzOgiCw==
Received: from ?IPV6:2620:0:1000:8411:85a5:575d:be51:8037? ([2620:0:1000:8411:85a5:575d:be51:8037])
        by smtp.gmail.com with ESMTPSA id jc13-20020a17090325cd00b001d70af5be17sm4049158plb.229.2024.02.14.10.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 10:44:36 -0800 (PST)
Message-ID: <a0f6d397-8162-4e89-a1ff-99540c70fa00@acm.org>
Date: Wed, 14 Feb 2024 10:44:35 -0800
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: belegdol@gmail.com, stable@vger.kernel.org
References: <20240214182535.2533977-1-martin.petersen@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240214182535.2533977-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/24 10:25, Martin K. Petersen wrote:
> +		for (unsigned int i = SCSI_VPD_HEADER_SIZE ; i < result ; i++) {
> +			if (vpd[i] == page)
> +				goto found;
> +		}

Can this loop be changed into a memchr() call?

> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index cb019c80763b..6673885565e3 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -102,6 +102,7 @@ struct scsi_vpd {
>   
>   enum scsi_vpd_parameters {
>   	SCSI_VPD_HEADER_SIZE = 4,
> +	SCSI_VPD_LIST_SIZE = 36,
>   };
>   
>   struct scsi_device {

Since these constants are only used inside drivers/scsi/scsi.c, how about
moving these constants into the drivers/scsi/scsi.c file?

Thanks,

Bart.
