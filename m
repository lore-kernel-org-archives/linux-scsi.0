Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E5A217F3F;
	Sat, 26 Oct 2024 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729929468; cv=none; b=gj1DraVVQeVMhMPom69bzl7hcSFD7bn1/eOMxs3VakuAA0az4mWXbGw2uRmStmmbFG13iPMKnuQMdhbxz1XLQNfMi4f06g+iVDagUTPWK+C1JPPV5Qqz2WnsOZKMhFn7dQAM42B0vVrhdyb1CqeiLTyYi/5TVT3vnEVqtOyoPcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729929468; c=relaxed/simple;
	bh=GSCEUNCl3ikG2gDX7hKFJGjkDrLIk3URLx+JFXXTOgU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=W59QkEamqzBvLRM5MEuq+BbcUzWTB+0Z8hsBWW6XBqjkBaTsGjYiDEojLNEeTaXCCJihIPtkATUbFCQzJ3OHgrY3fQ+AOfn49IkYUUghzz9QeprL8PsOCLm0VvWD97W6WOIbwGUVallaokNPMeS/ybFJ08mvg9Mdq0XJFg6sXVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EBlqnCR3; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EBlqnCR3"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a3dc089d8so386736866b.3;
        Sat, 26 Oct 2024 00:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729929465; x=1730534265; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HXSjlWXPFn6q1hQBabLUA9NA5hUvl8xGGqoXnS/6wAk=;
        b=EBlqnCR38sgNO+BARKlbLq17dcqAGTgS+rlHAvUtDJTyyie9C42tsZQEJ2xCQJFg75
         bI6uwZEuRY+qDKmlGrx3Nv6GPGq9bHTdROoPc2+QjojueDcfL/N1FfSx+rZJ6pUuWzrp
         i0CyvCM/Yk68aV07kZJbBSgdo2OCEW44su8nFv3b7so9J79a6QQtkLL7+vUCiAnSwtFo
         3NKOQSwWNnk54e6YP1uEdVvCyh4zSyO0U1wc+nSGn6AEN1n57wZI63s21UG8bvlbrH5W
         kN+6/6UOmkLvDiRj0jIGdsW6aqnW3eyDAoVJpY2sNw4EZpLGKpqIlORWYeN3BKi8asXG
         R4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729929465; x=1730534265;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXSjlWXPFn6q1hQBabLUA9NA5hUvl8xGGqoXnS/6wAk=;
        b=dMyyBwo5LHh0oEMNA/Z/d9st5R4PlnAHT/LfIENcTlJJk2BTn0kcNS+Ad5I0ZQdm8s
         wfcSjSAQWd37HgSn17Kn49ZCEMG0hxqmR02Lp1u5b2h7yMdmB6F2hQz7F2dIGToP32t5
         7tE6n2T+I0ilDEb3DS934G2kLb+X1y9PWyfdEg/wnQJ4AuzQwwgAyyv/Kvupt9pvfF6y
         e4Hx3Z73hA6isInZ2x9zElW22rrgfT0KE0QRsYGPDlsaCt6uZurbC5jdZ7GZFkeErG67
         WkAMR+ldfDsMODiS6rrL9vC2/hyRZgO6UH/vfNkhPqsH4Hxvr7FvQsPCEgQIFJXQGpit
         GhnA==
X-Forwarded-Encrypted: i=1; AJvYcCVoeqctK4P+pKuC9AtUY0GECjLWwvMeG3D2iSBu1JQWKpiuZRHLU/LkGhyFJPu96NYtliXeF1n5Dc/7IA==@vger.kernel.org, AJvYcCWWTvSuh3SbDM87+aJee+9/hjlRNltHSTBypuG/w6nXYH7JnLwDU/89i86/jr0UOC4ToryO1RwhYvzM6j8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNDOGjCeR+G5lEh23Bi7yQ5Kzw5xLw5AfmMWjKxaW6ahKXqiJ3
	XyAkgm4AF0XUz78Ecsi9ZT5LCnQUPutiVSDO5kX7awISiKrLmqN7
X-Google-Smtp-Source: AGHT+IH/uwu4/QrWcNeGLgFNN8LcJKvTz2mWWMHiedJjIGRdyIthwFM+cjb+MyRrAKItu0m4fTZxNw==
X-Received: by 2002:a17:907:1c85:b0:a99:e5d5:5654 with SMTP id a640c23a62f3a-a9de5d000b9mr118852966b.6.1729929464357;
        Sat, 26 Oct 2024 00:57:44 -0700 (PDT)
Received: from [192.168.178.20] (dh207-40-251.xnet.hr. [88.207.40.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b3a07f804sm147532266b.188.2024.10.26.00.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Oct 2024 00:57:43 -0700 (PDT)
Message-ID: <08cf23fc-a062-418b-aa90-59bc6077f281@gmail.com>
Date: Sat, 26 Oct 2024 09:56:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Mirsad Todorovac <mtodorovac69@gmail.com>
Subject: Re: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the
 end of structures
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20241023221700.220063-2-mtodorovac69@gmail.com>
 <9ca3fb4b-85d9-493c-8b90-5210f5530e7f@acm.org>
 <414ef7aa-a1a3-4c13-887b-25a51236f83e@gmail.com>
 <dfd36022-2397-486c-8499-454d31072a30@acm.org>
Content-Language: en-US
In-Reply-To: <dfd36022-2397-486c-8499-454d31072a30@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/24/24 18:55, Bart Van Assche wrote:
> On 10/23/24 9:22 PM, Mirsad Todorovac wrote:
>>  From next-20241023, it seems to have passed compilation:
>>
>>    INSTALL debian/linux-libc-dev/usr/include
>> dpkg-deb: building package 'linux-image-6.12.0-rc4-next-20241023-00001-gdcf82889780d' in '../linux-image-6.12.0-rc4-next-20241023-00001-gdcf82889780d_6.12.0-rc4-00001-gdcf82889780d-4_amd64.deb'.
>> dpkg-deb: building package 'linux-libc-dev' in '../linux-libc-dev_6.12.0-rc4-00001-gdcf82889780d-4_amd64.deb'.
>>   dpkg-genbuildinfo --build=binary -O../linux-upstream_6.12.0-rc4-00001-gdcf82889780d-4_amd64.buildinfo
>>   dpkg-genchanges --build=binary -O../linux-upstream_6.12.0-rc4-00001-gdcf82889780d-4_amd64.changes
>> dpkg-genchanges: info: binary-only upload (no source code included)
>>   dpkg-source --after-build .
>> dpkg-buildpackage: info: binary-only upload (no source included)
> 
> What kernel config is used during that kernel build? Is the qla2xxx
> driver enabled in that kernel config?
> 
> BTW, there is a typo in the subject of your email: gla2xxx should be
> qla2xxx.

You are correct. What a blunder.

> Bart.

Hi,

You were right, of course. There is no config SCSI_QLA_FC nor TCM_QLA2XXX in my .config.

$ grep config drivers/scsi/qla2xxx/Kconfig
config SCSI_QLA_FC
config TCM_QLA2XXX
config TCM_QLA2XXX_DEBUG
$ grep -E '(SCSI_QLA_FC|TCM_QLA2XXX)' .config
$ 

From what kernel robot produced, it is obvious that this should be done by something with deeper
knowledge of the driver's implementation.

Even when decreasing all those BUG_BUILD_ON() checks would be trivial, there are obviously more
gotchas.

Maybe "make allyesconfig" would spare me from such stupid errors.

But they say that a fail that makes you humble is better than a success that makes you arrogant :-/

Best regards,
Mirsad


