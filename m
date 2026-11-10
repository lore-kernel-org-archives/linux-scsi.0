Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794345823;
	b=eEpurrKsxHNRka66PbyxzwYuShADRv7u/0KTN4+0LkIOs0d2saAXg/iFPFN1qVcMRiol
	 ilz9F/H7R5++eOWL9L7//YQJ1YSEDMKJMVdmPs4z9SAMp+jgrXWNSzkP9O5XcRwDK1bSX
	 7r8cACmReyCk6urrgejAmmnggrh0lJSF9afaujcxW5yJywKHCtr4hPhrISPEQZJ4OABO4
	 9KHdZNx6EpoQt4rHcC36ww6mlaJ6bcW8+N39ISbcnLbpsVB6OsHNQ6v/cqSzoxqdmfnko
	 SHuzZ6/eIqAmYy0In88SjvlIPIgBGJD7JwvjHDgTanWDHX0TSiaNZeWPM2QTH/YIuHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794345823;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=AFWLtP5kiKPMmVsklHz6N0uEqo9lqJb+MRW+b7VeZ+0=;
	b=W93OrhqznOsdMGacy9/mJi8vLUkviHIXt5lzz2i72IiSQT+LQrWJfnlK6dKqU6LYQDUZ
	 qUOGb6+HIYWce8kZX7QNHFS6qi27qjUfdLaBoHW8OTM26P41noG3lyWX1UitJZFimYQHe
	 5fzVxWfbfb+w4sbQpkHJTESYVxzEpkTpch779Wb1kWOP1OZs6uJcDww3xGeBSihmV4tZF
	 coy6tD4XJ/xhY0JaVRrFnNlV7y1FfvjmSKsVAMecUwYdxJS5DChdbfD//3KL3ieemWq+l
	 +kJKEiVBsA4MfXkNVhirGM8QRZgNPnV5yrTbkRkfkuJdFofaOAspmp/FX/nH7LGJklA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=nndiHop+;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=d0roIc0X;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7062F606A327
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 21:23:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7062F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=nndiHop+;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=d0roIc0X
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAKS030661706
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 16:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=AFWLtP5kiKPMmVsklHz6N0uEqo
	9lqJb+MRW+b7VeZ+0=; b=nndiHop+pJB5gWcqgn1Z4LLq1L7RuWoaRk8nKvy0mp
	mOR73xNyBTSAdlRzgcdXCiP4OIlWUe/nMwJ7GXyprtH0wlnEf7gFanodd7drZ7Aj
	SDSsmByRzL4aomnLOy8hDU8IbSCT5dGsUK0q4MoNU6ijZaXfj1HbnfIILqmBnosc
	brshmPDomf51LVrG18Zk/9pt/DLpGibimJgxKxavizx5nVc72CvWaGjSzEUoHA0o
	Km3fasyz6cJmvet6zB2JA8kGI0kNzL97q+6Xg4uHSuJjmS/Z8fYUjhE+7q9uk739
	2x3tXG/S34MzYbAebe6LgtN10mFkerkzoSlZKffsovaw==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hv4xkv5qm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 16:23:41 -0500 (EST)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91eb16ea5c3so67809646d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 13:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794345820; x=1794950620; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AFWLtP5kiKPMmVsklHz6N0uEqo9lqJb+MRW+b7VeZ+0=;
        b=d0roIc0XsD8WFQAsMNwmg5UnbkEetjZZrPzKuzwT+Io+GLxFinqhurnFy8rR9tdSvR
         KmfXlJHjgoYXGkWVt+ml8JOzOQgZthxtaMs4gDAoYnK9AylwjdTiE/vob3lrxY8OZc4z
         We5SjeuWHfpz2xg5PE3UDLHn2DNrpTAnklTevmZqS5SBesjzlWQ6pPi40CYp2Eh0D+5x
         zpeYf3ESekrv2nfRUtX95RLa+p+8DJ24rNHQoDS8z2vdT2dsHPi6tpplWlH86BFLTyCM
         yHLnyTay2v69tUJLVXaAdwtsSAgqE7X6c8XdnuS50bALeeNlscdiTmlgidjk/sxM42Lv
         dGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794345820; x=1794950620;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AFWLtP5kiKPMmVsklHz6N0uEqo9lqJb+MRW+b7VeZ+0=;
        b=jIWZ74IypF662LSOZlUObYVSIFhbdVoZ3mPWmcIbZWoyt6l5a2+WOffjLMb/J9qq47
         +yz782L8aDP1nbbIXEJm2APqP5CeJGWcgTxCN3YX4OF5udaB6GQWTd0IjsTNbMQXpQUO
         mumUkIcpIs/GuaMbh0jbbDQMbAa+H2QF5lBH4oROnu00MRezIpt9ZBvjInHHR3ncRssm
         7s7lKG3IWbdstJCFKYhinBXZplm5y7qCE8c2mXAbhJtXda25EnEvdvS6YfMUhtVAagqt
         C3dR6r5P7KmNUAfbEkfa8dmzYcBbMwZ8BYAZmf3sZFsPsLF8ybOWIRZ2IAlA2+zty9VB
         t4Og==
X-Gm-Message-State: APuU4Z9vp5dqPKFsP5YfyJUY00qBNXtD2CT7noVzU5Kx7hUX0v/kbxse
	utvvN2yoCSu/b6mYQA/VsPxqI6X7uB0ic7rInXcT8EZNyxLL7OMyOGmbj9xDXf8euUKHI+zh8n/
	4F1fYn9DwcZ8THV7exEoubmTsdAMcOlT2ZyzCVzNvLkfKAps4QurmLpkrXdm1oOOtW7Y=
X-Gm-Gg: AYBFou2ltwz3DS09NCHHMM4wFKLU5QrsEap0u/XaiJfbUzOR8uPUMpkp2K/idyRPPSY
	0xvnTbUVm8ADZRqV2CPq418Kec372YZ1rOglQePOWJRYuBVRzvljBftNxXLATCHnnnbLjdHsTaq
	FXbiLjf4emRuCvwCDpWD7vwP9joGNd7PvTKrgKjvd7sJwnMssd6mFuCm/fMxocs+a8nU0QJG87U
	zAsxDsAkSUqo6GsGywSp3GG4luXCIqeJbytDBHFReHa5zPT1at0MNJTGSrJdd26isPTFNm9tune
	E7NC1lwZBSsGIT7Nfpm0UgVvQMlCa3Fn9rdvCA70+/zSgfc7t56nxTEc1k+KUbUPSltjZ8ZM/uf
	HUCCtYeV07p63noa1dy9AmOLWPAsAReA444+AXf46m+S0XhhNtenlaK6bGAw=
X-Received: by 2002:ad4:5fc7:0:b0:91e:a05f:25e3 with SMTP id 6a1803df08f44-91f04001c7fmr11366636d6.20.1794345820352;
        Tue, 10 Nov 2026 13:23:40 -0800 (PST)
X-Received: by 2002:ad4:5fc7:0:b0:91e:a05f:25e3 with SMTP id 6a1803df08f44-91f04001c7fmr11366116d6.20.1794345819696;
        Tue, 10 Nov 2026 13:23:39 -0800 (PST)
Received: from [127.0.1.1] ([129.236.231.168])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f00f6eb88sm10024766d6.39.2026.11.10.13.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 13:23:39 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/2] scsi: scsi_debug: fix zone reset with virtual_gb and
 DIX
Date: Tue, 10 Nov 2026 16:23:29 -0500
Message-Id: <20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFGL82oC/yXMMQ6CQBBG4auQqZ2EJaDAVYwFzP7gUCxkBwyRc
 HdXLb/ivYMMUWHUZgdFvNR0DgnukpE8uzCC1SdTkRdX5/KGTUzZo99Gfs8BHGFY2ZWDVPVNGl9
 WlNolYtD9970//ratnyDrd0bn+QHuikIoeQAAAA==
X-Change-ID: 20261109-scsi-debug-zone-reset-14fc587c9d45
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794345818; l=1003;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=AUoD3CVvBqOYNEJ3z70qfDFWLbDBTifU4lDJRS1G0ZU=;
 b=kBrFE8REW5pyFGDTXeT8yi/q0M7OuPgrIlX3Zb6Fc4jEuKVZ3EfvpKc2yiTfIzEZShvL/vHQk
 HJdNMl8TZlTDKAI5fTs0v+aamvKWf0/B5dNBVzWwRMeGyYtMNdaqH6S
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: 5TXMHg9b_PUkg9OcbsElbhD3xLD9y0VE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA4NSBTYWx0ZWRfX8MsA6c7zkFaK
 +fJH0aJDzj/sN7JcG7gqBRpF2yfcBeUf3e+VSicVdDODbpherwXQi7Io1/nposmhSCBteHft/+3
 CMnQpzvwnVmvAyO3QVP2zakjtaQrro4nm3HpuuSFwNS7RJqMGuqGin3j3tQKLlpC/ICV9gcAEwa
 geJJzh0LVWdq+hfbPwfW4hqarV92Rmd72KAP4BcGJYfybHHO16Ic0eIfMpdqoetSdSlax0G7G6W
 Nm1N8g+KjctLiySXrym89FjtnH29XziGLtwynXlO4aBPNzlocw91xwO2T2YZe72YBKBcZZkrCHw
 vNopZFxJs5F8R+UfMc7ng5VijkuaW9922JoLbUA4iLWg4qXCfNgbM2Hs9GYImuOQfq3KhD92D0o
 Ahz7XX/2MbJF5/ag2kg4hlwq/d2GsmOd3P7IFnjuR/ZgHBAkKGRNE5nBiam0Am+gJ2nNlauEbns
 TStV5gh71QJGPBxDEQw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA4NSBTYWx0ZWRfX/fhhqhxmmwcA
 Y0izV4nJdc3KDT+ndf/uCgunKPSYhlmxXYoMKncnlkvIFjMlDZ+aDs2RQ+U95MNqy4xjl2XhYVY
 KmI2edXZKevJKvRjdnaPQW9tnl5M24BkUoKXpOJdda5Rmu4WkjqB
X-Proofpoint-GUID: 5TXMHg9b_PUkg9OcbsElbhD3xLD9y0VE
X-Authority-Analysis: v=2.4 cv=Uf7E26SN c=1 sm=1 tr=0 ts=6af38b5d cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=lHGGv15rhlN7Yv6qcqrt9g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=aM_X35XmSQlPpTYI4kgA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11962
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 impostorscore=10
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=10 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611100085

Resetting a written zone on scsi_debug zeroes the zone's blocks in the
store, but does so with a raw offset that doesn't wrap around the store
like writes do, and without resetting the blocks' protection
information. With virtual_gb set, resetting a zone that starts past the
end of the store oopses. With DIX enabled, a reset zone can't be read
back. The first patch makes the reset wrap around the end of the store
like writes do. The second resets the protection information of the
zeroed blocks.

The fixes were proposed by an LLM.

---
Tal Zussman (2):
      scsi: scsi_debug: wrap around the store when zeroing a reset zone
      scsi: scsi_debug: reset protection information on zone reset

 drivers/scsi/scsi_debug.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261109-scsi-debug-zone-reset-14fc587c9d45

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

