Received: from sonic304-25.consmr.mail.gq1.yahoo.com (sonic304-25.consmr.mail.gq1.yahoo.com [98.137.68.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404AE136E1F
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2024 22:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.68.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717626751; cv=none; b=iW8CQB4jg+tJE2JfNpDOjYx7irL1R6yD0gJ/E0vEiV4W4XfbN/krXCGAS1Uk/oZ1JTIgU5gzfUVYaeVV382P71aOCCI5z5WXApXV32wGpJRQBCbp5LqadB7x4a/dtrHvO3OKfHjqSNdXiHPhgan5XMrVJcDnhV03qgy8uDTmupM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717626751; c=relaxed/simple;
	bh=yVX8r4qEnwDYzTpdDCUC/a6Wns6YVRUvt9z3s9GeARo=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=nAskPTxdLSo1vTxi/vW2UKIyF4ywHnM50dGnr60HVm0Wop8ymuDR5KC/n/Hh7fkg/uDyZhTBQKqw5puxAlCui1iEXVs9CmYWBv8cTn6a+dNhANMXt1wCoslYUlIFGDJu+7DOUyMXJJ8OjOBm5o5ALQRBK+hETgeStMOQ7h6WxUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=pCinrNqP; arc=none smtp.client-ip=98.137.68.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="pCinrNqP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1717626749; bh=yVX8r4qEnwDYzTpdDCUC/a6Wns6YVRUvt9z3s9GeARo=; h=Date:From:To:Cc:Subject:References:From:Subject:Reply-To; b=pCinrNqPvUJE1Px089QtGpE/IsHgfIgJ4WImlMTlpuBPJciO6C+ETkHWATELlFhfT9vCuCNvN7HSCIjSfkmR2GoZjXf1AKz6EXW8b7qHbAeGqjfQBtKdFB9wMQ1ZgTz+saODcdhpS7JbcexGAqFKDLjgUKtIoI6rMbzQAiosQ6v0Cye97A6KLgzEhFfWPyy9Jq0HgJLk0XXzu/JGVAqaiR5XP7JpUuUx0BR2Z9LHdwW89M5uIkzOSQHQQ5Qt9fxfvImkD59RI5snk7yz+9vHjn2gpLxxWgUfYksZxPI4Qc41QM2W7oFEDYlzaVkjQRJNk3OFMbx1gtXHJbVoj+vBHQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1717626749; bh=K9Vl9ix0Fxf1rQtDZb4B6K3NtS3WRCL+eUgP1PQF7G0=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=og4p3FJMxVS4/644njhU/B43QVkkRhqszLL/LPnwpUJ6V3WmIYPhcNaiD/q6R5/E/BPij+YqGGUjSDg0jihhVTo1pMJNyFobVnOydsXKkVHSgJj5dZNth63nfYnxhWcWSnUOjeGdRSaGgLwuCTpMGVdJkeT1C8p+UJWaACVmoUwmCpU2Hx6k9rJ9eS4JKOeXcPJiUO4ewgvkIqzjdqvTWyM9sLRbMglbM9YUDhzRiYRDkVFbUSXwnWx66HSAMEPMD46uyNJp0oYrVJKg64gPcFZo7UYEtx15y7gxU3y67ycjdmt+0E9KTZ3hb0YkX1Igqwv1x/J6opHGJVkL+PCQXg==
X-YMail-OSG: J_D.cwMVM1klEcSbdJ0pXblbSrHGbxSapY_DPhETzzW20VPLkGPFtDAAmtchRx7
 oyfIeJZMP9Liv6xOsS0Fq3EpuNnAfuE.abX1IU28dd4P3W1r0BdBmM2deCZVgo7QFkf8qDVId3X.
 vqtbefo9N45tbCbUBBKApy9pIJlUk53UJqg_DM10kuqLc0pIDuSpTWYDZxKQlziwMHb1fVAS0a6U
 x0Kach8Q4Fq4cUXW8Bvey3jZIqvbN5FEUc8H.tN56rwaucMPwBoarOtfpdSu.80M1z1nOxMof9jE
 1ofSyjgpFtCun.zNKFtTWuFePl36xPbJDHuwFNvKLQBoZ3ykx3sPQlhgguri4.GmghM1q57F3qIi
 bLe.F3kqODOh8WrWD6dx4JSny6k0D_KSs1gWw3tUpMcEuJ7AlOxXGrcYFtyyNYp8wzcRM2Zi15KZ
 hTDlZ9QraVBn5r2Jfgczs06lVCbIx5M9gqq49lCmBLkjGkFmTW78foKgzgAhaJgaeryDjjgK0lJI
 lY3VdwROfqeYEwnCvVQOLkxvRxD2wZ4ZVUGT2udKvgUMmSNM.K2.hMrAYZk_PTGZALT9tKowbH5f
 xSIwk3JM1.Xr0yohWi_aIT0VxYTZXOe0PTOab5N1NSDc.fWQIbWtiGWTdTfVm38HS1C6cRrTU6d9
 cDdJSgei.DfKRTKoUYp_Nb.sDrxnYX5mktOC2LsJM.SUER051d54UfEsade3pMz2KXVhazkdH8Dh
 kDNgsvZdMOBUdSsTK41yFkh896OPGtpFoxT2Fc.LDYz_1kjgtWjxbALibrNzCTcv6fc2Ff41JC_B
 ie8Qeu.nTgKbDY9L79ZwoOmwv6kNYTEg7Hp3v6PNqqXGuo5tTyQPoGXGrU8B8DLMWIMnhb8QMWoZ
 Ir0Yxce5dY3Em8HO_eSTO_3SkygOxqsqDxoTNT2vSSEZMe4T3HFyKwLjcTWwcPlXrBlc0Ei9PzMS
 C4AC_LW0Czlham5A8WlPsgVPn.zUQE7iFN9eRAQb82AUp2WRfHfgbLZTeTV0zbVW0CZf3w3IgtJ.
 y9iCms17ou6D2qHrvvodzHHyKwFeV6mG.QwpcmXprVUHed8WsqFItBspxFgj.YiIzza7ytXfCqfH
 wJddcdNbUCGJOqZCJdiTF87KYStyZXNBmjmHlNV0930P5dN6_9X_K4RGJSG52oUnrGvBjLJGCMjn
 3hJCCuaW1uqfOdk68U69b2K2L59O0oEOBB3CoNb3fipFkEay1y57tiPRhuDEZuowFl_ujXjmI3dR
 z79Sgv0lSifIXHW9csBefqCQSLwx8NQzTGWrPuDh4_PtvmENcILY5E5JH__tmIg4WkIWBnjjjLkG
 WUhsokkPcMrWpmobgBV5lH8tKDFATLYbijV.HfhtFBuGtzE7HWubhsDKCeeTTGT.ZD_7UwxRZFA8
 TeUHPEPdgFpNaYYPrOA_Ms6z22ZqIZHJEAfd.kE0aNjN6wqS21FCnmCxx.Be3pPIhKlw7QVLd388
 LiCyJEhqV6Gf50h9dmVMX357j6LRJ.G4ZKxQKkwDYzSyVodMkt.DAkYNwcnwIbjoVzNhQBs61Zus
 FmeCU_khOz4016TQCeHYYgBwZdVFh.GRyxcnoxYwJwrZTXGIlGbQTCEC1va6p06QbeeUzP5Fck2n
 rjLvkbHHjlJCUuJmiLTqV4hh1eNjZ3mlqJp.raiV2GtiK82vo.Sj5lSVv6IA4XSOltbIJqwMBBiG
 0K4GYEFEtcA6OXLHFumXyxqwCVKPboox8iTmTqoX3yQRTObmOAY.JJ3ELoiG2Gtf..tA9A8gf.2s
 YVysaEQnlPio1fADboucidvfQHh5uHPz33pBK6yq9.a1ZWA3ykg37ZHb1798FO0pVoYKfINwMxrN
 HMkK3phZwxHSzav9eo0SG1nQGjmaxAmNckjW9DlcYmtXE8UlJrqmvCiJqtPa9XeJYkeCHYxTdhS3
 HL_ZGDo90V44tQ1DfRfbQCqkI9IEZEwZ2rnfN79vRIdUDbqDtvkwhj4KV6uYuGRjnHX7sWjDyYAk
 9BdKX9nlkDi_wNzscJzpNjVsjvvdspQ8vF4aygwZDphFMYELH1safSjmagQ0EhkSrempLKEHiQi8
 7AtUPbdy7KuIUQG.VyZclhFgRNMFx1Zxl2kWuMNgpsHGSNlaCsnBGfK5iUe4u7Rlpg_5HMdQnHaQ
 IxuMaE_qnCy0Xwbut8WWE04nq4.glPaqTgXn6ihsl922vhqFQ1swgJ88hjPXvKaq4
X-Sonic-MF: <sgoel01@yahoo.com>
X-Sonic-ID: 8cadc2be-f04d-4de7-ab7f-9a2074382d89
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.gq1.yahoo.com with HTTP; Wed, 5 Jun 2024 22:32:29 +0000
Date: Wed, 5 Jun 2024 21:52:00 +0000 (UTC)
From: Shantanu Goel <sgoel01@yahoo.com>
To: Oliver Neukum <oneukum@suse.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Message-ID: <675774215.2024605.1717624320352@mail.yahoo.com>
Subject: [PATCH] uas: set host status byte on data completion error
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2024604_1929375854.1717624320352"
References: <675774215.2024605.1717624320352.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.22407 YMailNorrin

------=_Part_2024604_1929375854.1717624320352
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I have a disk enclosure which is prone to data completion errors during ini=
tialization and because the UAS driver
only sets the resid on a data completion error and not the host status byte=
, the SD driver ends up using invalid zero'ed data.
The attached patch against v6.6.32 fixes this by setting the host status by=
te to DID_ERROR so the SD driver will notice
the error and retry the command.

This bug is present in all stable kernels (4.19, 5.4, 5.15, 6.1, 6,6) and t=
he current 6.9.3 kernel.

This is the behavior prior to applying the patch.

[=C2=A0=C2=A0 11.872824] sd 0:0:0:1: [sdf] tag#9 data cmplt err -75 uas-tag=
 1 inflight:
[=C2=A0=C2=A0 11.872826] sd 0:0:0:1: [sdf] tag#9 CDB: Read capacity(16) 9e =
10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[=C2=A0=C2=A0 11.872830] sd 0:0:0:1: [sdf] Sector size 0 reported, assuming=
 512.
[=C2=A0=C2=A0 11.872995] sd 2:0:0:1: [sdn] Preferred minimum I/O size 4096 =
bytes
[=C2=A0=C2=A0 11.872996] sd 2:0:0:1: [sdn] Optimal transfer size 33553920 b=
ytes not a multiple of preferred minimum block size (4096 bytes)
[=C2=A0=C2=A0 11.873466] sd 1:0:0:0: [sdd] tag#29 data cmplt err -75 uas-ta=
g 1 inflight:
[=C2=A0=C2=A0 11.873468] sd 1:0:0:0: [sdd] tag#29 CDB: Read capacity(16) 9e=
 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[=C2=A0=C2=A0 11.873472] sd 1:0:0:0: [sdd] Sector size 0 reported, assuming=
 512.
[=C2=A0=C2=A0 11.873824] sd 7:0:0:0: [sde] Attached SCSI disk
[=C2=A0=C2=A0 11.874064] sd 3:0:0:1: [sdk] tag#16 data cmplt err -75 uas-ta=
g 1 inflight:
[=C2=A0=C2=A0 11.874065] sd 3:0:0:1: [sdk] tag#16 CDB: Read capacity(16) 9e=
 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[=C2=A0=C2=A0 11.874070] sd 3:0:0:1: [sdk] Sector size 0 reported, assuming=
 512.
[=C2=A0=C2=A0 11.874465] sd 5:0:0:0: [sdo] tag#10 data cmplt err -75 uas-ta=
g 1 inflight:
[=C2=A0=C2=A0 11.874466] sd 5:0:0:0: [sdo] tag#10 CDB: Read capacity(16) 9e=
 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[=C2=A0=C2=A0 11.874474] sd 5:0:0:0: [sdo] Sector size 0 reported, assuming=
 512.
[=C2=A0=C2=A0 11.876151] sd 4:0:0:1: [sdj] tag#10 data cmplt err -75 uas-ta=
g 2 inflight:
[=C2=A0=C2=A0 11.876153] sd 4:0:0:1: [sdj] tag#10 CDB: Read capacity(16) 9e=
 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[=C2=A0=C2=A0 11.876158] sd 4:0:0:1: [sdj] Sector size 0 reported, assuming=
 512.


After applying the patch I no longer see the zero sector sizes above and al=
l sizes are detected correctly despite
the presence of completion errors.

Thanks

Signed-off-by: Shantanu Goel <sgoel01@yahoo.com>


------=_Part_2024604_1929375854.1717624320352
Content-Type: text/x-patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch-6.6.32-uas-set-data-result.diff"
Content-ID: <f475478f-ac60-93b3-e250-fd41439b2e5f@yahoo.com>

LS0tIC5vcmlnL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdWFzLmMJMjAyNC0wNi0wMiAxMTo0Njo0OS4x
NDQ0NTcyNTMgLTA0MDAKKysrIGxpbnV4LTYuNi4zMi0xLnNnLjEuZWw5Lng4Nl82NC9kcml2ZXJz
L3VzYi9zdG9yYWdlL3Vhcy5jCTIwMjQtMDYtMDIgMTE6NDQ6MjEuNTIzMzc1NTE3IC0wNDAwCkBA
IC00MjIsNiArNDIyLDcgQEAKIAkJCXVhc19sb2dfY21kX3N0YXRlKGNtbmQsICJkYXRhIGNtcGx0
IGVyciIsIHN0YXR1cyk7CiAJCS8qIGVycm9yOiBubyBkYXRhIHRyYW5zZmVyZWQgKi8KIAkJc2Nz
aV9zZXRfcmVzaWQoY21uZCwgc2RiLT5sZW5ndGgpOworCQlzZXRfaG9zdF9ieXRlKGNtbmQsIERJ
RF9FUlJPUik7CiAJfSBlbHNlIHsKIAkJc2NzaV9zZXRfcmVzaWQoY21uZCwgc2RiLT5sZW5ndGgg
LSB1cmItPmFjdHVhbF9sZW5ndGgpOwogCX0K

------=_Part_2024604_1929375854.1717624320352--
