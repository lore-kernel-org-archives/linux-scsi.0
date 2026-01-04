Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160362F616C;
	Sun,  4 Jan 2026 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767562988; cv=none; b=h+Cktl8cRNdDqa1eeRn94jG5/jIs93bb1R0dK9/SjecfUTuueQFz+hI+uM5493n5woXnRmJXviWD35yiNLBx+3gp16ruOUxMQH7v/v6tELswrR9ey9amXQV7B6y8RtUEQtaZCG6DWvHfSKs0hWMQHFkD4dztNQRuInpKr1cyFiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767562988; c=relaxed/simple;
	bh=aVZq4eYpp/hO8f6f5uVbLUJTYB3zneT7EFk08mmeOLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbAhClLXOWU0Qt5Zkr6nJUSz7fRAAy28Z8cNNP6oFg2ywvS+QTQoOoKgyHxIpAfnHVA5aO3pihX8LAjq6iw/qr6KiDAQi8dQoDWbNi+ajNauZaAZeo9+owIZNHOlZyRIV9RgzYetTf/mFdV8SThExu+DNS2/5sfGfz9NLhwTvq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gKRYdO5E; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gKRYdO5E"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604L3MdA4144301;
	Sun, 4 Jan 2026 21:42:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kJ9hvaIgQkb2Ldds6KzrQ1Gqe9ey1L/CjFXEAMQEWtM=; b=
	gKRYdO5Ei96WSxyfQ75p5+FfyGkrcQ177jtCrBpf7NZpmR7DBRtudBI6ApxHWtAK
	2dxEwa9doM0SN28POZsv/q+PHWmZzeOwjV5wSKw8Z2bcpnxBbeZkaBOY5JIBRR79
	QfphensM58H5pmyuUd96XVykZ1TfRdINy/Nds9KhKRddeX37c2k4nMYDLEI5eYKB
	a86rQA1t5u3olrmuZnD1cFDcQ46vjna0xkGjMHuT+HseJciGxhLN0HYqZlunYdea
	b/I1Gzel9ae1M66FNjkV7W2bpzd/8592RQgfwW2e+i6wio8Em5celMIzmBP3SOHF
	qPmVI5z0Z+Zlg1uh3uywCw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev6ngxwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GXW1O030837;
	Sun, 4 Jan 2026 21:42:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjarf2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:52 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LgpIo034017;
	Sun, 4 Jan 2026 21:42:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjarf2n-2;
	Sun, 04 Jan 2026 21:42:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Peter Wang <peter.wang@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: host: mediatek: make read-only array scale_us static const
Date: Sun,  4 Jan 2026 16:42:42 -0500
Message-ID: <176756271713.1812936.16233360275459977513.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251219214428.492744-1-colin.i.king@gmail.com>
References: <20251219214428.492744-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040199
X-Proofpoint-ORIG-GUID: rdbf5b7C6LSRjtelOVvQBuVBo-52Jzyo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX3DMDsQH9i3eP
 K72TDB1rXgB+fizy4hpq6EU+U3E6Hdl6X+QRag1hlF+e8+II1ZIfstSvs+4uzL1jAQXhOzn+z1v
 wT3GZENzc4EMcb2zTmYgm0pchMQez3G/U49L16XJUI/Q8ap2CAevhXncIDQJSA5TXs2ZO1pPCHv
 i8mxxDcvPz3Xg/NAvsM61GwHUaz+M+PnGrSovnQmr90GmScAa6TOnmQZUX/2dUYqoUWGpEnQRmS
 uWVBUz6e2R07fJU+PyaEfgoxOT9VDTg0vr20lg1ArOhzZbpz0i+4lrA+yFcwN4ul3gtdEMrEhdr
 DdSnmsHtR3tyNxyHFpxn8TNGwzQjQMj4HX4Dfp4IYrmIB5+HBraRlnADxDPzqC7HvU1eAVGBty8
 bvlSZaj+BD95SgwyPHGuYn9ZJmwJtO+S7ce9cZd9PAw/M6uHIF5w444ebR5Eu89KMlbROYGRwNh
 YY9ea6DMOYxttU3kh26Tx0X2D1ymHpuvv2AaWB9k=
X-Proofpoint-GUID: rdbf5b7C6LSRjtelOVvQBuVBo-52Jzyo
X-Authority-Analysis: v=2.4 cv=QtFTHFyd c=1 sm=1 tr=0 ts=695adedd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=ymggwW1gcb6NkITVt5gA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13654

On Fri, 19 Dec 2025 21:44:28 +0000, Colin Ian King wrote:

> Don't populate the read-only array scale_us on the stack at run time,
> instead make it static const.
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: ufs: host: mediatek: make read-only array scale_us static const
      https://git.kernel.org/mkp/scsi/c/309a29b5965a

-- 
Martin K. Petersen
