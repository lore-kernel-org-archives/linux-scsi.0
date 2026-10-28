Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793191800;
	b=yS1SADkW1qvjcYpNi5lQ7vyUEYj5j8CmVYJPIIEXoNLZUH540hVEyvtmArO4uC+yYaYu
	 0Wuy/o3uzuc0ZX2SGtuVQ820UsDCzM2yGRPgmcRgYOFeS+MJG6/vA6QLikq6eWOzrmial
	 w/1TI2gpsH0HIcSpKpod4G+6MJnhCD7ITJE9KoDHdF3P7fZBnPzI8KWsrJwKkSMcwWrVP
	 3hfEX8z9NWFgaG7dpSnEKV9XuBAjkrExYJNMQfjuMogTYqi8c9VQWLU2qK5EuPhk1zLTO
	 2Tsfa7RTHQJhWuy/cy+JAjzbHdmyiSwDSFiBOew30ajnaM8YPCia4fO6H+I26528+cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793191800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=blhYmmsPEYfdAi3wMVG4f+bIgUy4vW2WGUgkjgeDvyI=;
	b=PEscp8mvz1wsBy5vrjfTD87kEYYqTSHYcdROgcdki+Ra8sZcSVKapCJfYCn30FhuNWqZ
	 ipA5g67n6eOs6cn8HZdmDOk0sszJzDlGOR6NujYiai85g+kYBQFBefejLQm3/m8Q3Vdgb
	 Aob2BB9sFxfAuyfFjXHOzDtcZ7C1InufeTXZf4kaIYP6GtTSk9ffoXL3pfEiygy36WgMg
	 uaSHKx/mu4EX/+vUtS9XJUAz782CPoL03jCfIiH7bA7+vgxq9JIuOdWkK5MtmhWSGyEV2
	 FeSwtB78goN04ubIw0pCvss3H10RXk4EnzkGmAbO32bklBeVE+nSDmynBClcPLUoV9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bUoU8QZj;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CB4606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42CB4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bUoU8QZj
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so756859f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 05:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793191799; x=1793796599; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=blhYmmsPEYfdAi3wMVG4f+bIgUy4vW2WGUgkjgeDvyI=;
        b=bUoU8QZjFkINbMX4hNXknL+Nw5HooGrWzzTmpcJyHiPEqvGvhAf8hQkq+x4MfEEIvf
         w5rD/bd1BenwzC1V1JOHy/b9rtTZRvWrooFIPry849SgCKzVPkJJ2WXXLb43RjzN6eql
         fJLAh9DMaKgetmoMhGGCkxlaanh7GXVwe4XBTYy/5c8ichBbuMy4/OW25KkYKZDASECo
         widvmsKs6gyy11/9fKWuvzrrbStcQfTNFaTUahcuUuksAXuEmSus1IBSSZYtf6zRBwbR
         C2y4CvET/CB7lSE/ebRQDB6bOYkzfT44dpLdbx4uelILqAnwp5WLML0dWwsW98bmaxFT
         v6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793191799; x=1793796599;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=blhYmmsPEYfdAi3wMVG4f+bIgUy4vW2WGUgkjgeDvyI=;
        b=RQTeVegfSHwyNRUsC44eBdg2/9ZEjLxt1FFFJR/aU1Sk8DEuZ5ByaEti4wzFV7AFEI
         yH7jM97SzIPnuYqEWkID8nEk+Ij9iq1AFkNEEJfyqYqgIf8fzF0oHJNfZalckAOQvG4u
         i4DbECq8qREbF7BNoYK9hChWzIzepWnFt4J3qn57fbbnvaobfpTKW5jdKqUp5KO2G5Oo
         1rP9TJE5wJai3EvWeIbCV9fCfufVtoeXrcPtdlvWRTzBFemskawyO6IObp5he5to4jnG
         XoR4oMuBPXg358fQd60w9hrbSQQoHJ/wjk8uZNI+tgWXinp9zVFdhiSMQEzBQnWL1Gy2
         In+Q==
X-Gm-Message-State: AFq9FYLZIsHsaN59E1VEp+aTv78c4763nvDCP63RSWMCnMrP+/DTZgY3
	rPMcmDbTESpcH0UBh1Bxn4HzJn8erXlQ5xrBUdC1Goa0aogoOCtVlEWpN5oHc4zyzbI=
X-Gm-Gg: AYBFou3T5NTLXm45OEW1suXvKOhjDD4i2JvKV7E7xIkjy2nEnscU61yBXBrQY2TJkeT
	D6lO3QpvXf0mIx+nEBg6v9yhBgBylF5qAxUAmlOip+mq4zafL/aDs29z7qwfnoSVMF4A3kh/wFa
	uMIwVkPyc0Lumz6skIhaOjc5ClT7iX+CfV4tjcVFoIB9RtX7suOar3Xfq/kq73y+nso8vtezDvP
	s1RP1zZYLaWVWommi3+BBE3DDWo7i+ldcdziQ01u14yvFUnCkx5ehx0f6gIFatAdfb7lru0D4v0
	akQkjUVDxDPRO4M33SOygZl+uRL6AgZChEVjTVrmoTVBPa8d3QHb0Va12KmexGJGPFYzdb99+Ru
	owl2FU+nPa+AMn/vHEjiyiCciOLvhWnIYEdq6HfSvQQOvhrwgkLOQgQ84f+/TdNtkk0FLYxK4C0
	RqNciQ4a0Vft80wVz4IfdwTZLNgHfdBbI85JXd09jpvg2iVtYu9qhHK/5RowK76domar4qlVWUc
	OjvmamkADWYsNtQdzNAQgAeNPLtn3CRyiiWr6utNcthZTdrOK0TSiSANOuaP/c1KCvPvUeMJmWU
	z4sjTbApPXChhHR76/s9h8mhjsjEJY96tmFO9WhNAAlIZDgBJqO94bhCeNSYtlkIhilA
X-Received: by 2002:a05:6000:4b08:b0:48e:7fb:aed3 with SMTP id ffacd0b85a97d-48e5d2e7354mr5920971f8f.17.1793191798497;
        Wed, 28 Oct 2026 05:49:58 -0700 (PDT)
Received: from ?IPV6:2001:a61:13b5:e001:5d05:908:ac82:a3a1? ([2001:a61:13b5:e001:5d05:908:ac82:a3a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3dcbsm27572060f8f.14.2026.10.28.05.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 05:49:58 -0700 (PDT)
Message-ID: <b151f502-6ba7-404e-b7e9-599f5b62622f@suse.com>
Date: Wed, 28 Oct 2026 13:49:57 +0100
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
Subject: Re: [PATCH v3 1/2] usb: uas: implement .change_queue_depth to allow
 per-device queue depth override
To: Luca Cecchi <luca.cecchi.info@gmail.com>, linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, stern@rowland.harvard.edu
References: <20261009080341.295646-1-luca.cecchi.info@gmail.com>
 <20261009081225.304319-1-luca.cecchi.info@gmail.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261009081225.304319-1-luca.cecchi.info@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 09.10.26 10:12, Luca Cecchi wrote:
> uas_host_template does not implement .change_queue_depth. Because of
> that, the standard sysfs queue_depth attribute stays read-only for
> every UAS device, not just mine: scsi_sysfs.c:sdev_store_queue_depth()
> requires sht->change_queue_depth to be non-NULL before it allows a
> write.
> 
> uas_probe() already defaults can_queue to qdepth - 2, with a comment
> acknowledging that "some bridge firmwares" need extra margin. That
> margin isn't enough for every bridge. Right now the only way to work
> around a bridge that needs more headroom is the IGNORE_UAS quirk,
> which disables UAS entirely and falls back to BOT/usb-storage - a
> large performance cost for a queue-depth problem.
> 
> This patch wires up .change_queue_depth so affected users can lower
> the depth for just their device (e.g. via a udev rule matching
> idVendor/idProduct), without disabling UAS altogether. Default
> behaviour (qdepth - 2) is unchanged unless userspace asks for less.
> 
> Tested against a Lexar ES3 external SSD enclosure (VID:PID 21c4:0003)
> that locks up under sustained heavy concurrent random writes at the
> default queue depth. Capping the depth to 24 via this interface
> eliminated the lockup across 6 consecutive test runs, including a
> continuous 1-hour soak test (1.36TB written, ~822MB/s, no
> uas_eh_abort_handler events).
> 
> v2: guarded against devinfo->qdepth holding a negative error code
>      left over from a failed uas_configure_endpoints() call in
>      uas_post_reset()/uas_reset_resume() (found by Sashiko AI review)
> 
> v3: dropped that guard per Oliver's direct reply - qdepth going
>      negative is a general bug independent of this patch, which he is
>      fixing separately at the source. This patch just happened to hit
>      the symptom; it carries no workaround for it anymore.
> 
>      Trimmed the comment above uas_change_queue_depth() per Alan
>      Stern's feedback - it described the pre-patch state rather than
>      the code itself, which won't be true after this is merged.
> 
>      Also switched devinfo's lookup to sdev->hostdata (same pattern
>      already used by uas_sdev_configure() and the other scsi_device-
>      level callbacks in this file) instead of casting
>      sdev->host->hostdata, which was pushing the line past 80 columns.
> 
>      Re-validated on bare metal with the same Lexar ES3 unit: two
>      6-minute runs of the original load test (24 sync writers,
>      randwrite, 64KiB, direct=1) at 840-843MB/s with zero
>      uas_eh_abort_handler/uas_eh_host_reset_handler events, plus a
>      mixed 70/30 read/write run (614MB/s read + 263MB/s write, zero
>      events) and a run concurrent with a second USB flash drive on the
>      same controller (no effect on throughput or stability).
> 
> Signed-off-by: Luca Cecchi <luca.cecchi.info@gmail.com>Signed-off-by: Oliver Neukum <oneukum@suse.com>
