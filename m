Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB57B15B9
	for <linux-scsi@vger.kernel.org>; Mon, 25 Dec 2023 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="rp3Pvpup"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cc7d2c1ff0so38947391fa.3
        for <linux-scsi@vger.kernel.org>; Mon, 25 Dec 2023 00:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1703491937; x=1704096737; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZjraXmdQ9MKl7DfeMkYtKuFsoM2y5kG0bnTNRXLMD5Y=;
        b=rp3PvpupZcVDwulOGe5h3DVwnuoBuie9yQ0uBriO57DsMlkbWbyRW1zDqTz0svQYy4
         QzV4kVc6O9+F1X8iehX0WtJQ7ZwXq1rX16viwA6qLjmYGHSf7jvPBHgCk0miwFlpQTkK
         I5AmLUWuj0u+l1Ht/BKP2oLch9+1EzTs2pmy8w9iyUQyFcaGbwr5mY4cPb4ZY8qULKj2
         d6Iu/2oPymHv/LCuGzHFUYSEB4Kf3DAmOyohStTZo892v2GQqiLpQLHIBGVAgMpNk2zL
         ng9fJFZmU3BcR4xgt/qTktEgLuEmBstpDxxiovY1efDMVsqAXlooFbEaF5l9MzCzVF2H
         SKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703491937; x=1704096737;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZjraXmdQ9MKl7DfeMkYtKuFsoM2y5kG0bnTNRXLMD5Y=;
        b=Co0VIyhmJEv74BQbvFqi0XXRTYGFi5s+XDeAxwZSJViDkNwA63B+JvDdU8lKwTR/Ss
         giQ1dgVEQ8eqVuiTFG0E6CHF5+cft+I8o0AZXHn7W/53JLA/ClLcyLN22krf+rlO0xZ2
         U3Ry7kchS3tiEzs0evRE5Zh6wGpX9fRbDfW2BYy8IR0MfLzk27UT5bn2d2Z9WugDyzuG
         C09ZfQyilmH1G3kWNIr+BKYFE/qDTMUg/1WmV/idU05H1m4ychUPjtllrNcig8i4iET8
         004bfXsSubieif2QqAmrwNSf9X/v3BFck3jOvm4OB/zZhFNzrSZrxaGtpzLOPznzaPhm
         ueVg==
X-Gm-Message-State: AOJu0YxjdPyqOcaECCIhciJMt+DrrWH+5fQ/4YSCMzucjJpHGYOxsBES
	fMrv3PKcQcKsEowJ/ahp6KmY3XWYtgsyAA==
X-Google-Smtp-Source: AGHT+IG9m6rRX69JGpQvGBXzGaGawFNL8+MbLBtXSX7RPir9VMWJcPyssNSi6NY+nNPJQmRsfp9+Iw==
X-Received: by 2002:a2e:979a:0:b0:2cc:7127:ebb1 with SMTP id y26-20020a2e979a000000b002cc7127ebb1mr2335297lji.81.1703491936632;
        Mon, 25 Dec 2023 00:12:16 -0800 (PST)
Received: from smtpclient.apple ([2a00:1370:81a4:169c:d097:b658:f57b:dbcf])
        by smtp.gmail.com with ESMTPSA id k10-20020a2e920a000000b002ccad70dacfsm1147930ljg.26.2023.12.25.00.12.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Dec 2023 00:12:16 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.4\))
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
From: Viacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <ZYWm_tMtfrKaNf3t@kbusch-mbp>
Date: Mon, 25 Dec 2023 11:12:12 +0300
Cc: Bart Van Assche <bvanassche@acm.org>,
 Hannes Reinecke <hare@suse.de>,
 lsf-pc@lists.linuxfoundation.org,
 linux-mm@kvack.org,
 linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C457D1B-4923-45E6-A481-28C92B66243E@dubeyko.com>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <BB694C7D-0000-4E2F-B26C-F0E719119B0C@dubeyko.com>
 <ZYWm_tMtfrKaNf3t@kbusch-mbp>
To: Keith Busch <kbusch@kernel.org>
X-Mailer: Apple Mail (2.3696.120.41.1.4)



> On Dec 22, 2023, at 6:10 PM, Keith Busch <kbusch@kernel.org> wrote:
>=20
>=20

<skipped>

>=20
> Other applications, though, still need 4k writes. Turning those to RMW
> on the host to modify 4k in the middle of a 16k block is obviously a =
bad
> fit.

So, if application doesn=E2=80=99t work with raw device directly or not =
use O_DIRECT,
then we always have file system=E2=80=99s page cache in the middle. It =
sounds like 4K
write operation makes dirty the whole 16K logical block, from file =
system point
of view. Finally, file system will need to flush the whole 16K logical =
block, even
if 4k modification was only in the middle of 16K. Potentially, it could =
sound like
increasing write amplification. However, usually, metadata could require =
smaller
granularity (like 4K). But metadata is frequently updated type of data. =
So, there is
significant probability that, at average, 16K logical block with =
metadata can be
evenly updated by 4K write operations before flush operation. If we have =
cold user
data, then logical block size doesn=E2=80=99t matter because write =
operation can be aligned.
I assume that frequently updated user data could be localized at some =
file=E2=80=99s area(s).
It means that 16K logical block size could gather several 4K frequently =
updated areas
Theoretically, it is possible to imagine really nasty even distribution =
of 4K updates
through the whole file with holes in between, but it looks like some =
stress testing or
benchmarking, but not real-life use-case or workload.

Let=E2=80=99s imagine that application writes directly to raw device by =
4K I/O operations.
If block device supports 16K physical sector size, then can we write by =
4K I/O
operations? =46rom another point of view, if I know that my application =
updates by
4K I/O, then what=E2=80=99s the point to use device with 16K physical =
sector size, for example.
I hope we will have opportunity to make a choice between devices that =
supports 4K and
16K physical sector sizes. But, technically speaking, storage device =
usually receives
multiple I/O requests at the same time. Even if it receives 4K updates =
for different
LBAs, then it is possible to combine several 4K updates into 16K NAND =
flash page.
The question here is how to map the updates into LBAs efficiently. =
Because, the main
FTL=E2=80=99s responsibility is mapping (LBA into erase blocks, for =
example).

Thanks,
Slava.

