Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE8223B609
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2025 06:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750140486; cv=none; b=Ry0zW6w+gFi7h/9+dbq/aB4wdZqeK9RM2iD6JAz2KSyhqW3AZglw4d9uAmEby171GZyYf4sY3hfZgOqgPi90W1STaU+89CWWi2vPycLjoPdfOrlQdQNoSZUmRzNrobtZBPORIUcfV+MXiPQRNMjKcORKGKfgMptjbm1LJ1PN//w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750140486; c=relaxed/simple;
	bh=RQxAUueWgaPqFnMRAuc+niE6bZRWPqcJYaCwRr2h3dc=;
	h=From:To:Subject:Mime-Version:Content-Type:Date:Message-ID; b=tgtL9B18A2xZLw57tVSBSQgDmL0uXBVTRSOyx5E1AyY6b/5i4QLsbFxmBsvYmdHg2Z7qCXRinKhVWSKgxSUfVZYpCbjtalQKIbaa81ptH5QiJjglQyDase2Hv/awpisCsZti9AnGGMRrVzUqOIXGVJB8m2ZPFmQUCHSeEeRc2KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=FQd62vKH; arc=none smtp.client-ip=43.163.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="FQd62vKH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1750140171; bh=RQxAUueWgaPqFnMRAuc+niE6bZRWPqcJYaCwRr2h3dc=;
	h=From:To:Subject:Date;
	b=FQd62vKHjx1AAQiJGD6L6D6f75SrUZkySlJnyj6XfJdkHiWKF5QSoxFz8XhzISGGh
	 MXdPNqz3opn5sMEOcE6oRFxCWglbyI5UU+OergiUnZ7v3//dLdc4WPU/eyBe3Mn7NT
	 v5ZgXml7/NppBSm25FoQeQsC1q9cG/ZNMpNnOyxE=
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-QQ-XMAILINFO: Mu4fz8q1FCY31OiVSnXHrUEBqjbEXozU+8HL1XWGO/atWpYMLisRnQD//aJ5iI
	 JhB7fU0nqzVYfTpn1uS0fPSizWDD7Yrkq/tdvsuZdeeO377ulDH3flEpOFKD70vC4tML0ZbMVuild
	 GPEe0KSWtQw+PJDp45UEePGhV+ALUnvaMmomPPvcYlZ2cFKEbOkTJ4t4mvhO/+bXkQdagt7SKUHIi
	 slCUF8Xf65qW1WDKm1dEu3lUgCBWq6GLpMuzvfp5O5kmOr3/O+h0Dp1bj4uDtBdiqkNWb2HRm9Ynm
	 5mW1WZuFQP/l+t2WdfevvqRDYzgX6YS4eQHzRkR6nFlX1PiJXf7GWfXwv9No8M4GCTXmmRWj/2XUz
	 zLASzACwiSZ3d9DZobRJ8Mf4bH/hfa1rZYKLpxDzJpldUCzVTARtkFm2KPh5wp8JrykVqwM6ZENUt
	 9wivmuNAW9bblQKw0Vc1CFSs+/2vCdGlssUF34etAt0+Epn72mb8SvcC9PXgjDCtJPxmm8GefIcqA
	 udx+Psek62VVDHDPKP9/gfxzzXbd73p4IfueOo1UTKz/K9zfJUVpb6+enFmAqmnMZTN7AZ3lPumTi
	 7he+svuoglMHKB7plIvPAOIqH0NKbtgGB0BdW3GcnHiV0QUOAo42AVsQLvXHze+Jm2cEtDDTzZrv3
	 cIAjoQNh+iRpxBkQ8TExZSY4VrmHbPbi126nTGj0o+HnnzERvvVytxig8NiGyAN/UpzwkLYnlsLy0
	 07MhqovPtdNgAY29j1CvsF4ULsSSACY3oV9lAgOk4f/QTnCB2eftLUMMIR8HUxcn4ukyjagZnhn9e
	 fUoXY3X0tpvORF+z5dfT9ban+Ju6cbIapbr0XdPisTrMouR4ae2SlPGNE1PioVFgLZ9G1fK3Gh6MH
	 mZbVWwnUyUihCN0PkEYE2jJQZ65AQ0UVNF+y3Oo3l8SX5hCoOjc3kyCpeXoT+0AGJ1lH3gsh3a+OH
	 RsTGtoLr82QpTK12Nh9ljNTzdGqy27kQvGhSOnZQ==
From: "=?utf-8?B?5YiY5oCd5rSL?=" <1972843537@qq.com>
To: "=?utf-8?B?bWFydGluLnBldGVyc2Vu?=" <martin.petersen@oracle.com>, "=?utf-8?B?amFtZXMuYm90dG9tbGV5?=" <james.bottomley@hansenpartnership.com>, "=?utf-8?B?bGludXgtc2NzaQ==?=" <linux-scsi@vger.kernel.org>
Subject: out of bounds vulnerability report
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Tue, 17 Jun 2025 14:02:50 +0800
X-Priority: 3
Message-ID: <tencent_7F75B81FB786FE5B493FEFF7CD8528636908@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-QQ-mid: xmsepub6-1t1750140170t3bkgfrjx

SSBmb3VuZCBhIG91dC1vZi1ib3VuZHMgdnVsbmVyYWJpbGl0eSBpbiAvbGludXgvZHJpdmVy
cy9zY3NpL3NkLmPCoCwgc2RfcmVhZF9ibG9ja19saW1pdHNfZXh0wqBGdW5jdGlvbiBEdWUg
dG8gVW5yZWFzb25hYmxlIGJvdW5kYXJ5IGNoZWNrcy4KCm91dC1vZi1ib3VuZHMgcmVhZCB2
dWxuZXJhYmlsaXR5IGV4aXN0cyBpbiB0aGUgTGludXgga2VybmVsJ3MgU0NTSSBkaXNrIGRy
aXZlciAoZHJpdmVycy9zY3NpL3NkLmMpLiBUaGUgZmxhdyBvY2N1cnMgaW4gdGhlIHNkX3Jl
YWRfYmxvY2tfbGltaXRzX2V4dMKgZnVuY3Rpb24gd2hlbiBwcm9jZXNzaW5nIFZpdGFsIFBy
b2R1Y3QgRGF0YSAoVlBEKSBwYWdlIEI3IChCbG9jayBMaW1pdHMgRXh0ZW5zaW9uKSByZXNw
b25zZXMgZnJvbSBzdG9yYWdlIGRldmljZXMKClRoZSB2dWxuZXJhYmlsaXR5wqBjYW4gYmUg
Zml4ZWQgYnkgY2hhbmdpbmcgdGhlIGJvdW5kYXJ5IGNoZWNrcyBmcm9twqAyIHRvIDYKCsKg
IHJjdV9yZWFkX2xvY2soKTsKwqAgdnBkID0gcmN1X2RlcmVmZXJlbmNlKHNka3AtPmRldmlj
ZS0+dnBkX3BnYjcpOwotIGlmwqAodnBkICYmIHZwZC0+bGVuID49IDIpCisgaWbCoCh2cGQg
JibCoHZwZC0+bGVuwqA+PcKgNikKc2RrcC0+cnNjcyA9IHZwZC0+ZGF0YVs1XSAmIDE7CsKg
IHJjdV9yZWFkX3VubG9jaygpOwoKCgoKCgoJCuWImOaAnea0iwoxOTcyODQzNTM3QHFxLmNv
bQoKCgo=

