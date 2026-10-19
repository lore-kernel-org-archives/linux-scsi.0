Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792436792;
	b=jtxe8kjWQo8cBF64I5BeZZRyB+r/VmHUsRYzUH2JODMX0onT/S92l6BNkFq/y7rqianY
	 wC0TIjLygAN+Jw/JBnh6UoG6P60hNsxs/egolSmDI5iH2EKIqs+PK2FCvqA2cOZVZAnMK
	 ksSPAb78czSwiBl0t8XIbVWvAtU/wHasdijFCdfPEhYAqfE7nN7yt18BKIGZSppcXrYRP
	 IjqJR3p0SgnV3wmTrrFiUqJ95Wkf7Uq6wiPmGDrrXhSbqz5pFahT234aw0wbI0EA0cTCD
	 kag6RMZHyhol7cSNknKthB1kWyDXL3PHNmghn7+QieTa8t8HClhB/jE0zF2Bfmts9+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792436792;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-DetectorID-Processed:
	 Content-Type;
	bh=uDpP6aZvaPBpHYGFko/CIVbzhQGul1ZR49hRv/ytY50=;
	b=jD+8KrCOivyfjZvso/Ro2q2w1GTtwMhigLm22qA1epF0wJ9y720a1LvpCpAVgD+WEgEj
	 dDpDhBTGVB1Y4p/MNVfRnq3cUSbYD/aR1dvIkP74/nshaAlJStNj2mPbiMzdF9SvumDxh
	 SvetMjKf/PTrsniHTb1N+GPm5OWNtzhCiBGOfDXUOUA2SVq0hHePRDV/UWdFVmCGBF0NU
	 RfNwaXP+i904x35N42VmhPc8dP9rr38cBAzc3dpLs5Bc3bLjlXBKwZ5VNnJZQ0pq5het/
	 /7P7+vXFy2Myy9PKDRjRKT5w6axaF/jFiQHviZk8/I1xxyuF/7tgpDcGKgEYxmUJJ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=heyRlu9D;
	arc=none smtp.remote-ip=209.85.222.227
Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4250F606A325
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 19:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4250F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=heyRlu9D
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-93e6eb77f0bso232544785a.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 12:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792436791; x=1793041591;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uDpP6aZvaPBpHYGFko/CIVbzhQGul1ZR49hRv/ytY50=;
        b=KGVL4/vTvCqMUugzrZduaijy4opfRsSn3BY6sWSBTaFNGJEysaMv7rgeFpeY/xf3Gd
         HzkUfLiXrnhvfekvszyMgWGP96opUAb78TE60EVOaIG5lq2ENeGwgw3Lom9x01hHkuKm
         +09YwM1KJpdDVyYGwiRuEthaVuMQmM5/yHiAA3BCMC1YB/+JxbruaK2y2KOt0EKJ9Oyq
         Lt10eRQ/ESt8UI1Wbqi7kOCMeHzAucwOYYy1yVSrTOmvDFonZAXPWjmhrCE+46kyR98o
         idwcxi5eGwb5wKuYzGm/Fs0E4/QQkdvPWlwVYFLull19nChyWuqEDuqZXJhnrLsmLv2u
         CAyw==
X-Gm-Message-State: AFq9FYKGR599Fh9+4D9CcgKAXirBSOUgjZ/GgzFGybqnBRGEaLZKW7JD
	pjojnfiMySUul7y2fH5wctU1ERRDKaqPPVR+A7kZrK0V4OLIJA1DjozwPYg8muRZfPsRmItnerh
	tqpsvqQcuPXn1d7aWhW9gAjiFSJpo58mWCzPFKfKfL1YfBxDYAzxQqqRsHA2rDqOyogbzeP+uzd
	khMBB3+C4x2AFn+oW3qPL0VR0eCB8PHWWAYZu6SlnSPlSWJ+MTlrk2l2ySckiOYu19ImAJZAP/x
	oML4mPvC2s=
X-Gm-Gg: AYBFou35h/pgyDFGay9qTcAcqmg1EQ3RvN0XJ0H0gFAsdXB9Mk4SlJNcV52nRkfWtr9
	l6iJCt4Js4tw3m3YWvV9uMWX0yj0UHlZqFFdVtf7dtipONGhL4/CY1ailpIZQTpe1IaQCMD7W4O
	bvvhluT6hERBZZWFxYCP2O60d8+nZHqr/CykYZBVfEyrjdAwTDl5hURhcVcK+Ql3iBI4zGnHiR+
	0C6tocc+9NMZb35KqTadAVLNorSh4L9xPFpsG/CUreQVyhz229V8zInCWemlGPcrXMGtNmgWls8
	xl62Avve8r1URcmh+JeUyNi6rFa3JWKQEaZ2XyVCcnT+icDihoxbFYFUj86jTFgvSnt7AhPe2rP
	G+RUk40bPqI/33cDl3iY4pMQFtVBoOnedyiI6xG1MgwrYxSZAFDzaZ0qkc8UZBH4k+HUJIxP33S
	4pDZ+e7ZjSBi1WdhTLDBq3enuhHXzPxb6G
X-Received: by 2002:a05:620a:1a13:b0:93e:be0c:681a with SMTP id af79cd13be357-93f29d7b37bmr1415449985a.55.1792436791016;
        Mon, 19 Oct 2026 12:06:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93f4afcdae0sm4330385a.7.2026.10.19.12.06.30
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2026 12:06:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-8ae5317eaaeso33601817b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 12:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792436790; x=1793041590; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uDpP6aZvaPBpHYGFko/CIVbzhQGul1ZR49hRv/ytY50=;
        b=heyRlu9DEz/Lc36Ixvde1Rt2l9L5sLS6eox/ae4c6Jq6NJSAVJ59h7MTxeDjq4iLGk
         vfZEHfCJCv9Z/2EZl87Pvvd+PBmwYH+Dp9cNBr9OjeB6U757lCKh/k/QxqEmpt/OIlor
         xVq9e8dmByR6Kmp0VKEJox3yw7uviVB9OL5zI=
X-Received: by 2002:a05:690c:d82:b0:8b0:a957:80a2 with SMTP id 00721157ae682-8b0f21d03c4mr28109297b3.41.1792436790470;
        Mon, 19 Oct 2026 12:06:30 -0700 (PDT)
X-Received: by 2002:a05:690c:d82:b0:8b0:a957:80a2 with SMTP id
 00721157ae682-8b0f21d03c4mr28109157b3.41.1792436790076; Mon, 19 Oct 2026
 12:06:30 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Paul Ely <paul.ely@broadcom.com>
Date: Mon, 19 Oct 2026 15:06:18 -0400
X-Gm-Features: AclHuK-6UksuhdxLDr9TAfOaW0wWvLdrGSSbX-Xypc8YnbiM9e6657YiYJ8OIwc
Message-ID: <CAEQnVQnHxyMp3Acdu_LCQbL0esYZ3mfjM5kDwtYQdOK9Lk+x=Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: lpfc: fix node use-after-free in rport callbacks
To: Dai Ngo <dai.ngo@oracle.com>
Cc: linux-scsi@vger.kernel.org, mkp@kernel.org, 
	Nigel Kirkland <nigel.kirkland@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000031888e065e36367f"

--00000000000031888e065e36367f
Content-Type: multipart/alternative; boundary="00000000000027d978065e363612"

--00000000000027d978065e363612
Content-Type: text/plain; charset="UTF-8"

Hello Dai,

Broadcom has a competing patch for this, and I would like to compare your
approach to ours. Our patch has extensive test time against multiple OS
distros, platforms, targets, HBAs, and system test fault suites.

I don't agree with the get_device/put_device calls in lpfc. SCSI device
management is the responsibility of the scsi_transport_<fc, sas,...>. And
it should be OK for lpfc to grab a reference upon a successful register and
drop the reference after deregistration. The lpfc_nlp_init reference holds
the node in play until the lpfc_work_list_done removes it.

lpfc's concern is it's ndlp to rport binding only.

This part of lpfc has extensive testing on and your patch extensively
alters its design. I'll need some time to ensure no test regressions.

Thanks
Paul

--00000000000027d978065e363612
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D""><span style=3D"col=
or:rgb(0,0,51);font-family:monospace;white-space:pre-wrap"><font size=3D"3"=
>Hello Dai,</font></span></div><div class=3D"gmail_default" style=3D""><spa=
n style=3D"color:rgb(0,0,51);font-family:monospace;white-space:pre-wrap"><f=
ont size=3D"3"><br></font></span></div><div class=3D"gmail_default" style=
=3D""><span style=3D"color:rgb(0,0,51);font-family:monospace;white-space:pr=
e-wrap"><font size=3D"3">Broadcom has a competing patch for this, and I wou=
ld like to compare your approach to ours.  Our patch has extensive test tim=
e against multiple OS distros, platforms, targets, HBAs, and system test fa=
ult suites.</font></span></div><div class=3D"gmail_default" style=3D""><spa=
n style=3D"color:rgb(0,0,51);font-family:monospace;white-space:pre-wrap"><f=
ont size=3D"3"><br></font></span></div><div class=3D"gmail_default" style=
=3D""><span style=3D"color:rgb(0,0,51);font-family:monospace;white-space:pr=
e-wrap"><font size=3D"3">I don&#39;t agree with the get_device/put_device c=
alls in lpfc.  SCSI device management is the responsibility of the scsi_tra=
nsport_&lt;fc, sas,...&gt;.  And it should be OK for lpfc to grab a referen=
ce upon a successful register and drop the reference after deregistration. =
 The lpfc_nlp_init reference holds the node in play until the lpfc_work_lis=
t_done removes it.</font></span></div><div class=3D"gmail_default" style=3D=
""><span style=3D"color:rgb(0,0,51);font-family:monospace;white-space:pre-w=
rap"><font size=3D"3"><br></font></span></div><div class=3D"gmail_default" =
style=3D""><span style=3D"color:rgb(0,0,51);font-family:monospace;white-spa=
ce:pre-wrap"><font size=3D"3">lpfc&#39;s concern is it&#39;s ndlp to rport =
binding only.</font></span></div><div class=3D"gmail_default" style=3D""><s=
pan style=3D"color:rgb(0,0,51);font-family:monospace;white-space:pre-wrap">=
<font size=3D"3"><br></font></span></div><div class=3D"gmail_default" style=
=3D""><span style=3D"color:rgb(0,0,51);font-family:monospace;white-space:pr=
e-wrap"><font size=3D"3">This part of lpfc has extensive testing on and you=
r patch extensively alters its design.  I&#39;ll need some time to ensure n=
o test regressions.</font></span></div><div class=3D"gmail_default" style=
=3D""><span style=3D"color:rgb(0,0,51);font-family:monospace;white-space:pr=
e-wrap"><font size=3D"3"><br></font></span></div><div class=3D"gmail_defaul=
t" style=3D""><font color=3D"#000033" face=3D"monospace" size=3D"3"><span s=
tyle=3D"white-space-collapse: preserve;">Thanks</span></font></div><div cla=
ss=3D"gmail_default" style=3D""><font color=3D"#000033" face=3D"monospace" =
size=3D"3"><span style=3D"white-space-collapse: preserve;">Paul</span></fon=
t></div><div class=3D"gmail_default" style=3D"font-size:small"><span style=
=3D"color:rgb(0,0,51);font-family:monospace;font-size:13px;white-space:pre-=
wrap"><br></span></div><div class=3D"gmail_default" style=3D"font-size:smal=
l"><br class=3D"gmail-Apple-interchange-newline"></div></div>

--00000000000027d978065e363612--

--00000000000031888e065e36367f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iId6lRoDnFAsEvnaOMvg29iSc9gZaFsMAV8NLrmVgatBLqETEHgQ4n1BrE2+pRoymE80Zf+Qe5W6
GF5zYMjxe2smznZoexz/BISo+5QDZaKZKtmoZ3ApyLjKz1G5Q2hUhmZWHvMu/eGSXP59UaUUmelW
ZlVs3E0h345YpaGuBNlquYm35nQ3ehYjm2jqaIh7F7K0+eF5TPjcMLpqnpak12xIx6BCxmFi8Oqu
Gb9+KrrAD+KPgqzjyZZxdVcCAwEAAaOCAdkwggHVMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8E
AjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxz
aWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDov
L29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EM
AQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwIAYDVR0RBBkwF4EVcGF1bC5l
bHlAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFAApNp5ceroP
ry1QLdugI4UYsKCSMB0GA1UdDgQWBBTc34vK15RY7h33segpWeDeAloTGDANBgkqhkiG9w0BAQsF
AAOCAgEAb0hABkNonbsXXPrDOwB9B9lRtVhdRszakaT0zWubTTtHAV/XTebY1b4caUC2iX9AJvr0
XTJrFAiLtJ6eeP6yQOjD+rBprWauwPUzydJWEftECpX/lbPgZLBSHx22euCSnIm8HNj8o0bMi+Ii
plCW6kU56G1krQY0jrqDJCFgH4Wmp1TrKi36iVTIXyYLDtPOcSXe9hLmeUlQuL4nAoB8EsI45w4a
5Wi/xS7vGQLXzXAQ2SY6Yuseqhh+QcXvzeb0uVB54edC4HFrVX9DtFzHXoyB9s0C29MZm2zpFPNS
DgwnsmTsvpPuLELuuaJvIKnSHHR9FKrmQZbmz/i6KyBt0enmjNk7I7vAKQa8IqZxSrjvR6tYExiq
BP9ZuiXJnuqoPujFE7kphkUjmK76yv8904eZNflTvcEDpthD1boifOzT78iQ3fbuytR8LKx7tzGV
Ga9+dcLBcR/eP85Vmc9NW1frtO3dRd26+DHs1lXX96Em5AAlvBgDw8b1GfyEvfimBkxTIWxR3mBB
jAMkNKrfvV7NxS9AfcFu4fvxuBJc+t2FN1zBc8VyVyn9ZBeJ2DYS9uQ2x00QPXMHqVlAT5fBanmS
n1fgcSTdHEy1fzVZIAtM1XMIWy03bJKNBwUebgxHKHSUCZ7VSMHE4jyERMCqkvTxU6h4JJ7YzRrU
jhXYo8oxggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAyMDIzAgx9OiWw8dVRSIkn
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIMc/ewX9MMFhG7a7qRpoDowccgZD
rggayKbL8DlWKiFvMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MTAxOTE5MDYzMFowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBADSl5uT97l+44c7GBBPVl1ks4Y43YM12Y6oFRWK6OxClR0JrfYhJDSLyu1p5en9l
P8/2H56nY2RiwohCF/pPAeV6DJg5VJHZ9ssLa68uS7MUdouhBHPpUo85afpkH6tzd5pEsS8d7vLX
BsOJ88YVsoyfayRtzuTbDEIpzIdWjjzxiAK4cEfFlPg6n3bHBFsNZi8YFrobjDTjYrvwO5CtlByC
Lt8cAZ6RY1Bli01yGZi19XtkzNmsvi+KkAxUcl3X2NsdwITZ9iqBWGj2i/iW7mpPj9eUJGiWH10c
pYHrdOqsOc2/wMXuIGLBwL0SxDuuv7rGn+Eg2L/+DMkDnKj4n/s=
--00000000000031888e065e36367f--
