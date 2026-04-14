Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EEB315D39;
	Tue, 14 Apr 2026 02:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776133181; cv=none; b=uru/vVK5sTQIf+aF06geUbIwBDBFvxsnfgIkY7uORlTkCErLBwE28fWZEGpKJCUjNl4cfxYJMYJ79r/a1VTl7hkvccnpHSmpgWsle6glrraiLLP1TEoKc9s6TxaVEJAs+FHTI2/RqFX90/D1apyihlQtql4zYlZQ2lk5RJPJgQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776133181; c=relaxed/simple;
	bh=FeV+V0wfi2zNvZ/AzbNffq/bU2r3NWzrpKtrX8SO4bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VEs5zd5kgFlL84JfCFQH1DUZNHnmLO9XJzSu/t7Dk0lIiTrLpiE5RlfIkvvj8aMiqmREYW+sdAi3611DAJfNKAZRvKHQBpxf7izYtE6hyMkq789xbi1FqP0g02kMndHXhty01x+MDcbAoPhnQQIeSgFA8/3fXaSH5ep0KKSle/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i6NAcOTS; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i6NAcOTS"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLEdee3851803;
	Tue, 14 Apr 2026 02:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FlpNRHAnC9O8VZaDSxdGXleT+6YAJPJFK+TGoggj6Ng=; b=
	i6NAcOTS+pImv/xFXDXb4zOBGsmgyrKLQqPpHY9sRzdluVY/B8aBfx1cWCCtchY8
	mEhCtbXsg/TAVgW/tg56Z15ieTQnVIe3/On7HAdrXj5TGb3W8AEfQLdjgae6lwQq
	0KoZvTpNFVrNYAVSiE+F1BL8k/ONLi0Ylf9jsthjLGW9hr9MsHWMcog9V2sWySU9
	XZUbXsv9bOTISfkKrIwcmZ78mjmSkjkZzhMrpjJj8kSdP8w2PdgXU2uqT1FmKIEW
	E/fIXXPQTZyE5tKiKxv/gQoukaVKSOv4jRztwn5V8ypyVd4f9CKs0wW4DDu036w9
	wz+/ihrP7nqflube/nN6Sw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87m8ag5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E2EJvq023486;
	Tue, 14 Apr 2026 02:19:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nj0nv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:34 +0000 (GMT)
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63E2JTjl036955;
	Tue, 14 Apr 2026 02:19:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dh7nj0nr0-6;
	Tue, 14 Apr 2026 02:19:33 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: target-devel@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: Re: [PATCH] scsi: target: don't validate ignored fields in PROUT PREEMPT
Date: Mon, 13 Apr 2026 22:19:20 -0400
Message-ID: <177595422538.3963380.16931848962227627439.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402180342.126583-1-stefanha@redhat.com>
References: <20260402180342.126583-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=726 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604140019
X-Authority-Analysis: v=2.4 cv=JKYLdcKb c=1 sm=1 tr=0 ts=69dda437 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=pV3RoMUzVIGkC2iK5J8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: QQGf8eCM9Z659G2XH1KwvaZlwTn1TyRs
X-Proofpoint-GUID: QQGf8eCM9Z659G2XH1KwvaZlwTn1TyRs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAyMCBTYWx0ZWRfXyPyrVwXDfGYk
 VmRt01X5aD+SFWFqjO6uUD3QTno+2W6UTvOZIMiht+dDj8iyCxqsmsok6ZoUxPSVMLMFhEsQee9
 e3WW4X9K1yulWA6tCKrrrkpA0BxwZi4PLLEgawelzpO3sWjczTmRik5pmVlEbZtqz/OGWFgJ2Cq
 W9tOkaGwL4Rtd/zDsYv2MeGDTfReV6U9AoRWB9VQ1n0AuqbT0+CzGf9qOZ2uQdbXaTxraimyIRC
 iaIbw7OlRkb6mEYO1TrXY+OmQ01g+Q9/RyPOOZ246sUTwjeOZaP9/M0OOZvUxv6A1IZP8XZWdFc
 LflV3q8ME8WTQg1LC8N8t3pkfGqoKSlKIJ8UXKO07FwoLZhWr/d+WnqJ1aqoziYl+oJnqAz1FTj
 8nRx9LlbxSW2aIgfJEpJYbXhwGvb3dpsCS69Vw29W2uN+qWCC5orNpFqgfS74Vkw1ohBZZ3i+ih
 pq556TgepRFXTZLJZoQ==

On Thu, 02 Apr 2026 14:03:42 -0400, Stefan Hajnoczi wrote:

> The PERSISTENT RESERVE OUT command's PREEMPT service action provides two
> different functions: 1. preempting persistent reservations and 2.
> removing registrations. In the latter case the spec says:
> 
>   b) ignore the contents of the SCOPE field and the TYPE field;
> 
> The code currently validates the SCOPE and TYPE fields even when PREEMPT
> is called to remove registrations.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: target: don't validate ignored fields in PROUT PREEMPT
      https://git.kernel.org/mkp/scsi/c/070ec6f69141

-- 
Martin K. Petersen
