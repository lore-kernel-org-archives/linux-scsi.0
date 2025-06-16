Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420891E231E;
	Mon, 16 Jun 2025 21:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750111039; cv=none; b=S/zrebdzLEHqN5q+t/rozjY3cqoekoSTglj18CNEUbYFdJxtDGdHqVg4k4Yh33EL5YjCtTc6OYVsJPLWr9XZoRn/XPNaEMHCut6k2lP+XDoUxvoi39TmEraOuFU4l4B1ZCfyUN/KBDj+06fCd9CH5L/j0xXr98Q4Uc8l6ae4o7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750111039; c=relaxed/simple;
	bh=RmCLLBLdA8EmtLx6+9+Z6juIVJ0Kn2fYMTs8vnwf/S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CiPxl9Kte125u17BSnXJepJdexenQhSV/i70bH2dd0kS0rlLzOa1/ZKP4hsGRAk68PwSt/NrvDr32tBTWykUFesEeiO+TfoczEvArOar3V5j8lXnP23skqg5IqhT+xJ5iQSvA/TJoeLCWgMaTpVqgWFF6pAqheoBSEzxNEAcajI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E86bX0x5; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E86bX0x5"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuTF1030534;
	Mon, 16 Jun 2025 21:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AH+4BerqhtEbcpMX1tWtPMkrhBIvS44wEMlcLt3OrwY=; b=
	E86bX0x521VREK+/u2hTpeiV4Xkqau5eUavQ9ISDXAG48/uRv5KrLEpwaz5YbBzT
	ykkO0tIpOXd5wOamrdSKOtPD62IzWQet+ljabsU0za+K2I8+r9n8OMdfJTLfkkce
	z9f6YuUFKE2wWn4csRCV13YfygPoyZLVPfWhDabaPMD2CZHhDz7Gs79SAmKve4Sd
	IiNtnAOf0reubGjut0SDfdchgkUj2r/8mOMs5zA5etE+woTT+tkM4QJVx3DtN8fz
	fWsmdEifSe9xOcQl3sHSkZiXYX6q3O/FU7edJ9RH2uDndfpMeUMAFgHbj7wQwN0E
	mIaYRwCum6Dlo3WaHr7FPA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 479q8r365j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:57:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GLYnxg036369;
	Mon, 16 Jun 2025 21:57:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yheynyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:57:12 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55GLvC9d007737;
	Mon, 16 Jun 2025 21:57:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 478yheyny6-2;
	Mon, 16 Jun 2025 21:57:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        mlombard@bsdbackstore.eu, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, michael.christie@oracle.com
Subject: Re: [PATCH] scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port
Date: Mon, 16 Jun 2025 17:56:40 -0400
Message-ID: <175011089410.1498478.9196241510321044783.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250612101556.24829-1-mlombard@redhat.com>
References: <20250612101556.24829-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=877 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506160155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE1NSBTYWx0ZWRfXzHpyNEEWC03D NuZUXGXdJepEHAf2Yjx2Ir+ICI82suXKXivzssu6zPnUShCy5nDN9WlouzwPl4G2/dctPBViqq3 RhBqjPAjlX7Fe4d/DJOwCXuUfEbOnYPPX/QBy4u6EqLnK2i1GVQSozPJYClDtbSLNGK1uIBUDyX
 /xwdRReY06/wmKycXkpJzcE1FwRDBBG/VJqDJeW/akmDuU48/yYJnA4spv8OZW9600ZfgtyZpWZ NUjds4i3NOSAvjZoCKQLFWnq9voKAlTc6aLYRki4/+HJHx2XKrAZVuVB/Kz30708nQt9HHCBBW5 /1IK5wkdtFJivC2GHZIdV7P9Wxx8KAnHLfIgiHa3eocdotWfc03bqtmxvb7IkBFbKQVI8kGqghm
 IaTafN84D3Emgrq6dAMgFCvfwxISQ+mrnEc2gQq3/m40hfMb4WPl87vfnPCiNDx2gCW21ZvF
X-Proofpoint-GUID: hRYbil4CgW5XoMpxynzaeMuJMM_H5Y4i
X-Proofpoint-ORIG-GUID: hRYbil4CgW5XoMpxynzaeMuJMM_H5Y4i
X-Authority-Analysis: v=2.4 cv=dvLbC0g4 c=1 sm=1 tr=0 ts=68509339 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=fpMKCkTV3Gewbli1D5oA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:14714

On Thu, 12 Jun 2025 12:15:56 +0200, Maurizio Lombardi wrote:

> The function core_scsi3_decode_spec_i_port(), in its error code path,
> unconditionally calls core_scsi3_lunacl_undepend_item()
> passing the dest_se_deve pointer, which may be NULL.
> 
> This can lead to a NULL pointer dereference if
> dest_se_deve remains unset.
> 
> [...]

Applied to 6.16/scsi-fixes, thanks!

[1/1] scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port
      https://git.kernel.org/mkp/scsi/c/d8ab68bdb294

-- 
Martin K. Petersen	Oracle Linux Engineering
