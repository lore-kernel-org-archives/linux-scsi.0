Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.218.36.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792491907;
	b=ZzkKtK2zZkBM5GjooOOvOe6lJumIBv4LryrD0LfaMTq/HVWFOM4UKDyobucj/cR1u8rw
	 T+R0fVvsAV9vtuij22nm4tB5RhhP4aW11abT25MMoal6ehVBtvBgbe17VriKQRTmpLntV
	 fVhmcBgNQSctKdb1HuBu63tOkYKL0Hr6XpkzEpAERLELaeEvHy7oU0IGMWTsRLxACuA/r
	 cTfEj0Q067ThbGCR3OKdGaYXsRe3AixmED+Unlr8FslKZOSDU/sFWdKUXfM4aQPRGKNte
	 8i210fIUf1tkI9+XHjsFtfPIKJAiPnZ/r6AJCqSo4Fw7wmgWgD/XW9wIz4Vg3RODE4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792491907;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:From:Content-Language:To:Cc:Subject:Content-Type:
	 Content-Transfer-Encoding:X-Last-TLS-Session-Version;
	bh=8g/OFL5UVyVXc0FjEvvApKVC6NGiltcUoF3yC6VVRC8=;
	b=37V8V0YOYNW12TJhLSYEYbNKe05pGW4a+dSMywOlTpzf4k7yuGaIYC7Mya7aGH/usQ+B
	 h9sDwITUPNUA/AgTB3XpP7blbqp2BvLHpAqwGXB1V0/q5nsckACkHtcoaoOmZvRw+01/s
	 XOTiL/DVubrAZ6lmYjrO0IBkhXqamb2GnMu/aJoRKd2Pz0MFtX+0Qzb3mNi+d3mf82Xmk
	 Q7JjPphmMrVggHgrNbr5Liog6f10LxhBwGPPBaTdSZYuxCG1L5+ef34t1eF+3mpC7GrsN
	 Eb+iAsljnOll1WloW3JMY/jesroqSeNe6Xgk6OilKevVHFUqcJbkpr0py/w3kXQ6Pfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=maich.gr;
	spf=pass smtp.mailfrom=maich.gr;
	arc=none smtp.remote-ip=193.218.36.5
Received: from mx.maich.gr (mx.maich.gr [193.218.36.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA55606A319;
	Tue, 20 Oct 2026 10:24:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BA55606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=maich.gr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maich.gr
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3440B7BC1912;
	Tue, 20 Oct 2026 13:24:44 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maich.gr; s=dkim;
	t=1792491887; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language;
	bh=8g/OFL5UVyVXc0FjEvvApKVC6NGiltcUoF3yC6VVRC8=;
	b=ElrfHpvXBgAotjwZhOKZ40JJGadD7F6scC+Lgoik9Cq6rqwAlSfiia/YPs6TJaBrMao9TF
	EHW7xn7gZK7uqlR2rxgJxyGJo+h2cL/41b7sn5ekRe8Oy92L0Wg+MSjX3K5qhdVuxoVCrf
	k1cN6UaV6TKc0gx5qY+015gdYhbQ1+R0XFkUrH9YT8XnAiMdCGRS248+o8TwKXCw/hkbzk
	uMWtGVihMv2py0VlFZMomR1wosH2Gn1+v9EJuBxQDu0HJNj9v5gNUzsa2QfvHLweXo0mzU
	empWbNtyL5TxCtplLTERpij0JmQ4I3KCwPr2/UQmnmIYrJ6XyKudz1xi/+SiRA==
Message-ID: <29f6c901-5209-4681-81cc-ff768cd405f4@maich.gr>
Date: Tue, 20 Oct 2026 13:23:03 +0300
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
From: Alexander Antonakakis <alexis@maich.gr>
Content-Language: en-US, el-en
To: stable@vger.kernel.org
Cc: regressions@lists.linux.dev, linux-scsi@vger.kernel.org,
 gregkh@linuxfoundation.org, sashal@kernel.org
Subject: [REGRESSION] 6.1.178+: lpfc: boot hang due to use-after-free of mboxq
 in lpfc_sli4_driver_resource_setup() backport
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3


Hello,

Since 6.1.178, servers with an Emulex SLI-4 Fibre Channel HBA hang
during boot when the lpfc driver initializes. 6.1.177 works.
6.1.180, 6.1.187 and 6.1.190 (Debian 12 kernels 6.1.0-52 to -54)
all hang in the same way.

Hardware:
 =C2=A0 Emulex LPe31000/LPe32000 Series 16Gb/32Gb Fibre Channel Adapter
 =C2=A0 Firmware 14.4.322.17, sli-4:2:c
 =C2=A0 lpfc 14.2.0.7

The cause appears to be the 6.1.y backport of:

299f5baa1321 ("scsi: lpfc: Fix memory leak in=20
lpfc_sli4_driver_resource_setup()")

upstream commit 1bd28625e25be549ee7c47532e7c3ef91c682410

In mainline, the new mempool_free(mboxq, ...) is placed after the
call to lpfc_get_sli4_parameters(phba, mboxq) and its error check.
In the 6.1.y backport it landed before that call. In
drivers/scsi/lpfc/lpfc_init.c at v6.1.178:

8178:=C2=A0 mempool_free(mboxq, phba->mbox_mem_pool);
8187:=C2=A0 rc =3D lpfc_get_sli4_parameters(phba, mboxq);
8200:=C2=A0 mempool_free(mboxq, phba->mbox_mem_pool);=C2=A0 /* error path */
8207:=C2=A0 mempool_free(mboxq, phba->mbox_mem_pool);=C2=A0 /* error path */

So mboxq is freed, then used for a mailbox command to the HBA
(use-after-free), and may be freed again on the error paths
(double free). This runs on every SLI-4 HBA probe, which matches
the hang about 2 seconds into boot.

Moving the mempool_free() at line 8178 to after the
lpfc_get_sli4_parameters() call and its error handling, as in
mainline, should fix it. Other stable branches that took this
backport may be worth checking for the same placement.

Downstream report: https://bugs.debian.org/1151377

#regzbot introduced: 299f5baa1321a0951cc3ebbacc72b67433a65391

This is a production server, so I can only test during maintenance
windows, but I am happy to test a fix.

Regards,
Alexander Antonakakis

--=20
Alexander Antonakakis
Information Systems Department
Mediterranean Agronomic Institute of Chania (MAICh)
Alsyllio Agrokepiou, 1 Makedonias str, Chania, Crete, 73100 GREECE
=CE=A4. +30 28210 35000 ext.718 | =CE=95. antonakakis@maich.gr

--
=CE=94=CE=B9=CE=B5=CF=85=CE=BA=CF=81=CE=AF=CE=BD=CE=B9=CF=83=CE=B7 =CE=B7=CE=
=BB=CE=B5=CE=BA=CF=84=CF=81=CE=BF=CE=BD=CE=B9=CE=BA=CE=BF=CF=8D =CF=84=CE=B1=
=CF=87=CF=85=CE=B4=CF=81=CE=BF=CE=BC=CE=B5=CE=AF=CE=BF=CF=85
=CE=9F=CE=B9 =CF=80=CE=BB=CE=B7=CF=81=CE=BF=CF=86=CE=BF=CF=81=CE=AF=CE=B5=CF=
=82 =CF=80=CE=BF=CF=85 =CF=83=CF=85=CE=BC=CF=80=CE=B5=CF=81=CE=B9=CE=BB=CE=B1=
=CE=BC=CE=B2=CE=AC=CE=BD=CE=BF=CE=BD=CF=84=CE=B1=CE=B9 =CF=83=CE=B5 =CE=B1=CF=
=85=CF=84=CF=8C =CF=84=CE=BF =CE=BC=CE=AE=CE=BD=CF=85=CE=BC=CE=B1 =CE=B5=CE=AF=
=CE=BD=CE=B1=CE=B9 =CE=B5=CE=BC=CF=80=CE=B9=CF=83=CF=84=CE=B5=CF=85=CF=84=CE=
=B9=CE=BA=CE=AD=CF=82 =CE=BA=CE=B1=CE=B9 =CE=B7 =CF=87=CF=81=CE=AE=CF=83=CE=B7 =
=CF=84=CE=BF=CF=85=CF=82
=CE=B5=CF=80=CE=B9=CF=84=CF=81=CE=AD=CF=80=CE=B5=CF=84=CE=B1=CE=B9 =CE=BC=CF=
=8C=CE=BD=CE=BF=CE=BD =CE=B1=CF=80=CF=8C =CF=84=CE=BF=CE=BD =CE=B1=CE=BD=CE=B1=
=CF=86=CE=B5=CF=81=CF=8C=CE=BC=CE=B5=CE=BD=CE=BF =CF=80=CE=B1=CF=81=CE=B1=CE=
=BB=CE=AE=CF=80=CF=84=CE=B7. =CE=95=CE=AC=CE=BD =CE=AD=CF=87=CE=B5=CF=84=CE=B5 =
=CE=BB=CE=AC=CE=B2=CE=B5=CE=B9 =CF=84=CE=BF =CF=80=CE=B1=CF=81=CF=8C=CE=BD =CE=
=BC=CE=AE=CE=BD=CF=85=CE=BC=CE=B1 =CE=B1=CF=80=CF=8C =CE=BB=CE=AC=CE=B8=CE=BF=
=CF=82 =CE=BA=CE=B1=CE=B9 =CE=B4=CE=B5=CE=BD
=CE=B5=CE=AF=CF=83=CF=84=CE=B5 =CE=BF =CF=80=CF=81=CE=BF=CE=BF=CF=81=CE=B9=CE=
=B6=CF=8C=CE=BC=CE=B5=CE=BD=CE=BF=CF=82 =CF=80=CE=B1=CF=81=CE=B1=CE=BB=CE=AE=
=CF=80=CF=84=CE=B7=CF=82, =CF=83=CE=B1=CF=82 =CE=B5=CE=BD=CE=B7=CE=BC=CE=B5=CF=
=81=CF=8E=CE=BD=CE=BF=CF=85=CE=BC=CE=B5 =CF=8C=CF=84=CE=B9 =CE=B1=CF=80=CE=BF=
=CE=BA=CE=AC=CE=BB=CF=85=CF=88=CE=B7, =CE=B1=CE=BD=CE=B1=CF=80=CE=B1=CF=81=CE=
=B1=CE=B3=CF=89=CE=B3=CE=AE, =CE=B4=CE=B9=CE=B1=CE=BD=CE=BF=CE=BC=CE=AE =CE=AE =
=CE=BF=CF=80=CE=BF=CE=B9=CE=B1=CF=83=CE=B4=CE=AE=CF=80=CE=BF=CF=84=CE=B5
=CE=AC=CE=BB=CE=BB=CE=B7=CF=82 =CE=BC=CE=BF=CF=81=CF=86=CE=AE=CF=82 =CF=87=CF=
=81=CE=AE=CF=83=CE=B7 =CF=84=CF=89=CE=BD =CF=80=CE=B5=CF=81=CE=B9=CE=B5=CF=87=
=CE=BF=CE=BC=CE=AD=CE=BD=CF=89=CE=BD =CF=84=CE=BF=CF=85 =CF=80=CE=B1=CF=81=CF=
=8C=CE=BD=CF=84=CE=BF=CF=82 =CE=BC=CE=B7=CE=BD=CF=8D=CE=BC=CE=B1=CF=84=CE=BF=
=CF=82 =CE=B1=CF=80=CE=B1=CE=B3=CE=BF=CF=81=CE=B5=CF=8D=CE=B5=CF=84=CE=B1=CE=
=B9. =CE=95=CF=80=CE=AF=CF=83=CE=B7=CF=82 =CF=80=CE=B1=CF=81=CE=B1=CE=BA=CE=B1=
=CE=BB=CE=B5=CE=AF=CF=83=CE=B8=CE=B5 =CE=BD=CE=B1
=CE=B1=CF=80=CE=BF=CF=83=CF=84=CE=B5=CE=AF=CE=BB=CE=B5=CF=84=CE=B5 =CF=84=CE=
=BF =CE=B1=CF=81=CF=87=CE=B9=CE=BA=CF=8C =CE=BC=CE=AE=CE=BD=CF=85=CE=BC=CE=B1 =
=CF=83=CF=84=CE=B7=CE=BD =CE=B4=CE=B9=CE=B5=CF=8D=CE=B8=CF=85=CE=BD=CF=83=CE=
=B7 =CF=84=CE=BF=CF=85 =CE=B1=CF=80=CE=BF=CF=83=CF=84=CE=BF=CE=BB=CE=AD=CE=B1, =
=CE=BA=CE=B1=CE=B8=CF=8E=CF=82 =CE=BA=CE=B1=CE=B9 =CF=83=CF=84=CE=B7 =CF=83=CF=
=85=CE=BD=CE=AD=CF=87=CE=B5=CE=B9=CE=B1 =CE=BD=CE=B1 =CE=B4=CE=B9=CE=B1=CE=B3=
=CF=81=CE=AC=CF=88=CE=B5=CF=84=CE=B5 =CF=84=CE=BF
=CE=BC=CE=AE=CE=BD=CF=85=CE=BC=CE=B1 =CE=B1=CF=80=CF=8C =CF=84=CE=BF =CF=83=CF=
=8D=CF=83=CF=84=CE=B7=CE=BC=CE=AC =CF=83=CE=B1=CF=82.
=CE=97 =CE=B5=CF=80=CE=B9=CE=BA=CE=BF=CE=B9=CE=BD=CF=89=CE=BD=CE=AF=CE=B1 =CE=
=BC=CE=AD=CF=83=CF=89 Internet =CE=B4=CE=B5=CE=BD =CE=B5=CE=AF=CE=BD=CE=B1=CE=
=B9 =CE=B1=CF=83=CF=86=CE=B1=CE=BB=CE=AE=CF=82 =CE=BA=CE=B1=CE=B9 =CE=B5=CF=80=
=CE=BF=CE=BC=CE=AD=CE=BD=CF=89=CF=82 =CF=84=CE=BF =CE=9C=CE=91=CE=99=CE=A7 =CE=
=B4=CE=B5=CE=BD =CF=86=CE=AD=CF=81=CE=B5=CE=B9 =CE=B5=CF=85=CE=B8=CF=8D=CE=BD=
=CE=B7 =CE=B3=CE=B9=CE=B1 =CE=BF=CF=80=CE=BF=CE=B9=CE=B1=CE=B4=CE=AE=CF=80=CE=
=BF=CF=84=CE=B5
=CE=B8=CE=B5=CF=84=CE=B9=CE=BA=CE=AE =CE=AE =CE=B1=CF=80=CE=BF=CE=B8=CE=B5=CF=
=84=CE=B9=CE=BA=CE=AE =CE=B6=CE=B7=CE=BC=CE=B9=CE=AC =CF=80=CE=BF=CF=85 =CF=80=
=CF=81=CE=BF=CE=BA=CE=BB=CE=AE=CE=B8=CE=B7=CE=BA=CE=B5 =CE=B1=CF=80=CF=8C =CF=
=84=CE=B7=CE=BD =CF=87=CF=81=CE=AE=CF=83=CE=B7 =CF=84=CE=BF=CF=85 =CF=80=CE=B1=
=CF=81=CF=8C=CE=BD=CF=84=CE=BF=CF=82 =CE=AE =CF=84=CF=89=CE=BD =CF=83=CF=85=CE=
=BD=CE=B7=CE=BC=CE=BC=CE=AD=CE=BD=CF=89=CE=BD =CF=84=CE=BF=CF=85 =CE=BB=CF=8C=
=CE=B3=CF=89 =CE=B9=CF=8E=CE=BD =CF=80=CE=BF=CF=85
=CE=AD=CF=87=CE=BF=CF=85=CE=BD =CF=80=CE=B5=CF=81=CE=AC=CF=83=CE=B5=CE=B9 =CF=
=83=CE=B5 =CE=B1=CF=85=CF=84=CE=AC.

Email Disclaimer
The information in this email is confidential and is intended solely for the ad=
dressee(s). If you have
received this transmission in error, and you are not an intended recipient, be =
aware that any
disclosure, copying, distribution or use of this transmission or its contents i=
s prohibited.
Furthermore, you are kindly requested to send us back the original message to t=
he sender=E2=80=99s address and
delete the message from your system immediately.
Internet communications are not secure and therefore MAICh does not accept lega=
l responsibility for the
contents of this message and for any damage whatsoever that is caused by viruse=
s being passed.



