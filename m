Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBCB1E764A;
	Tue, 14 Jan 2025 16:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736872877; cv=none; b=LAiCEQKiIR/zuSWBIxujEuwIxjypET6EzUNlrJgM0bcWe3P90ZOWA+QJ269wJi3SOLUyuO0C1RV8rdti8Jvy8114hyU7OoxgrUagzR+HiiKupgyhynGz8jDMsQFfPX56COZOznS6dFlf0GxnBfaVZ8anYzyNO2UiagmHx9nQpQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736872877; c=relaxed/simple;
	bh=5mQOmjlg7CDfy6bpFY4RJtJvsbBh71xhv8ZifeRP1rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Du71muhgOAR2+91XFrzCxFVpciQd2WZAszH9G5gB0pYEHx1ksJaTQ/85rZd9jIarHbCx1PfKjJ5D0mS2z1EoerzloY56AH6TIVb8ITV9k8HVfDShqjgLA+13e+Wbxk3gvIDF1K6RzaUwyUEQgRoesHU9UHw+Pvw2oiiNSQa0OnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d7MZT8qE; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d7MZT8qE"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EC0oTl008470;
	Tue, 14 Jan 2025 16:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=f8uXbtIRLei/NudZ033oVfbb9zDm1U80mA40aJktlHk=; b=
	d7MZT8qE4TgYCfR7ONH3+DnyBSsCDZQFAxUtxc4EiRgf/Ejjt/xBVLwaXheTvoMi
	ya0/zpOUwVNDoSyE0wbVgBthhueWAk3DajiJxbTB8sjF5b3HVn1TzfcVlIzhp255
	7Jr6Gn2n34G/YK6O/LeY6vgPap3nOKh9eFaJki/bBALx9bta+02rPwpjzAE6gn71
	xEgVqw7Cwm6Sy8Qdy7PmXbJRtBMwDKl8Hs7COyxT08Nhl83mrznm5sQRXbQu0A6V
	b3LRZutbF4LyCFtE/vTf0p+OF8L66RsYHViYLMEfIsG+rwraTjMiedkvfZb3B8zs
	nHQyoM+ClJaEnb87Z4HYsA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443fjap3k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 16:40:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50EG4P9f036331;
	Tue, 14 Jan 2025 16:40:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f38vb5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 16:40:43 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50EGegee005685;
	Tue, 14 Jan 2025 16:40:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 443f38vb57-1;
	Tue, 14 Jan 2025 16:40:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: Re: [PATCH v3] Revert "scsi: ufs: core: Probe for EXT_IID support"
Date: Tue, 14 Jan 2025 11:40:10 -0500
Message-ID: <173687227219.1044893.9689399736660500770.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20250103080204.63951-1-avri.altman@wdc.com>
References: <20250103080204.63951-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-14_05,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=473 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501140129
X-Proofpoint-GUID: nr_ec7iCeWxlpX02Jj5vpITBs5pwRQBC
X-Proofpoint-ORIG-GUID: nr_ec7iCeWxlpX02Jj5vpITBs5pwRQBC

On Fri, 03 Jan 2025 10:02:04 +0200, Avri Altman wrote:

> This reverts commit 6e1d850acff9477ae4c18a73c19ef52841ac2010.
> 
> Although added a while ago, to date no one make use of ext_iid,
> specifically incorporates it in the upiu header.  Therefore, remove it
> as it is currently unused and not serving any purpose.
> 
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] Revert "scsi: ufs: core: Probe for EXT_IID support"
      https://git.kernel.org/mkp/scsi/c/815940bb7db7

-- 
Martin K. Petersen	Oracle Linux Engineering
