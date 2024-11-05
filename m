Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED43D1CD0C;
	Tue,  5 Nov 2024 02:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730774026; cv=none; b=u43WoX0E6JmHvf1pbv3t9CecgbdTxCyCPP8dnHaMpiCK6F+VgWi7Cc2eC0KCXVFeAbAnTgAM6SePLn2x05bnU//pvw/RJGpUrNe6ujhSeEUO9zDje/dPP6vBqgn5kwFVnvCrjPZ6Xy3E3WvV6Xw62BTBZNXRCyaBoMUmjb9dsq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730774026; c=relaxed/simple;
	bh=T2MrRbO8VNOJ7zDPI1j1o5TMXlbEsXdpep74VtkTHys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUkZ4OG+++E67o61wgci2k6XdIF/IWVGn9/7om0PBLO9lZLHoy+1N2dKHm/9c5dYOwJxMgPZhevhpk23NHtzyZNKBT26sc4pubRFblFRgr2RKpHqDj7fw09qV+2xVTuhnTSdBmv8hS+cSrFvwKJcaCSxyjBVrNPeAmu8xmcm1dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C4yOqMzy; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C4yOqMzy"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52NKxJ017744;
	Tue, 5 Nov 2024 02:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Hgt/k1bQjGX+qyc8JVqc4bJcF156dJRGqDe/4ForzsQ=; b=
	C4yOqMzy+F2kSmxUXWJWC+67YkzPvV+M0ahUmG2l0K8hkkj61TgrR0gq+NlY39gB
	FyKiqt6n2fTDLFwJH4+l0EAFBZUCYZZECrHr26vkVqmkvo7xIAytfIY1pY/E5p5j
	WbmiFbOolnNuoqE/uZKOPBZZnTuXFAjuefR7T3SjX4ernprdzMKhzJavU9iOuGPA
	Y2h8KmAEDtNoKFJskUT4IPhdPLZfaqRIq/qMstHPYNwYrmCH+tdCaHNx+6D2DTD5
	6SIyYBxSMN3Vrq8p2/0r7llUYts4IJWuH8HKEdOTEykYDE7Q7eeTS9GoPxDPTZ6Y
	CHUSLW2szV3iAHk3OwZauQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nagc4905-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A50aUpI036930;
	Tue, 5 Nov 2024 02:33:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah6g2ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A52XVFm017503;
	Tue, 5 Nov 2024 02:33:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nah6g2k1-1;
	Tue, 05 Nov 2024 02:33:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RESEND v2] scsi: ufs: Use wait-for-reg in HCE init
Date: Mon,  4 Nov 2024 21:32:47 -0500
Message-ID: <173077364677.2354920.2784543003548947851.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241016102141.441382-1-avri.altman@wdc.com>
References: <20241016102141.441382-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=708
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050019
X-Proofpoint-ORIG-GUID: C-cjV5wJQo8GvwhykklTgvrpnzQcWaj9
X-Proofpoint-GUID: C-cjV5wJQo8GvwhykklTgvrpnzQcWaj9

On Wed, 16 Oct 2024 13:21:41 +0300, Avri Altman wrote:

> The current so called "inner loop" in ufshcd_hba_execute_hce() is open
> coding ufshcd_wait_for_register. Replace it by ufshcd_wait_for_register.
> This is a code simplification - no functional change.
> 
> 

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: ufs: Use wait-for-reg in HCE init
      https://git.kernel.org/mkp/scsi/c/6c1143bb5d12

-- 
Martin K. Petersen	Oracle Linux Engineering
