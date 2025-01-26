Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B613B17BEC6;
	Sun, 26 Jan 2025 21:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737928527; cv=none; b=uvDXlkjlwUWqhyViQ6204+j72jQ3PlCxvWX7/0HHIvc7jkEmpnDoN2HFWNLdQMsfIRXeMrts+160+H7I4NWaZ11NyuT+QmjSyDLMmZXAjqMgm7u7VATifCCC2C5rkH9H9aQomV0Zxaa/PO1vQh9SMXxV87AFsnejXop9vRE4gP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737928527; c=relaxed/simple;
	bh=Z06D22f9X6xZWYUdmZRHeOE7TK+BW5GBa46Do+8ZD8I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UO03y8Ah03BrosHgdZsKTvaOSpxccSJJrcyy+vprE8ddGLzpH4v9AIDq1+iz4+LWXqRfGW3Pis8xwyS9nnSYzIMjfcjtzvlgZPE9SlJ13cpJRvlAG+MfhI+gfK/K4caOdv9WQqVQVb8+emeCe0cQPUNk7mUx8yx22LSBiCjHR68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BlEE+OsG; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BlEE+OsG"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43618283d48so26468475e9.1;
        Sun, 26 Jan 2025 13:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737928524; x=1738533324; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z06D22f9X6xZWYUdmZRHeOE7TK+BW5GBa46Do+8ZD8I=;
        b=BlEE+OsGlk0xr6rfr3BOrS1ish3+sl+gk5o0jGQ3pDkOzSqZpRXsYk8GwpUC39l6tg
         htOlgqavhchtMPZHXoWqJauBvpJm/GDer6m02lBa97fpaBVQKLf6KGkG00gb970FBJ69
         ZiCB2CTwItHC/dEZstVuJTAZrDnH/BWbUaS/YN4JX64pdBuHrkoyv+9jAuEBHfA2VPa8
         WwYUwsTOlKfY6dAnstuc9gyKeNGXAb9WCVSA0J2yfOFMW0x9H92Doxth1HoYmEqdQUAv
         Md00SfXIMyFoW+0DoMxY04ChFbVEcSo5FVfK5EIjN05Yudoa9BUfPH2Ci8/IAxv9mVYp
         PQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737928524; x=1738533324;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z06D22f9X6xZWYUdmZRHeOE7TK+BW5GBa46Do+8ZD8I=;
        b=d2v8F2iT/yuhlqbgMVDGLmL3cTRgZE0joC0rzD36n6ydPkAsYA4N/llFVyfcsLZVEh
         4yub9PdzYjw4h2oMCpKDf5Hn5C6CxyoMz+qvsV3KNfc3dk5gzFsT27FTjrgxYM1dkttk
         FkoM0WvJpxMic79nRhljVeIx9ka2BdkhI1QWQtVzKAbWrHQThqvxgmKKCPCMNBAyav0G
         xHxC15LeR0C0cUpW8gQXUBKQLCthHjBhhJAFrfbMWFCRcu4O/SoT7tNlWOaQUT9x2Ced
         CqmuZDqV4lrUGD3ri+vdX15H2a4zKrmfNul3FS6iZVMuluPC8Bx20hWr2J+S/9yBTzEK
         YuoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKs8pT1JfORsZVwhu0NlKiFXuS2Tk0Mx8fey8mdJ2txcUGzVdpwwXyc7XEUKF2oqrtWUpRHDsSEzQCbCY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0I/u9xMaKgBtMJwd9UfN9p2qDRE7O/cn6oOJ8o6XQM2Ep0Qte
	ERqGl6GXpMOgFB6iedbf05ONLJ9xB98CD6jvv8djhA5nYUWqmmtn
X-Gm-Gg: ASbGncue2dlPcXbn+ZChCRrX4Cch6+zPHGd13kB+uv6qy1DTnXXXMXZTYuAZ/X+cFaW
	ctWUhPubOvjojAHBm+zzeyvBj0D41AcV3oJlTYW/MqnPj3yZsN35Q/CalDqe6OXAZsNgCzLnYIW
	0Ru4eTevVGCMIN8/uS6r2nkZ+82CiRdJkV+NQpOt72sf5KVBzeNz5sWoTZxKNl/0HG3umFIPMxf
	pyQa4tKAUWWCe2CN9e7G161p7SIS/EzfHB1N3Rj8tjPZp87W2EJZAmmR9/HhlYXs0fOB5v1Dx8t
	+Sro5gxQ9ljbrbMzuBeWZua+1UP3Fqcx8E7ykE78TvVk1Zrhp3Qm5HZ9g2zgCuTHuA9PqC033Gm
	dn1xI5ICXzNB5vK6uNFWvCPDiUOHuYqmRsV/wW4eBclhD
X-Google-Smtp-Source: AGHT+IHbLb05krmjL74OWcOlY+O17N6O05zCvgPUjcSOkqsIgPPumqqjcswBG3yeAZAW90JfhO4l9Q==
X-Received: by 2002:a05:600c:c0e:b0:431:5044:e388 with SMTP id 5b1f17b1804b1-4389142968emr348645505e9.22.1737928523606;
        Sun, 26 Jan 2025 13:55:23 -0800 (PST)
Received: from p200300c5871e95f7cf8ec2b454ca4b5c.dip0.t-ipconnect.de (p200300c5871e95f7cf8ec2b454ca4b5c.dip0.t-ipconnect.de. [2003:c5:871e:95f7:cf8e:c2b4:54ca:4b5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4d34e3sm107340875e9.39.2025.01.26.13.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2025 13:55:23 -0800 (PST)
Message-ID: <f069e33f01f8489b4baa8d1e5b3db4eb055ff118.camel@gmail.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: Fix toggling of clk_gating.state when
 clock gating is not allowed
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Manivannan
 Sadhasivam <manisadhasivam.linux@gmail.com>, Bart Van Assche
 <bvanassche@acm.org>, Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 26 Jan 2025 22:55:22 +0100
In-Reply-To: <20250126064521.3857557-3-avri.altman@wdc.com>
References: <20250126064521.3857557-1-avri.altman@wdc.com>
	 <20250126064521.3857557-3-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gU3VuLCAyMDI1LTAxLTI2IGF0IDA4OjQ1ICswMjAwLCBBdnJpIEFsdG1hbiB3cm90ZToKPiDC
oMKgwqDCoMKgwqDCoMKgfSBlbHNlIGlmICghcmV0ICYmIG9uICYmIGhiYS0+Y2xrX2dhdGluZy5p
c19pbml0aWFsaXplZCkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc2NvcGVk
X2d1YXJkKHNwaW5sb2NrX2lycXNhdmUsICZoYmEtPmNsa19nYXRpbmcubG9jaykKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBoYmEtPmNsa19nYXRpbmcu
c3RhdGUgPSBDTEtTX09OOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdHJhY2Vf
dWZzaGNkX2Nsa19nYXRpbmcoZGV2X25hbWUoaGJhLT5kZXYpCgpDb25zb2xpZGF0aW5nIGFsbCBj
bG9jay1yZWxhdGVkIGluaXRpYWxpemF0aW9uIGludG8gYSBzaW5nbGUgZnVuY3Rpb24sCnN1Y2gg
YXMgdWZzaGNkX2luaXRfY2xvY2tzKCksIHNob3VsZCBiZSBjb25zaWRlcmVkLgoK

