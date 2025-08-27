Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012009.outbound.protection.outlook.com [52.101.126.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635873019C2;
	Wed, 27 Aug 2025 12:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756296985; cv=fail; b=Dyu4VgLp2JNbVQT9idTZnl3nn/6T2stb1PrQxEgW8C/zq+QH47PR7Xarli0+eS/hIosl7nNNVunBcXQbS/lV/G3sarhPMcXu9MkXHc3X28FaJjmMc1vuN0rPeY71q0rBYIaiyAxhCniKHMGWNG4ditS7tlJ69wKhmPkKchnMO6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756296985; c=relaxed/simple;
	bh=ZmETVDqYpvK4ANVS0ArddEChyIJiaXN2USZBT/b62x0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=hMqwIzsIzRWlpfwGdSm75ADvk2k2YZjpqTA8vTukiNMUWOPF5rXslG2VGfZaw6EcnMB/yYcV0sTrhvv87nODWizImApoq/AJ3vyE9JctUaEBNn/Ph3ZT99eP98hiDvtQkUo/jzU/TMWZdAqJuyfnyhC2z63Cqx6zH6kNAXJKPLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=M90k92XO; arc=fail smtp.client-ip=52.101.126.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="M90k92XO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H3WyErjfrSC61tzfCX+rRfZ/C8zZvppFMTzRWz2ViapUNe4hAg1EhEvIHliiGA1cqqiP53bBhZ42jaKx5ROHyH0Qqk6RihL+wfHwkYiRy4lRyCKmYO3QhMqoWapcuJh9bytbjoZYYvCR9xki0cMkJ3o7ogXOZSdNAxRN1JD5xjoVRzgmgh3kFp/YKj+wwzapA5f9QLmA/DbekJu27ZHllvQg/rnSIHTKBTbngWeibkdkfufgOryV6kFnK19FpacX3+silEkSaD816rUMhJc7po/Mk5kFz8m0SNWEwT+5fC1NWfIDw1+lQl8crQrb874lisIm+02/lY7zFQjFuJKDpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4EZay3YzlEs7vi/NySmQQ/bXTC3KT7e9COTnUcvvGWM=;
 b=eX0pz8qLfrg7eFCf8joz1+L9MtHhmicTMi5WRCGbtFpqSyc0XKNRQrkRx3sYhI421pVO8vL5SqSwPvR6Cey/JRIyC4suk5v2e6rwBxLAFKqVbwUUnDYVu4TKkwq3qyLjfRocr9ZW+XIZGUjA3oIchV3wURAYPLtOa7bLdMiXg2e8Ay9vpUYlJq75kZEaQU2KBo9zceYsKgiND1rIptyNQbhUlEa/PfGjeUP/TYD/A6/ciZVpaQgKk1ryCXj9tKz61kWzehsXj2U3PHCz/tRp6GeNkPnkjnEn2XxTg1ACJQm8a2cutfThd2XBH/iAOJYQeytlNrVjjWKQXIBvcB5MEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EZay3YzlEs7vi/NySmQQ/bXTC3KT7e9COTnUcvvGWM=;
 b=M90k92XOsWp+0uDl5tG3uVvjU8apJUosTebfQQ8g7CTQXzotLLuRayQ5dF9UoTFGbzh5II6eJJpb6o7W3nL3CahHCJRQ0Hn3nGhZCdY2yCS7PPq/QfYP5tMvudcud+GmbT8Iv5/TECfqxn5jBWHshSvgUzIE6wBCc1ysCsMhd6Q9HH4DiRE1dB4I0Zqi1AK9MYTF+QOsXMvdK9DNh6FV8+QpCEzNxZg9/sjMudXjRscJ5gs36F9yA43Ox/penatSvDp9bKELD8UoHqy8Wu9+61D3xY16PC3O6WxSpw9qTtHoBhyX8Rr2/OW7Dh4uYeuR/oKKi5KbOCEiUdWMrDjnUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 12:16:20 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 12:16:20 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] scsi: csiostor: Fix some spelling errors
Date: Wed, 27 Aug 2025 20:16:11 +0800
Message-Id: <20250827121611.497547-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0372.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:79::20) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|TYSPR06MB6411:EE_
X-MS-Office365-Filtering-Correlation-Id: ce8cb840-4d74-4a24-2609-08dde56387f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ij6u9Y2qZ29mgYVhqqwdWxq4sDxUKUVfJcljT4Cc902aqYYe47DmUsVsIpX/?=
 =?us-ascii?Q?E0GJOzLRZk3S3vLKpj9fVDVzzAeRWVYApj2/l0kFQslKXKgk5KYP9pJSAPtu?=
 =?us-ascii?Q?Va1tO33vyQYF46ZDbKlDdiWf5EZyoSGVoGS6ktWVUWwveUmJao4jwda2XDHQ?=
 =?us-ascii?Q?0vVL7kzxqlCFf70rxhNE/+crzkGb0WH9ziUYQQUEmfiMOmfl9Ts8DhzFtxfN?=
 =?us-ascii?Q?SIBJtXeiqvTo/WvNNKZqeGO+Q5LZSyJlt5SRvmHagTPLQVQffA39xtkc1hVm?=
 =?us-ascii?Q?6B4cEP7FHwoXNgA8D4X8dn2/kRFgeGPYgvGkB1dK1U3xNC81n4SmiJCvnomA?=
 =?us-ascii?Q?tF0cazP5lGWImuMguhErKOwBreUMi2V/UuoESF+X46gU3zhIT6vgB4fzASNC?=
 =?us-ascii?Q?UQVSOctT+b96lSKD68i6Py7NRWoMK1E9wV1v1u1B9I2nAd6I/qZDsjts785+?=
 =?us-ascii?Q?PHhtVhG6c9u7alGpU0OnzBnvK7/icVmYutwaanEd7icBtUaRhEmWscRtSPBb?=
 =?us-ascii?Q?1UJt8lEca8/6xklOQ80tXQi2BYuShDyNK7zee/Skiy9wiKLVlEe221j6Zof2?=
 =?us-ascii?Q?Ay57lNDJvQaC7+DgpQ9LeERAjIDCo3nPctwCvs+KxIHGIq8G2aNz7pedc17e?=
 =?us-ascii?Q?Bec+ld12mKkETNyN3nDUO6fE7Hy2DJgAgQCMdtWYXOVarXBxScqgDQKM8pRa?=
 =?us-ascii?Q?Y+PQaPdKg9uROSegOgca5XIUKQOggbF079DLr0nqwZKZVHp+sMC60qfGUjpZ?=
 =?us-ascii?Q?Xv7Zif3g1CuZQ54KXWqEj+9oEbQgvB6jj1H6bkFYDki+zL1ipPqZLwLin4Sr?=
 =?us-ascii?Q?JPtxVs5lQX+VGGw376DJG+MOSAGxai149mp8AQi6bG1pgkdryFp5FbTpYTgd?=
 =?us-ascii?Q?NH3G/4qlyYqYoQzRD/vL2qEVJf7sSTYXhlv4n6EEomlMrybJds7WuNub9xOz?=
 =?us-ascii?Q?2IMCCN98AWN3m2njPtFlGvSt9R13mnhrIiy2rGiFU7iH7OCO5IpkNPSz9QCc?=
 =?us-ascii?Q?UkCD3XRJWbXGZ+olUmgsQ5mor+x3Hc0YW67XSxRt8fH9Q5ZoSO++uorNe6c6?=
 =?us-ascii?Q?F9uCcrKOAP9xh9lu+EQaF3O60jjplC4dSwk6VGXVkEe8IWFL1dEbxzdKzP5L?=
 =?us-ascii?Q?ag7WJQHGsVrafO3wwahd8Au3yQHmjxTM/17o3RXHeCqVfxal9jlnnJrQm675?=
 =?us-ascii?Q?dve9eutqosC1RRrZcl6HXNrZyYBaZ/rMfeU2G3jh/qQsnor9VeRkDeaic4oD?=
 =?us-ascii?Q?M5rAR0/x6nqrPR3m1fiOmx4B5LdPhcyjenjV8Lmq80qVjx10y6HiBNkIpnXc?=
 =?us-ascii?Q?mNcRHj0OfinnAVtUKSNa602wt97P+HrnorCQ9L3nQO025TuPTmb7asRpuoBc?=
 =?us-ascii?Q?RIvfSguXrz4xX0IHQyp21qk0ZgOkkTtAZ8qP+Ue01AYGoQ2a+w/IaBkFhG1M?=
 =?us-ascii?Q?btd0XIo8bU1lBzdjThCAniqDbiki12v22HYIm40RIJZLU3oMVdFzNw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RMiJvt2RLKCDkKsxV10Dot4HExzZMagNK0Al1tNWmJQARJ9g+qyr0dK008Cp?=
 =?us-ascii?Q?obJfToZtIJunK1r72zJbVcXo2L6E83nQqbxVLdvfBi/wEgpD5N0Dxq1zP40c?=
 =?us-ascii?Q?ohbJmRpQQH9Xkv/zjkldk4crQfohETYLJgco7ekrK/lLPJQVQllsY1zcaaI2?=
 =?us-ascii?Q?v5rlpI6MFrlqpSqD/bHketHFgiFWkTQ6qQDNBGR85Xt/bGNa1/gBy0TpplS3?=
 =?us-ascii?Q?D+TbxcYD1kedNBgTEB8eUSUCyBJmyBrZ6yIdJLcf5gkIvxMau1pmDVhILdlf?=
 =?us-ascii?Q?a+dMhyzioklny3mqYDZDekCycm3zDFTHtQ42R57rS8IxeTNp/TZdimHlouzy?=
 =?us-ascii?Q?v6wn+jW94SAFiLuOFYXVirng9bJwc6ejtxNttpVSxMI3eUq00jKSMozxO0Ze?=
 =?us-ascii?Q?3IeOD0AQdZvzLGtitkskvKKTHBqU77gxAc9Mwk+8g1k8wX00H/HBV3sxiDfL?=
 =?us-ascii?Q?InxZ2OlafWeYemnEw16LVvBHfmhHZr3OgZHH6pgHtoKjULhiMnwHuJ7LYs5N?=
 =?us-ascii?Q?JCf8UIeUFcwxRrs8kZpNaYxCbarg6o7g4Po6xNR0ceRM1XCJkoxRaVCcECoV?=
 =?us-ascii?Q?qsaXacIOR/CiC1PN0UE9zC9OItpnypwzGQx+b6yF1mjOZ1usEWfNY1E9VHR2?=
 =?us-ascii?Q?05RflftJaotTX/5jg+dVxXqVd5jCvxHvFwod1opg11GvHr0S1BL/8VITyHOj?=
 =?us-ascii?Q?vVkA+PRb7VXN9a96CZyLfBiLLDB4PPLd1hiNgDvOAvD1aSRDirqSb8EDXxb4?=
 =?us-ascii?Q?dihCs8KB2HeB0mt5V4/T9ZuLs16+PvrZgr+Ucu64d5UPXsQuV+TA02gzWQiY?=
 =?us-ascii?Q?ViZUyqNiJLSkgEhFiA+fLohpFulAeoTcg2Pl31IG2N3s16OQIoJzX5xMmWYw?=
 =?us-ascii?Q?gOLXJnSoBR1UMpCRiO2zkirrIwsij2+ezHHgDnNLkIdiGUDfP0hOcRURyHw6?=
 =?us-ascii?Q?VckE5aFOMT7QIzPykXtKWMqrGDPb8qSpYAAwJzWb3zpTbdxyOWkNx8npeJM8?=
 =?us-ascii?Q?FRZWhWSP2GGqLe1wSoSds2v7l6FbK8C0l0vO8oON+rs4OcbpZ4UWri/JxFMx?=
 =?us-ascii?Q?V2gPp4Qm4bOqoo86IxcBCc0hpN7SlbS8OS/YpXfUCrDVqqFVA5bVcpg2S8hO?=
 =?us-ascii?Q?5X5a6+fJzrc944/dWdYnSQ9Hp8tasHsAJwUE1Of1/3dAX4N95Ys/kkFFAo7C?=
 =?us-ascii?Q?VaD7HOeQx3mrGmfJxmV/vc+E5zprLoJwOjxiUxuQJzHCu+GHtbIol07vrbm5?=
 =?us-ascii?Q?N65/gabBu2RtEn5J16S+PJxmzgkKgf1x3DNHEAFxT+FNUTYuFXapUlhtZ14i?=
 =?us-ascii?Q?Ts7UwbbCrxR69Ua88BnZdeTtSDDoll/v8n8SLyJnbtjbioTpGM21rgFPZXhn?=
 =?us-ascii?Q?N0RcwvZS7/Xp+HYKPMNTpxzONPGxtL3RUb3HB/Lo8ZhpEKRhquVW1ixAW4af?=
 =?us-ascii?Q?oV5rV++V5GCOLQdOEoq800qBwixnyRwyAKDZqBxEtUYyqPaVz0vLcgQXx530?=
 =?us-ascii?Q?2nBnAzIZWwA/19VTfq2i5S+5HrRqoUZCP9HfA9Mu9i8V0ABHSd1wXoeF/cPe?=
 =?us-ascii?Q?PRF8eHlBnm7oeFnSIo8Ai2yUYkwsTaDMLQ17aX7K?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8cb840-4d74-4a24-2609-08dde56387f5
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 12:16:20.4185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lnVO4W1CyqQtMMHQhbkfAWRCCR2Dr5KuFP7Ota0LxpdLx3dRfAHy1nzwL32EH+2juZvIpvLN6LsEco/cqKzB5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6411

Fix spelling errors in some comments.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 drivers/scsi/csiostor/csio_wr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_wr.c b/drivers/scsi/csiostor/csio_wr.c
index a516df019c22..010a1df37f15 100644
--- a/drivers/scsi/csiostor/csio_wr.c
+++ b/drivers/scsi/csiostor/csio_wr.c
@@ -960,7 +960,7 @@ csio_wr_copy_to_wrp(void *data_buf, struct csio_wr_pair *wrp,
 	memcpy((uint8_t *) wrp->addr1 + wr_off, data_buf, nbytes);
 	data_len -= nbytes;
 
-	/* Write the remaining data from the begining of circular buffer */
+	/* Write the remaining data from the beginning of circular buffer */
 	if (data_len) {
 		CSIO_DB_ASSERT(data_len <= wrp->size2);
 		CSIO_DB_ASSERT(wrp->addr2 != NULL);
@@ -1224,7 +1224,7 @@ csio_wr_process_iq(struct csio_hw *hw, struct csio_q *q,
 
 	/*
 	 * We need to re-arm SGE interrupts in case we got a stray interrupt,
-	 * especially in msix mode. With INTx, this may be a common occurence.
+	 * especially in msix mode. With INTx, this may be a common occurrence.
 	 */
 	if (unlikely(!q->inc_idx)) {
 		CSIO_INC_STATS(q, n_stray_comp);
-- 
2.34.1

