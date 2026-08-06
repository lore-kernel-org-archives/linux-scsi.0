Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD24389DE3;
	Thu,  6 Aug 2026 19:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043193; cv=none; b=aLUwIYpgqtk5SUCfUdENqk9SWBAhA8KIztdwksc4fGPfzlR3CY2R7ptQIFIR6xWv9/ge0reQsnuaZN9O07njOWH+1I/3CJXmbwPhx7Z3WMQ9M13+i6CUP8BcIdErBQOc7alIi5atK+XFNx0KfIG+AhkRUihKfd9YPoX00Vos5cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043193; c=relaxed/simple;
	bh=1+vhjxpSoOSM2f/Eu0pI3/G080IbB/+M5pKoKt2EX3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldqPCVgU9sg+h0CF5rKem+okpKClZsfgM/hPIhyNJ4SR0L+AJ6saKm6mGm4EZ9/hB9b2XhIEbin8hyiIzRsklzWaX0p57CA/QZv3ngjSgqsWACDAfh0/FG7Q15KYQhoYa0xNDr4lzoqjmdMizniERTLo3WZkRQpTj0uAD5dYi10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B/K8+UYA; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B/K8+UYA"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676Ftlf13044257;
	Thu, 6 Aug 2026 19:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=23iHy6xpZ1HVnqB64unrq1U19RMLJ0FPI0SuvmbVG1o=; b=
	B/K8+UYAUYNVRb7WjaXl8P7UH5hnrIfJOppLzoeD67spRWG49v9520az/95RXfWO
	lEQJAef3NHVyTlemcz/W3mc3H7G3IuzW7KJlroUH1yLAM2LUMxCH5Gs22X5ovvLQ
	PWtdgdglWlnDN0g28fIJT8s+lWONb3e71S6rMElZ+K2BQzZMn9LwnruH5HNsl2ur
	RN0XoAnMztxyMAgAffLXl3eHlYLBTLW949whvfWr4rzYNTJz/cjoihLQRIQshxMd
	nepjRfvQsTKxVCW03s7y2GV6LzawGlvFP/uBSGoG4HwzmyySkNB4SEVjNXiO+tDm
	Nwy5dRLTGhT/0nZV7H5icw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs9btedp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0etb024850;
	Thu, 6 Aug 2026 19:06:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:27 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6Lgl011247;
	Thu, 6 Aug 2026 19:06:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-9;
	Thu, 06 Aug 2026 19:06:27 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Piotr Zarycki <piotr.zarycki@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: remove unused macros from scu_task_context.h
Date: Thu,  6 Aug 2026 15:06:14 -0400
Message-ID: <178589207131.336697.10907553984433466650.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260629062257.986945-1-piotr.zarycki@gmail.com>
References: <20260629062257.986945-1-piotr.zarycki@gmail.com>
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
 phishscore=0 mlxlogscore=714 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX2mPYgxjW/Rq8
 AL8h3nxWVvlZQ4agJuM2kKBR6MFK2aHhHZzxXXu0/IWyrRBzFFy3bNv7OVkxp66jYBc28OtuJle
 mLBMcn4GXI4ZgX1RuiZGbbK16TTox5lOTH9+x1jxoGLDFDACcQHX9a1Yg4KzBqT7Qo9slG1BUrx
 lqxqsJOY8SFiKBp70Pl9SZdYGqA9Yo2nkj2jnbQIA9qaJB7+x1obS0KtDi5oQ3n03HvwI0oLHfg
 kj6N1hrj/2EdVo/2TJREMpBJbgL2lEgMD/IVl/c3C2ZiquqaHuPQH+F67eArVbqKoxWc1EVwSd8
 VgbXm19hVimsjEkeuTALrPstMg/WlBtub2ze0sJwllXbg+U8WCiz9jT48JQqP1iLCHCk5e552Jk
 NYkxSLELIXswOGHkdjoPnHFkH0ZrAt4a9lYZBmXfpb4FUMdOoHPAXRhIx2fIjisYVPdX4DjasdN
 O51Ch6Jt2JvlIzjTtL54fBOMCq1yUlEhfnClRxTI=
X-Proofpoint-ORIG-GUID: FrckVOfvI8Elm_Za6dFmaw9wHVH_7ZMa
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX5uDyBqTR35Sq
 Ut5gEglguqKFd9y1slFOnm5260TYV7FeFkNTGMNLpB+EwFaxExG4X2wDbcPhSllW3YYHsL5Ifkg
 KCyCKMAProoKrZ5s24rtkDnjIpm2cvViFapSWFRm+rp7yMAGLz6G
X-Authority-Analysis: v=2.4 cv=ZOTnX37b c=1 sm=1 tr=0 ts=6a74db34 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=52vxYkQnz-LFJVexWAkA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510
X-Proofpoint-GUID: FrckVOfvI8Elm_Za6dFmaw9wHVH_7ZMa

On Mon, 29 Jun 2026 08:22:57 +0200, Piotr Zarycki wrote:

> Remove three accessor macros that are defined but never used:
> - scu_get_command_request_subtype()
> - scu_get_command_request_full_type()
> - scu_get_command_protocl_engine_group()
> 
> Also remove SCU_CONTEXT_COMMAND_REQUEST_FULLTYPE_MASK and
> SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_MASK which were only
> referenced by the removed macros.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: isci: remove unused macros from scu_task_context.h
      https://git.kernel.org/mkp/scsi/c/d756863c9bdf

-- 
Martin K. Petersen
