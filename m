Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C8017D9
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 02:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NswsBhIa"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ0ItNr024921;
	Tue, 19 Dec 2023 02:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=ayMxXyKliGqCe5/kAHK61au05Q2ZOLgph7UuIuFKWIQ=;
 b=NswsBhIa1+hbMQBH1EeLn6izNFjZuNS5gwRgQQ8UlEIIokppxHDL9b7VRlM8NFhuy2VB
 U4j7Oyb4cOAkxOsq5dNB/siFbTL3h1CfWqyOb6440jP/PQlDoGVVp9YujdS7gJnn3g6j
 Axu6m0CYt1KTkDOinL4es7NkL8VMW2wb1VWd7hyCuz7WBGFfAHFtsUE8CL8UsQMYj3x6
 ByjQcE1RAK/5JmLhl5+dAZdfygwn41HXsLmlmD+E+WIcbkOGf2XzWnP+AhQ4WkExpKSv
 EK/iMkUBAq5d/iCARVM6bTviIyGZyFt/NMTsvPfDVfOYiZqrScMID5QaCyLz6VoKtIIP DA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v12p44una-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 02:19:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ0ZAX7020991;
	Tue, 19 Dec 2023 02:19:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3v12b69t7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 02:19:12 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJ2J7ZB012682;
	Tue, 19 Dec 2023 02:19:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3v12b69t3t-5;
	Tue, 19 Dec 2023 02:19:11 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/4] lpfc: Update lpfc to revision 14.2.0.17
Date: Mon, 18 Dec 2023 21:18:49 -0500
Message-ID: <170294822165.2675590.938688686321373020.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231207224039.35466-1-justintee8345@gmail.com>
References: <20231207224039.35466-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-18_15,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=895 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190017
X-Proofpoint-GUID: qM8C1utGa7Q-4UG0tMIZIz5Gn9C5ViEx
X-Proofpoint-ORIG-GUID: qM8C1utGa7Q-4UG0tMIZIz5Gn9C5ViEx

On Thu, 07 Dec 2023 14:40:35 -0800, Justin Tee wrote:

> Update lpfc to revision 14.2.0.17
> 
> This patch set contains bug fixes for the VMID feature.
> 
> The patches were cut against Martin's 6.8/scsi-queue tree.
> 
> Justin Tee (4):
>   lpfc: Change VMID driver load time parameters to read only
>   lpfc: Reinitialize an NPIV's VMID data structures after FDISC
>   lpfc: Move determination of vmid_flag after VMID reinitialization
>     completes
>   lpfc: Update lpfc version to 14.2.0.17
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/4] lpfc: Change VMID driver load time parameters to read only
      https://git.kernel.org/mkp/scsi/c/0653d40935f7
[2/4] lpfc: Reinitialize an NPIV's VMID data structures after FDISC
      https://git.kernel.org/mkp/scsi/c/8dc8eb89f4df
[3/4] lpfc: Move determination of vmid_flag after VMID reinitialization completes
      https://git.kernel.org/mkp/scsi/c/aba0fb0ef607
[4/4] lpfc: Update lpfc version to 14.2.0.17
      https://git.kernel.org/mkp/scsi/c/819952d58478

-- 
Martin K. Petersen	Oracle Linux Engineering
