Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694653A7F40
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785334992; cv=none; b=dYnrUW/pO2uX7WNd8S89KopHjU/QhZNkSyU8qr93bWEmVJXb6GDwu05e14E94LGFQchof9ZZyqg6EtC9VLE9SbVEf/+2DCLXXhabV4KSm5Kn9DVqP4pbiJh+NND1KCCcitxp4bSAPwFcXoFRoP3ZcMoiFew3+9tzJ7mGRhT0Xu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785334992; c=relaxed/simple;
	bh=SxOn4ahSs8Lqh72JXTVioG0B8Vm3MAKBHotj6wRbO3M=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OJVkTlw1IJarCs5BFHBRjW3CgW2KW039CVWrer9NQ6Unk1ZSDM1ASwHla42cdzy7U7tbgEy4kR8sOp4QCMGpjGEq+tTti3hJkGaHMdh4NRqfgRhz0XLOv1xKLVir4pWzbhdYHa3TkXtIeOYjKIVMFpVxqx2umBPsj5mx6DcJnSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=SDHUz1bZ; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="SDHUz1bZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=SxOn4ahSs8Lqh72JXTVioG0B8Vm3MAKBHotj6wRbO3M=;
	b=SDHUz1bZqAhrRCZGMULkJ2ze9I7nzVoaZouxKeU2V7EmQYy8stEwZcdI5CUyiWbuurTXcpxiAGiD1
	 zW2Ne+Rd3MZakoJ5EipIIPy2QG51w9/PfxkxzdUa2XcCw/BkNt+MmR2CuRzc+u91+ZrMAAPPSjjz+9
	 eigRuxKkpzgbtLpcc3XhYdcHLde/E7BiwsQycCWc0GxJjA/7xo4cNAkd22tEsUKebpL9jPQ0+2MV9d
	 i9+HrB7jsUSOt2VZ2+nYu/uVKhChnIH2j298d//vAUipdbSe0Wb90o0CcdTcDBC8mfPVFDf0OpT9wI
	 NxeurCV7pFjOXlXV7JutVIGDv4NyCUg==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id fef08e37-8b58-11f1-9545-005056bd6ce9;
	Wed, 29 Jul 2026 17:22:58 +0300 (EEST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] MAINTAINERS: Orphan the SCSI tape driver
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <yq18q6uwmp4.fsf@ca-mkp.ca.oracle.com>
Date: Wed, 29 Jul 2026 17:22:47 +0300
Cc: linux-scsi@vger.kernel.org,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <357BE4D5-B0CF-4F6E-A7AE-98F9E03B682F@kolumbus.fi>
References: <20260724055923.4793-1-Kai.Makisara@kolumbus.fi>
 <yq18q6uwmp4.fsf@ca-mkp.ca.oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)


> On 29. Jul 2026, at 5.33, Martin K. Petersen =
<martin.petersen@oracle.com> wrote:
>=20
>=20
> Kai,
>=20
>> Time to retire from the role of maintainer.
>=20
> Sad to see you go! Thanks for all your contributions!
>=20
Thanks for the kind words.

I will continue reading linux-scsi and may participate in discussions =
and
provide patches if there is something i can contribute as =
non-maintainer.
So, I am not planning to disappear completely.

Thanks,
Kai

