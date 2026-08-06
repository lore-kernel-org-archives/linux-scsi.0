Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F162F4C9543;
	Thu,  6 Aug 2026 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043203; cv=none; b=isQKigmKqtkEoaO/ErFxCjcrd0msqXyQpCuTL2EtPzXNukTUEGdeC2mNhnkziHqhtI94EZ8AXx86QBPBVHYbEC1rUzewMGfPJ+t9CYGGExjYEzlJxSWF3TgL2ty87dbaVmLQGm6+0s9bMa02GTrcWBdlrx1v0SIlmPRPS/OjxfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043203; c=relaxed/simple;
	bh=EYpVkQ9dqMXUt77tGQiQReGf9ec0NU6oQ1ZBjJUArT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oBaQ6naxAI+hXBt0esaB6KE7nLF+i+Iv2NqF5ZOMGLNQCQW5IsP1YwlAbd8zqlYsThG2mVeFtP+hRHGXhrxnG/kKvK9fQVIuIZK9szGKSgDVkuHDGhNpZZI+ygNYg6hDjjGbyGuYkd+FcXZjFsVIsx4p1p9yQW+jvwIj2QA03t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S7iZ20kC; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S7iZ20kC"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676Ftnfi3426829;
	Thu, 6 Aug 2026 19:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y2EyQmnDXiMO+KBYyWcf8iTBbNxUMV46wXMjAySCPPk=; b=
	S7iZ20kCXaV6xthJI9aeotqDl5di4yyzA+TVFor9BJqD0UO6xJJqdVSDV0/0V43h
	5sRGJj4RJ/uG2nc55z/p2pxdYF5wcgpEf6ihGLYUUJFFSyszzlxA7MxvN27qAU73
	5BwVsI+atSMuZhXz8wGP8YfwPRsFunCcuC/e7pRO1kDmbTeASxL5tJycZaurP0DL
	G+WG4haZ43kn9uo4ariiOqo/p+ZVnnbeP+pnhXb8zUverEzm4p2tlmg0/zdCYkYg
	bWsZBaA1JekiTB66fl0zxcXq1nP+xHs/UcL7VbDgnE42lACacRSncsjaeoMxtdnb
	ZJIejFF7LwJNgET0nVYIzA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7qaeukj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0dV1024794;
	Thu, 6 Aug 2026 19:06:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:27 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6Lgj011247;
	Thu, 6 Aug 2026 19:06:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-8;
	Thu, 06 Aug 2026 19:06:26 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Peter Wang <peter.wang@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Pan Chuang <panchuang@vivo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ufs: host: Remove redundant dev_err()
Date: Thu,  6 Aug 2026 15:06:13 -0400
Message-ID: <178589207042.336697.5428904830095409055.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717035013.563791-1-panchuang@vivo.com>
References: <20260717035013.563791-1-panchuang@vivo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX1uVfCvDw4m57
 fBn9Rm7NRnY3wmHVapYWzcFIcLBAV/77yBOsqMsIkuAYHlu/0dgHjD/eNraiuVN5+qyrbQeq57S
 62dcQR9HayzsmPC3i7k8FeuqdETxRCRr7YBOLCz/cSqOnsp0csdCYjvTsZMHT9eqTZNGFV2iKNk
 qleY4aFVDD9CnjvSROxphr7EkxVx/H/G8EIl4kg+0AfT52VkfCY+e3NvkvOy2gOjyLPOzVHH70v
 LAkqJ7NS0T+8O4mDSY9f1JRF3YvTV/bZr44LqYps2jofSwfM6Y2s/Gked7HlvKTJpcYhP3hxqrQ
 QmtDLSdR7Q9dITUBpp2MorhizPu3QWkdbcQZa2iIhZ6qRsdSEA2Dq0920NZ1H7Ti3+l4VeUqlys
 N3/s9mTy27gK1HCu4R1GUayTqucPGddTjRKv0m5VedeiB+5vmPo40X7BlWo6wftqVOeGoHmmgpi
 mpr83vRdYeJxEccbsRdXkRTAT1wxIPA6aa2xhdG4=
X-Proofpoint-GUID: 4k1UmZ-IcOhwdXf4lXREHveo7pErMlfR
X-Authority-Analysis: v=2.4 cv=frDsol4f c=1 sm=1 tr=0 ts=6a74db34 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=EHcGivrlkkicjW9g384A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510
X-Proofpoint-ORIG-GUID: 4k1UmZ-IcOhwdXf4lXREHveo7pErMlfR
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX4oHG75xzDa0I
 NHBIjFVUeyS3j9pI+8CuWtk8GwsUOpadLUoOEnKHEPoSNDvSRz0qsnEz/5e8aZyCvZfRDlLwrTz
 b0Xxt5uI6oRQWTNdISgZDr/+vOyIPpMLwJK/lmJuQoJipyWYEG4a

On Fri, 17 Jul 2026 11:50:13 +0800, Pan Chuang wrote:

> Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
> devm_request_*_irq()"), devm_request_irq() automatically logs
> detailed error messages on failure. Remove the now-redundant
> driver-specific dev_err() calls.
> 
> 

Applied to 7.3/scsi-queue, thanks!

[1/1] ufs: host: Remove redundant dev_err()
      https://git.kernel.org/mkp/scsi/c/0cad7bd51301

-- 
Martin K. Petersen
