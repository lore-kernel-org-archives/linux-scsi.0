Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5713B214A9E;
	Fri, 10 Jan 2025 21:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543886; cv=none; b=qrVDSfIqlCDTDd64gurWbOSwGIRTSi0QB/JJG3TsfEztRi10ZvmDCynZZU59qWsrexRyGqE9KE275ppv2ET4MrIJRK0JfOnvLljY0h0gshHOaeXm8/5k8fcXWLui3Oe05vRWRc1KCfxRq12/MKArPk20gZJMbN7kGZdwG0GU/hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543886; c=relaxed/simple;
	bh=4EiJzw+L/bzXnfmeQLIU8tNPK7qduhKHYmezr39PMUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dKkUVhPQi67N+1H9rRYx7X9yAFNMh+BS0N6I0S6iZxvD8FmC3WWI3Tu7wzmH/xaTV4N5bmj4mHxsXDphJSOypQQmLPqTquOwcLwwqsoUujTPLltfVZIdy0F3LDSiGtpo14FNCAjhazRbgeRm4ywY8ESS7fBVNxkjhw4CbwQAlCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xvoz0sBr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xvoz0sBr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALDVbO031479;
	Fri, 10 Jan 2025 21:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ZBlzpPGWwX1EqrUgduX1gp9gwKpMyq3jf4Gs//IDYhY=; b=
	Xvoz0sBrTtTa0eQ4g7WLILhWzcCkrDup3kFcNoEgyuEoZZfmlNV72Blm0ANsdH0b
	+3BuseKJjrIUxncBx/fCQEg6hBkkaMD5NPnLd2XF7FNF80JjrV2TjbPnUBdDOUOo
	CAefg+O9+29bIvrsigOBs8niWpoAAK7DxJZqdkWds/HJU9aMPxUuuT3AQBUsnk0k
	nJjva5SnbsMwJjcCLjb2qH/ahlQAPeaSvGILr6aPh3oVNEN6t/3PqUdW7QVP1i8j
	fcSPJGGpvjIePezv1eRL0gtK2ZfcBfUnNhX3wu5OSot6bbpysII98oj+vty3umMo
	aFyL6FWeMXDzrtY9rTk+mw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk0c39f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJbHdJ027327;
	Fri, 10 Jan 2025 21:17:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:38 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ26034137;
	Fri, 10 Jan 2025 21:17:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-9;
	Fri, 10 Jan 2025 21:17:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Adam Radford <aradford@gmail.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Brian King <brking@us.ibm.com>, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 00/11] scsi: Constify 'struct bin_attribute'
Date: Fri, 10 Jan 2025 16:16:51 -0500
Message-ID: <173654330200.638636.14316160501639479876.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
References: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
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
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=871 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: Ia0G0LwR1gpmpADi0HH4eI5RcWSdT8JS
X-Proofpoint-GUID: Ia0G0LwR1gpmpADi0HH4eI5RcWSdT8JS

On Mon, 16 Dec 2024 12:29:07 +0100, Thomas Weißschuh wrote:

> The sysfs core now allows instances of 'struct bin_attribute' to be
> moved into read-only memory. Make use of that to protect them against
> accidental or malicious modifications.
> 
> 

Applied to 6.14/scsi-queue, thanks!

[01/11] scsi: core: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/e4dab5d1ded3
[02/11] scsi: 3w-sas: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/1cf448bd2e6a
[03/11] scsi: arcmsr: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/3e72fc051d4c
[04/11] scsi: esas2r: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/61e2d41cafc6
[05/11] scsi: ibmvfc: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/af58c759836b
[06/11] scsi: lpfc: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/4594a1f827d4
[07/11] scsi: ipr: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/f6af41ff6671
[08/11] scsi: qedf: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/a8116aa2898b
[09/11] scsi: qedi: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/f9d0a8450ee3
[10/11] scsi: qla2xxx: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/06a9ceb95f86
[11/11] scsi: qla4xxx: Constify 'struct bin_attribute'
        https://git.kernel.org/mkp/scsi/c/ea4f2219dd40

-- 
Martin K. Petersen	Oracle Linux Engineering
