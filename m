Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h2Wp+wj0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jCPAzYTF"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3832ABD
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 21:26:59 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0SC1a012939;
	Thu, 14 Dec 2023 05:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=zORhsPcXtV2jlio+bhW8L0m0rnNNqoSrBL+dlXLpGzY=;
 b=h2Wp+wj0rUSLoguHjunbeS0bLqdONhh8Tz8pbIHAwfX4uozw5AR9I6gmbGQQhkP0AraV
 tENNYj4fSMbZrzoSxZjoFIsyyKe50/R0l9eqCsD8/O1vRUaTHf8gdqu0rJmwLZWpcU42
 QsujwHle0jNlVN9DEbTBBO13aRxcJhhM4KATEKRi7dHeOSoDn3pa6e0sOJAjGg7aYghD
 JQsVoOeJDpArcNNeoUiaYG+XCLr9eHDZptybeKoAps0T57NIkMrmsyw7y6kXxDLDJ0uL
 hSSlznqIJzwfTpzOVosbF7gHLP8mKoEG663cNAFRlWbst3Qx2wK5F806b1JP7yI/xB8g EA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvf5c9xgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 05:26:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE3e0GF008286;
	Thu, 14 Dec 2023 05:26:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9gkge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 05:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oayQPp/MMUeIBBPXx9tMXkZfkJAFRF2OV1ukK7qiqdWZBBoqXoCNtw+sqx1/7bk8go/5KxRYKBpdcAYxkWeqRT522/n/wttZYL2KQ7KLQaSuG67jSzv9Gseo8u2drk8688OQb0Z7+qMVovEKRg3JDZZXUXyq2+VkeZ1YRpuOONDOXfMdKv3IZEtBio/2p/+PHrEUF1oDPaLy/9pV3UZVHleqO5rN2VcdHtlaK2uAxJDOo3ne8/aQXow6QnZxJ0nOLi8vQupvZEcYS6V6Td4BvWFTIhXvFNQrg2zmGLyWWVk5KzKJRhduX7ekv5Vo7IvM8Oq/rlssi0SeCr1s9/LE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zORhsPcXtV2jlio+bhW8L0m0rnNNqoSrBL+dlXLpGzY=;
 b=caSb+3Q6O8HoiinqAxbieJqSvfoCy6896VxCl/eiM335ptVqhJSekAfm7hoSGoUpulPGzlVe/AJa1zyvnKrqrKlSIF9CLv8vO7E2owa3GIRrsMlfXWunvM2cmRTXCDfgME1mdcWmlzZCaYJJh1Vt6+wtVd2fbH0uAItoUopIPDyFfgYQL6/lwWakRPczAq+RLY1RGy2PM3qMwOxA1txWTFp10qLuahM4OHUcfZB7FY8Q3zVadEFcF5laRLZsMXxWAZh5KxLRUzuDv8YmVjeBbon/dWrwOk6wE6gBHO3PSWBtmE9r7fIZ46348AETKGj1W5Mp7feelbx67aJufaxTnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zORhsPcXtV2jlio+bhW8L0m0rnNNqoSrBL+dlXLpGzY=;
 b=jCPAzYTFAfyZS15EmVgLGC+mHC27aGbkntSYIuNmnrKyrClkwL93z+X5K3upatTsHz036joL4VNDBjB/AbawhGKGbnrVl0KM7CyHEI6/teDxukBm0CLK+SVcntcpZORunHQbZL/58gj1KrGPbMKZJmKznJmTQniV/zD1pTfoasI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB5044.namprd10.prod.outlook.com (2603:10b6:208:326::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.29; Thu, 14 Dec
 2023 05:26:51 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 05:26:51 +0000
From: Mike Christie <michael.christie@oracle.com>
To: stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, pbonzini@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: virtio_scsi: Add mq_poll support
Date: Wed, 13 Dec 2023 23:26:49 -0600
Message-Id: <20231214052649.57743-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB5044:EE_
X-MS-Office365-Filtering-Correlation-Id: f66d9bcd-69bc-4ec2-a422-08dbfc65465b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4JSNJrzxnPPXEqxAVlPmJHhC2r8PcRffC2imzoONA6ZLKJK35xG0cYLOX1Qnl553HLOxae55pQjQuEEWOttkvTKTRnLA4TW3U7LHMt8RYtjgnLlL8JPFIThqvVaZG8FqYILouJdeZi53RCJaL4aZhHQ0OeVuGaCHVea6fIAfEXmSBqS4qDo9ZsqqlB8evlkLOmUUAOwOVxE2ux0CeBHNeOm4rot/AH6ovmHFysRGmn3+fjJ5RnCbT3S35JC2yXFkJALX64NfGo9Nf2blnYCIw7M9KIiI8LFWeeci7PxTK0daBwK2iHZXIDG7wUYeBp8HtAtkiayUpffMyn458tTQ0DpY79VW4P7EqMS73Oq2Mje0xbODHtrU+PBWgHKOGCpm4x1Bk/d6VU/powMSzOFpVUkr+293NHFJ9kSaxap9FztzHsb7lY08t3ZsyhwvkxI68NQOXREiXVzI/QSqA8saTRvr2hm9iu6dOcQpclIaomk6+C58I4UMDhKFALeb96uXh5vEEsoHfhbbgmJgMb9q6kahYsTnudtpaRCA5pOzES7/M3gwTYjUlsioRIfKcKY1
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(396003)(39860400002)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(2616005)(6512007)(107886003)(1076003)(26005)(38100700002)(8676002)(8936002)(4326008)(316002)(2906002)(5660300002)(6486002)(478600001)(41300700001)(6506007)(66476007)(66946007)(66556008)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?uYt+wj8uMhKSEk41c7oHYRlde2jbqk44c233Gf8Z9/qRMkeHwEYAN6ve6nos?=
 =?us-ascii?Q?8B25dd886ySrHGbbBBz+ZfyMi+4kJTyY6Qua9QS6NkNCTrETQbHZ0wkeqRRT?=
 =?us-ascii?Q?Rkf9JXW2AX4A5j9QZw7Yg6a+eOeh8/zGqYG3b+0zK/T9yp0O4lc9wYCW0AWn?=
 =?us-ascii?Q?Kermon8I4CjyYY3TxgQf0eY6YKkJccz80r0Tbnj8I0cW+rmiJub5KjPHUh9k?=
 =?us-ascii?Q?5u/9z0uIfYM5+L+VDcz/O5Kc49QOUhz8eZqlxiX2HGINgjqfuugBL6WSjWHD?=
 =?us-ascii?Q?/8OVpw5w0T6DiPR7qN3x5p0t1yQAeAchCj1RfVSAvCnfu0171Gc1+3MKovIB?=
 =?us-ascii?Q?RTGxbsAI8Xy0B9ITczBYXkryr4OdZXkh1oJYpjr7WTT2X9I9DDbOHje1uljd?=
 =?us-ascii?Q?jffcvbX3RM2BQCiSJYbWr3YSpMTA68n7QdswTNOgDH54Dtx30QWyLF9+3J4h?=
 =?us-ascii?Q?r5k8DnK9gjpGVDyV2L6DHlJ4A1zRAarmSTEcrFZC8EO7XDJUSmAzhoXLJ1r8?=
 =?us-ascii?Q?uSPUG/DG9Z9BFzk+iPmO3ZhA/ZNNPLNJ+6R0OUwW4KQ/PYcYyUugwefzrwK2?=
 =?us-ascii?Q?zR9bRrqAaGJw2oR0eQSi92N2S02Dk9uvcMifZsov8lplsRNPPK5QYvEDeDbe?=
 =?us-ascii?Q?52NUN5TZHKWAW4xAKrymF20ii/CSVx33DD4TIEnuSYHLNClc3MXHDv4lbfEP?=
 =?us-ascii?Q?K74jj4nC41Mu+PwvPEBL3UlKi/6oGw3Xsv91mMVGc+pPQzTA1Mlkf8XRJtF8?=
 =?us-ascii?Q?jUXStiWhou7vAZKMh4TinXyN3maHxTfXgNHpY+3+0Gfv9WGnkWurso6qWYc2?=
 =?us-ascii?Q?e10HJoyAeC6vULs07QYP0vcb9qORmJgx0fVhL4VI/2eTDbKZ7wDo/Uw8mdvF?=
 =?us-ascii?Q?060oP3yZVpq4PnSxXpw4rmQrb5m4ysxi3Tpu3rfH4/VKoWdvNxmTDCd9lhFo?=
 =?us-ascii?Q?2Q12ogT8GoWpVXHgYG0uOkjgAFvIPF52Xls559mwy9zuF9N7LGue7NOVL7Fo?=
 =?us-ascii?Q?ZuqcEexUYxhmHcmtsZ/QdPxKeps7F6wDPbCQ1mWphLbLhvw7iQYJu6p0/gDQ?=
 =?us-ascii?Q?VYmL0KlhShGd1OUQcj5DVAhTH1EpFI2tfotL+4WS+bYPEunJLtURUCu1hjr1?=
 =?us-ascii?Q?Z90xFY5sfTa8hmbfufURb04Q2izmqHpstqLMYRv+LI+Bas0Ds0AcLcOATDbL?=
 =?us-ascii?Q?8U54VIlaAcFmStN/0UIUwPW39GtMN07NlLFobIjWGXDTgnhZp77lC6HbMTa4?=
 =?us-ascii?Q?e+aqH2kJz1PnIx7kaC4NkEqXzdWEOUGX3Zc4mzW0G2z/5qByejk70rH5gt1h?=
 =?us-ascii?Q?otW/aucNfMvB92vIwn+Fj45Yd7Fi0mfEeBrjXmjNSLMW3H5pGNmeV4yNtrH5?=
 =?us-ascii?Q?5d2RHBE8H8xMvqsHFa43oxsJEV5zgmheaKumMBmVoXC9F5iOAfALJ3q8c1US?=
 =?us-ascii?Q?/4fo2bBtWX1MOcIcaDREH+UCCIdp0TCgPAaFzneqK8n9QGJ58AXCKEIftj17?=
 =?us-ascii?Q?e1z3N2D+PaO6VDQbc/Rz5CdUQ4qpHSEuXCNPAWzkeZEX9pHQFC7V727iW6U4?=
 =?us-ascii?Q?3FWWaoo74UomW1w/VPfCOxdRc3CuHmCgOBcBVwGm3KQXgCGEEYhNFc4h+Js3?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	XsbSYWfXtvBTn1mrDZp+nLrIqHrdlsv9FgcCuwyh/DUVFgHIbKV/hd3VL3KFmBm34CgUiVdNaOFnwjLsN9FjsE5XdADHg7fIR1Rrhm4bG+YqW1zHbaSFOSeLQG9i/aOhRU3lQDhlPgsz0dLQ7OQxWzcTGUIrR2DxaNjGu5xgATVcFmAotiw+0MdVrxr/BU2O00dEsvct1pKKcBgRmWXKVHQfq2gbN1l+bi/x9trkfSgwhVLH4Y6hieQKK2l+hgLyqYCqPWRPUIjdAefrY+KnCdtghDPw/cPBrzSt1pCMzZwzjnPVddMsShaldxEMbSzvvQOsrpf4mP637I6ZfRykSs4UbK2t+hPf6NVP31JBt76aP+LKW5edQAxCnuUGeccc3H07IpHF4X15yTYW8WeFuTTSQyAQTV26llud0D7di3Be3LvUmPQ+MNJazn603ETtSMNRox0WRitAR6ZaaJOwmYB9fzc9wr4nCjBH4HSmWGdkiTo6PxhjWsTrzy3OCGLXnzJXEhYwjjIkggkWKGMcizTRCgb0cPK1VzDHQ0bB/N80d9ahukeaNGcrf7b85Y7CzYHDjtsJ5drNS3Gn4kh5ra3MiIaDfs09DSYz6B7VyTU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f66d9bcd-69bc-4ec2-a422-08dbfc65465b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 05:26:50.6908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nx3C5xe1s9KjdBM9+oG/ZFN5ekHH+vFKK+JbuAr1+CPXP9v9O0qVTMyLCtdIsC+K25n4OF4fWp9lHkAb2Wy/hM6IPK8edUBo37/FQrJQ2Z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5044
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-14_02,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140031
X-Proofpoint-ORIG-GUID: MLHbxdVv_fzYuxVVqBFm0f-DNDnN5x1r
X-Proofpoint-GUID: MLHbxdVv_fzYuxVVqBFm0f-DNDnN5x1r

This adds polling support to virtio-scsi. It's based on and works similar
to virtblk support where we add a module param to specify the number of
poll queues then subtract to calculate the IO queues.

When using 8 poll queues and a vhost worker per queue we see 4K IOPs
with fio:

fio --filename=/dev/sda --direct=1 --rw=randread --bs=4k \
--ioengine=io_uring --hipri --iodepth=128  --numjobs=$NUM_JOBS

increase like:

jobs	base	poll
1	207K	296K
2	392K	552K
3	581K	860K
4	765K	1235K
5	936K	1598K
6	1104K	1880K
7	1253K	2095K
8	1311k	2187K

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 78 +++++++++++++++++++++++++++++++++++---
 1 file changed, 73 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 9d1bdcdc1331..4cf20be668a6 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -37,6 +37,11 @@
 #define VIRTIO_SCSI_EVENT_LEN 8
 #define VIRTIO_SCSI_VQ_BASE 2
 
+static unsigned int virtscsi_poll_queues;
+module_param(virtscsi_poll_queues, uint, 0644);
+MODULE_PARM_DESC(virtscsi_poll_queues,
+		 "The number of dedicated virtqueues for polling I/O");
+
 /* Command queue element */
 struct virtio_scsi_cmd {
 	struct scsi_cmnd *sc;
@@ -76,6 +81,7 @@ struct virtio_scsi {
 	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
 
 	u32 num_queues;
+	int io_queues[HCTX_MAX_TYPES];
 
 	struct hlist_node node;
 
@@ -722,9 +728,49 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 static void virtscsi_map_queues(struct Scsi_Host *shost)
 {
 	struct virtio_scsi *vscsi = shost_priv(shost);
-	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+	int i, qoff;
+
+	for (i = 0, qoff = 0; i < shost->nr_maps; i++) {
+		struct blk_mq_queue_map *map = &shost->tag_set.map[i];
+
+		map->nr_queues = vscsi->io_queues[i];
+		map->queue_offset = qoff;
+		qoff += map->nr_queues;
+
+		if (map->nr_queues == 0)
+			continue;
+
+		/*
+		 * Regular queues have interrupts and hence CPU affinity is
+		 * defined by the core virtio code, but polling queues have
+		 * no interrupts so we let the block layer assign CPU affinity.
+		 */
+		if (i == HCTX_TYPE_POLL)
+			blk_mq_map_queues(map);
+		else
+			blk_mq_virtio_map_queues(map, vscsi->vdev, 2);
+	}
+}
+
+static int virtscsi_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	struct virtio_scsi *vscsi = shost_priv(shost);
+	struct virtio_scsi_vq *virtscsi_vq = &vscsi->req_vqs[queue_num];
+	unsigned long flags;
+	unsigned int len;
+	int found = 0;
+	void *buf;
+
+	spin_lock_irqsave(&virtscsi_vq->vq_lock, flags);
+
+	while ((buf = virtqueue_get_buf(virtscsi_vq->vq, &len)) != NULL) {
+		virtscsi_complete_cmd(vscsi, buf);
+		found++;
+	}
+
+	spin_unlock_irqrestore(&virtscsi_vq->vq_lock, flags);
 
-	blk_mq_virtio_map_queues(qmap, vscsi->vdev, 2);
+	return found;
 }
 
 static void virtscsi_commit_rqs(struct Scsi_Host *shost, u16 hwq)
@@ -751,6 +797,7 @@ static const struct scsi_host_template virtscsi_host_template = {
 	.this_id = -1,
 	.cmd_size = sizeof(struct virtio_scsi_cmd),
 	.queuecommand = virtscsi_queuecommand,
+	.mq_poll = virtscsi_mq_poll,
 	.commit_rqs = virtscsi_commit_rqs,
 	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
@@ -795,13 +842,14 @@ static int virtscsi_init(struct virtio_device *vdev,
 {
 	int err;
 	u32 i;
-	u32 num_vqs;
+	u32 num_vqs, num_poll_vqs, num_req_vqs;
 	vq_callback_t **callbacks;
 	const char **names;
 	struct virtqueue **vqs;
 	struct irq_affinity desc = { .pre_vectors = 2 };
 
-	num_vqs = vscsi->num_queues + VIRTIO_SCSI_VQ_BASE;
+	num_req_vqs = vscsi->num_queues;
+	num_vqs = num_req_vqs + VIRTIO_SCSI_VQ_BASE;
 	vqs = kmalloc_array(num_vqs, sizeof(struct virtqueue *), GFP_KERNEL);
 	callbacks = kmalloc_array(num_vqs, sizeof(vq_callback_t *),
 				  GFP_KERNEL);
@@ -812,15 +860,31 @@ static int virtscsi_init(struct virtio_device *vdev,
 		goto out;
 	}
 
+	num_poll_vqs = min_t(unsigned int, virtscsi_poll_queues,
+			     num_req_vqs - 1);
+	vscsi->io_queues[HCTX_TYPE_DEFAULT] = num_req_vqs - num_poll_vqs;
+	vscsi->io_queues[HCTX_TYPE_READ] = 0;
+	vscsi->io_queues[HCTX_TYPE_POLL] = num_poll_vqs;
+
+	dev_info(&vdev->dev, "%d/%d/%d default/read/poll queues\n",
+		 vscsi->io_queues[HCTX_TYPE_DEFAULT],
+		 vscsi->io_queues[HCTX_TYPE_READ],
+		 vscsi->io_queues[HCTX_TYPE_POLL]);
+
 	callbacks[0] = virtscsi_ctrl_done;
 	callbacks[1] = virtscsi_event_done;
 	names[0] = "control";
 	names[1] = "event";
-	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++) {
+	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs - num_poll_vqs; i++) {
 		callbacks[i] = virtscsi_req_done;
 		names[i] = "request";
 	}
 
+	for (; i < num_vqs; i++) {
+		callbacks[i] = NULL;
+		names[i] = "request_poll";
+	}
+
 	/* Discover virtqueues and write information to configuration.  */
 	err = virtio_find_vqs(vdev, num_vqs, vqs, callbacks, names, &desc);
 	if (err)
@@ -874,6 +938,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 
 	sg_elems = virtscsi_config_get(vdev, seg_max) ?: 1;
 	shost->sg_tablesize = sg_elems;
+	shost->nr_maps = 1;
 	vscsi = shost_priv(shost);
 	vscsi->vdev = vdev;
 	vscsi->num_queues = num_queues;
@@ -883,6 +948,9 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	if (err)
 		goto virtscsi_init_failed;
 
+	if (vscsi->io_queues[HCTX_TYPE_POLL])
+		shost->nr_maps = HCTX_TYPE_POLL + 1;
+
 	shost->can_queue = virtqueue_get_vring_size(vscsi->req_vqs[0].vq);
 
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
-- 
2.34.1

