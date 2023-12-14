Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ieRDgorn"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340E8B9
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:29:40 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0SWOO027147;
	Thu, 14 Dec 2023 04:29:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=5UMPjfwIVM+SGhaoQ/0GOOx2tO0CmT7nka5pd5FgJwg=;
 b=ieRDgorno7iDgLn7Bm5Rok8R9Vz7kU4QwbhucCtssG70zjXRoctkS6L91l2XjhCV9pCR
 5FYoWZq/kkn6TVizHAXSyET2DZmnF6ql06MkiUVA2hI4cBHZOxvGU7Ki0NDqQToA0IhX
 JqTz8VBd8NKkxx3WH2iREIajaFk3KHKJB8Bupz1NX3ulqCOnDDqTXY4ayKnQwgYVMGyE
 zHr5JnbXK4ayqflgTrqZNR+q5W2shNx0k5nXQctvetnpH8wS9m0eaXUc/LIILjJAAK51
 1G9NmMO6wlcVrLkkER57xXTXRJaPJa9k0URBQVfGb/b2UIwQ66z9YDENDuTQLSt7yKg1 xw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvfuu9u2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE2EPOf009894;
	Thu, 14 Dec 2023 04:29:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9ev5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE4TQMS035965;
	Thu, 14 Dec 2023 04:29:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uvep9ev0g-13;
	Thu, 14 Dec 2023 04:29:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>, kernel@pengutronix.de
Subject: Re: [PATCH 00/14] scsci: Convert to platform remove callback returning void
Date: Wed, 13 Dec 2023 23:29:18 -0500
Message-ID: <170205513113.1790765.15019549481404985176.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <cover.1701619134.git.u.kleine-koenig@pengutronix.de>
References: <cover.1701619134.git.u.kleine-koenig@pengutronix.de>
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
 definitions=2023-12-14_01,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140024
X-Proofpoint-GUID: dlnNX5-KJXBM4G91EOPUb2cN8I2-K6UY
X-Proofpoint-ORIG-GUID: dlnNX5-KJXBM4G91EOPUb2cN8I2-K6UY

On Sun, 03 Dec 2023 17:05:45 +0100, Uwe Kleine-König wrote:

> this series converts all drivers below drivers/scsi to struct
> platform_driver::remove_new(). See commit 5c5a7680e67b ("platform:
> Provide a remove callback that returns no value") for an extended
> explanation and the eventual goal.
> 
> All conversations are trivial, because all .remove() callbacks returned
> zero unconditionally.
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[01/14] scsi: a3000: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/5854cdd04163
[02/14] scsi: a4000t: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/688bbe398ca6
[03/14] scsi: atari: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/3becb4cdf1c1
[04/14] scsi: bvme6000: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/51a41ec6d36e
[05/14] scsi: jazz_esp: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/c71ef3d1fb39
[06/14] scsi: mac_esp: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/0b649224f712
[07/14] scsi: mac: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/69b43bf38b11
[08/14] scsi: mvme16x: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/f0baf76a2204
[09/14] scsi: qlogicpti: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/e26eec9a4d25
[10/14] scsi: sgiwd93: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/358987af1bda
[11/14] scsi: sni_53c710: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/357a7fd2434e
[12/14] scsi: sun3: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/15b016b2d023
[13/14] scsi: sun3x_esp: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/e84bd0bb3068
[14/14] scsi: sun_esp: Convert to platform remove callback returning void
        https://git.kernel.org/mkp/scsi/c/6ff482eeebe5

-- 
Martin K. Petersen	Oracle Linux Engineering
