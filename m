Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2141B6D1A;
	Mon, 12 Jan 2026 03:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768187766; cv=none; b=LNZR7nd30YzwZNTOaSyvKacWYvNd4V7JG0zty/Lc52611pVyn/EdV5SIgiP/7MrRhLOeaCw8bBXyBd1/f1/h/kzxHOX2n9xAv08ELh0smfDqCzzrY68NrLIFKwZaO6JKZj+Ged7KFCh/yQ7EmdssTbndYgSMfIlng8tIALolPAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768187766; c=relaxed/simple;
	bh=TS+3novlhGRrH+SL0263S8yq3/kh+1r0DyQ117/mbS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLVKU/ptWBmuJH2e/oj8A+xxXvz5DgTu6+qVNkP4u2//UMfRW67SeOhBHp47cZb69rst+vXj4EZsR1WJrDmGQwnO5YlqErRoLxBO4jhsY67fZuFId+kJESAzYgExoBzy5aGlsjBHGyBVdl5HrwtQB4x9kwSQg3eg0E/2JBijc4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rgez9qbS; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rgez9qbS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C1m3DU317258;
	Mon, 12 Jan 2026 03:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jcyDN/1syuZvlQ1e9ZIJvi/MlU37FEU0BszLkg2Kpss=; b=
	Rgez9qbSKx9DLpJMdfR71bRRUDB/06ZRvla9BW25HRtw7k1PWGuAP4RHcHvY1Pny
	Is3woakV/OeE0ghu0HvP3mtJYGKSbHdYx9i4b87evZXU/KBAux5aV0d0k3D4iuzv
	U74ww+KiD34fcneQ7Jw6bZQIfAdQEgXr6/YBmw/8PvAmJJrduRbAX31PRvMDNqTI
	NJP7jURXPYUwIT9NNsPpOh29oRY0LKGPv+6uWkskZTns4TwVmnVYH16/fgASuAkS
	pp2Xcgqyt8DGg0Y6z1S6SyISILGa95Eh9sIGW1gF66chFaH6mLbvw/4YrNvqYq5t
	Px7wSDQct6RFjBdGRNDboA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrgnrync-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:15:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60BM1Ded004517;
	Mon, 12 Jan 2026 03:15:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd76wg9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:15:56 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60C3FfU3028327;
	Mon, 12 Jan 2026 03:15:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd76wg97-1;
	Mon, 12 Jan 2026 03:15:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jgross@suse.com, Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, sstabellini@kernel.org,
        oleksandr_tyshchenko@epam.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xen/scsiback: fix potential memory leak in scsiback_remove()
Date: Sun, 11 Jan 2026 22:15:52 -0500
Message-ID: <176818774316.2142396.1807300605417048424.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251223063012.119035-1-nihaal@cse.iitm.ac.in>
References: <20251223063012.119035-1-nihaal@cse.iitm.ac.in>
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
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=814 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120025
X-Authority-Analysis: v=2.4 cv=B/G0EetM c=1 sm=1 tr=0 ts=6964676d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=TgcThs-rK0sH0xVyTD4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RSjlYI_kFhNetxXyFY5M8UI7SGNlPTEz
X-Proofpoint-ORIG-GUID: RSjlYI_kFhNetxXyFY5M8UI7SGNlPTEz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNSBTYWx0ZWRfX042egyt5mwKQ
 dFb+SOyDHPKXPHTcV51hfu4QhtLqUWqAl6UQkW3sQJR7eDPbpG9tV+lhKeeDExpImdH5sPBIXQL
 BkUCISJysNTiun65474KkHr3paNTt6C3FSqyfiMDkeN0BMp341L3jyvu3mJl/2JGChRJVsdIwkf
 RmbDKs59cSlAsIqS+J2lvHw6Bbk0+lh/popao3BAnqvu1w7ngF2CITNigwqTAQ3BSoYbkjBr/Bc
 j5+j+BMy5m3cY59ipyZ15YivRklIa7wGMSGRrFeUegaxO+zk6+uguEa3e78xxdxPQrdavLXMM3y
 pQGdEQRafANehIwx8SB35ZZbuQovUAEfT7KXPNCHP/EgjqwBxEIbDul6cYQbRpaHr/+ptUmwiHK
 lpqZkgdMxuzse6N4tN6kdSrGAjVV6T3yObbWKlStDIeoxjRl3zhmwxNWwFU2MVOtYAApYYWnD3v
 lLZA+4UCooGCMh3+WqQ==

On Tue, 23 Dec 2025 12:00:11 +0530, Abdun Nihaal wrote:

> Memory allocated for struct vscsiblk_info in scsiback_probe() is not
> freed in scsiback_remove() leading to potential memory leaks on remove,
> as well as in the scsiback_probe() error paths. Fix that by freeing it
> in scsiback_remove().
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] xen/scsiback: fix potential memory leak in scsiback_remove()
      https://git.kernel.org/mkp/scsi/c/901a5f309dab

-- 
Martin K. Petersen
