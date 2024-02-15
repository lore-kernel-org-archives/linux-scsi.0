Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB5213B2A2;
	Thu, 15 Feb 2024 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708021690; cv=none; b=CCz+BuKfBnpk0agQJFr7zfaCl87iAAwD/13KUmhsN/Z/5ej1qbdvVhlls9UYFqEMraiDF+2ZgVdg0c+zOXIbBxiW6iAYAk2JZJTS1VPaca5lDv1yP4bNWP6qLh72Yt8eN240RNcLC98GYF3XRkbZwfypCKRWBjCKI4gSOnuMC7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708021690; c=relaxed/simple;
	bh=hZC+dJ4sW5m/QRyc2a+E9W1nLktu+Kfg0etmKqtOUpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BIzGAhGUMOffbh+H/XniersSF0Dy/TVKRY4HtQHKerYk8KV+Sb6jXXhNsiTDAPdU+dGflEdH4925pV3FFpfoxVBZUQBvQ9vrg3mPn5e5l92Lga31QiN7VsC3e+aLKJw27TimbIAWqvNN/QoYLjdXgvblGceiCj8zYrzmas7QUuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6dc36e501e1so756109a34.1;
        Thu, 15 Feb 2024 10:28:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708021688; x=1708626488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3yXNdKrJSOQdhWHIGz+MyymY27eDLWqPmILg0tn0yO4=;
        b=Q5Lf1Gen+AWOGl8MujhaPZISNuyDDHXpL3lo7E1//lJMuuyK3XXqO8iUAGoH6puVU9
         EZJgm1wWBtID4k2ygwjp3PqllroCgD2my1jauUmUkW4nUlrt3R05IgQYseAH0NyAR9tB
         TBWKTlC0h/9b6ebfxm7kvKAj8UWq4I5tDtahBubazA2A4flmCPn4ijwA0TLT9ndJMPRn
         FDRb1VNtb03ISC+ClVR3AL8uQ1jR+fEVt+W5HG2gMKqAKoJ00PkV8aLgw3AycT8wYv41
         q9Z2F2kMAmkwYPcNPsZp0DVSYeedPDOSxvnhUU1tCTSws3JGMwXx+Y+CAWxSMfKdwOWo
         IOqA==
X-Forwarded-Encrypted: i=1; AJvYcCWKBly7Dr7dLiv4M2iuUaIt8bozUsRgwHkJQ0qkuqnKdT9Djnta75nU3Sv2NOq2pN7AIBk20PuzDVrYAWUcIsfmHQ4gTY9f5HgYlmHQ4480BSgUysH0BmbY/2oqzbVpAJKHpVZDgX9j7WEIgo8wzzO2d6M/P505dOLUa9QdXw==
X-Gm-Message-State: AOJu0Yx+N1fMN+GwE2+tsoHeV3DEgzdh1y28sW9oqg6NlleXyKzswyCr
	02LAPArcTjJ6JiPY9UFUDgvgHv3hTFFbwOeNEwyQAnp7tUafmCja
X-Google-Smtp-Source: AGHT+IFuUXja9utnXc+ykvM0oOP/z+9Ck3ORILrPcFFsl2lfknjvp6YS25PVeX6q01d8L//O5Mnj7A==
X-Received: by 2002:a05:6358:4811:b0:17a:ec6d:e05e with SMTP id k17-20020a056358481100b0017aec6de05emr3276303rwn.2.1708021687837;
        Thu, 15 Feb 2024 10:28:07 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:cc45:481:45f0:7434? ([2620:0:1000:8411:cc45:481:45f0:7434])
        by smtp.gmail.com with ESMTPSA id a30-20020aa78e9e000000b006e0a4022fa2sm1637958pfr.189.2024.02.15.10.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 10:28:07 -0800 (PST)
Message-ID: <883d670c-3ae1-4f44-bcb1-45e1428c9c3b@acm.org>
Date: Thu, 15 Feb 2024 10:28:06 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Consult supported VPD page list prior to
 fetching page
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: belegdol@gmail.com, stable@vger.kernel.org,
 Vitaly Chikunov <vt@altlinux.org>
References: <20240214221411.2888112-1-martin.petersen@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240214221411.2888112-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/24 14:14, Martin K. Petersen wrote:
> Commit c92a6b5d6335 ("scsi: core: Query VPD size before getting full
> page") removed the logic which checks whether a VPD page is present on
> the supported pages list before asking for the page itself. That was
> done because SPC helpfully states "The Supported VPD Pages VPD page
> list may or may not include all the VPD pages that are able to be
> returned by the device server". Testing had revealed a few devices
> that supported some of the 0xBn pages but didn't actually list them in
> page 0.
> 
> Julian Sikorski bisected a problem with his drive resetting during
> discovery to the commit above. As it turns out, this particular drive
> firmware will crash if we attempt to fetch page 0xB9.
> 
> Various approaches were attempted to work around this. In the end,
> reinstating the logic that consults VPD page 0 before fetching any
> other page was the path of least resistance. A firmware update for the
> devices which originally compelled us to remove the check has since
> been released.
> 
> Cc: stable@vger.kernel.org
> Cc: Bart Van Assche <bvanassche@acm.org>
> Fixes: c92a6b5d6335 ("scsi: core: Query VPD size before getting full page")
> Reported-by: Julian Sikorski <belegdol@gmail.com>
> Tested-by: Julian Sikorski <belegdol@gmail.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

BTW, here is another report related to this patch:
https://lore.kernel.org/linux-scsi/64phxapjp742qob7gr74o2tnnkaic6wmxgfa3uxn33ukrwumbi@cfd6kmix3bbm/

Vitaly, can you help with testing this patch? See also:
https://lore.kernel.org/linux-scsi/20240214221411.2888112-1-martin.petersen@oracle.com/
