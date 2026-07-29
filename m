Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900A2BEC43;
	Wed, 29 Jul 2026 02:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293790; cv=none; b=l/NuHZuAIcviP4m/5FhW4M0bANM7toX3+cwfs/ugMYOeC+FWuiaqyt5RIooQlHznbvxKRW2DCmazCQROc29DG74ghjq74hqjuhbxH5o0SVKehOyZFJaxW1Sb+NgVtvrS8B+MKIzJNkTAwNUKq0Jpi5RX4jJN5p6ehUqfh1QIen8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293790; c=relaxed/simple;
	bh=fdBsqPP6CWI5yhtSPXIOLRssjVwO1VhGLy92r/v3ZzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hP971+8El/ROqSxcEzL36GTRhc9ouE43oCh87yYHrOCEQQLw2Do3A7Es9qJgFmBmiPIA6noKaTis1ejilD2TLmU0kiCHUK+CJ+6VoU/3XaLFhzTiUlcZcViLfYYrbGo8hRqwrn5MN0ToWQJHjkVRRivRsA7Pmhkfd97Zej+F3Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sTRy6eW4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sTRy6eW4"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItlcS1075810;
	Wed, 29 Jul 2026 02:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L+u1D+9CzTDlWPzriGU+72fLZDUmaeQuJ1ff9rjOZg0=; b=
	sTRy6eW4QiezzO5dwkJiVY6MuRb535lTzsWd7AkiPEfytY/HbVp2i1Xqz/Hegirf
	Mh2yiKf3RzmMqditNAHGW4Hz+DhrAuAWjgoKbD0xf67ttEJgl2eYmo9HE8bsVM4A
	YlLmnxR6fLeQvvo+ptUS423vLEc/m85Ed3RDtEgy54s2BpGnkUr6TZJMm5MKN3uV
	JTZDIE7FNURJtR+2H+xj863OiOugXWYC0zZLKgezp+q51Tr8sq8avF2d4Kc4Jh6n
	ajOdYBNPQcttHzKflSWWyDbFSyK9fIeU2z9ffuZZkdec7iaQvmm4UC9V2dTllsp0
	jUOc5dlPLMZiR/eirloLqQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1dd64t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oYNw034561;
	Wed, 29 Jul 2026 02:56:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:25 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMA7006812;
	Wed, 29 Jul 2026 02:56:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-7;
	Wed, 29 Jul 2026 02:56:25 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nihar Panda <niharp@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH 1/1] fix memory leak during adapter release by destroying gid_pn_req
Date: Tue, 28 Jul 2026 22:56:14 -0400
Message-ID: <178529373870.132455.13810372288168465753.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720072736.3381816-2-niharp@linux.ibm.com>
References: <20260720072736.3381816-1-niharp@linux.ibm.com> <20260720072736.3381816-2-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-GUID: JoDCpaB20cfw7GlWZgS8z3de1bR3fN-h
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a696bda b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=RxCvutirk0ISKLRqXSsA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXzuQVD4G4Ta1s
 +Ii4Iox5GFdL+/IwQJUjCoOgmVn/SNvapgZTh/aapTqoP7ghFZcVXeiys1iRf1muLPQrTpt82/7
 2MFI0OaGzi4mOnhXLFeVPN5wpmxOdj5AkYjXkXoxfxYmovotMaw5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX9N4gdva5iGOv
 WtTyGWjgP0o0e1F44LMLebrcuGTNeSEg4SquBd6EAqspNbiTVjXHQKJRqwnya5pkVB/65VweQ+t
 fWHp9BcLl1gJgETq0q1Qik/SURg91kBfX5Umd75ohdUiFIW0jJ/sOpkLXdYb0haw8RG088fL5kn
 8t78yo3W58DOmx2yHWLRp8X2UuHXgOjpLXU6Mzg1Rvl068x1g05cp+oGVq6XYE5btE4OGglOGi2
 cPkBt0N2419V/1kt1NkNj7GUDl+V019ATEnYpOSt05FoM6GeN8pWNvZWJVNHOJ7c+dilQDi9eHf
 ljK3CUiC984QaiI/SpgOgTZEo3a5h5Q8ZZxIEa5iK1gLzE1Guf780q2SKgZVvFArlNHlkrTohC0
 Db2UpDX9svxGXpPXnDZ/vTCd9HNd+vHuB0v9eJc+xS7so0wKHkiJbiH5L6psfWopUTp6GGDsiSe
 +Nlmi0PCSv/v45EXGpoOnhWHoylviYR94RAXCeVA=
X-Proofpoint-ORIG-GUID: JoDCpaB20cfw7GlWZgS8z3de1bR3fN-h

On Mon, 20 Jul 2026 09:27:36 +0200, Nihar Panda wrote:

> When releasing an adapter we don't free the mempool `gid_pn_req` that is
> allocated during the enqueue. This leaks memory:
> 
>   unreferenced object 0xd8d29297de700 (size 256):
>     comm "(udev-worker)", pid 2105, jiffies 4294945794
>     hex dump (first 32 bytes):
>       00 00 00 00 de ad 4e ad ff ff ff ff 00 00 00 00  ......N.........
>       ff ff ff ff ff ff ff ff 00 0d c4 5f 67 9d 99 e0  ..........._g...
>     backtrace (crc 4a5b5da2):
>       [<000dc45f64da418c>] kmemleak_alloc+0x6c/0xa0
>       [<000dc45f62b430aa>] __kmalloc_cache_node_noprof+0x36a/0x4d0
>       [<000dc45f629a535a>] mempool_create_node_noprof+0xaa/0x150
>       [<000dc45ee2c065e6>] zfcp_allocate_low_mem_buffers+0x96/0x370 [zfcp]
>       [<000dc45ee2c070f8>] zfcp_adapter_enqueue+0x598/0xd40 [zfcp]
>       [<000dc45ee2c08eb0>] zfcp_ccw_set_online+0x160/0x210 [zfcp]
>       [<000dc45f643d4762>] ccw_device_set_online+0x232/0xd80
>       [<000dc45f643d53d4>] online_store_recog_and_online+0x124/0x390
>       [<000dc45f643d8238>] online_store+0x298/0x5b0
>       [<000dc45f62eb0a04>] kernfs_fop_write_iter+0x2c4/0x480
>       [<000dc45f62c81150>] new_sync_write+0x370/0x4b0
>       [<000dc45f62c87abe>] vfs_write+0x43e/0x5b0
>       [<000dc45f62c87ff4>] ksys_write+0x114/0x1f0
>       [<000dc45f621c4a16>] do_syscall+0x2f6/0x430
>       [<000dc45f64d9d5d8>] __do_syscall+0xc8/0x1c0
>       [<000dc45f64dc2224>] system_call+0x74/0xa0
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] fix memory leak during adapter release by destroying gid_pn_req
      https://git.kernel.org/mkp/scsi/c/b601fa590e66

-- 
Martin K. Petersen
