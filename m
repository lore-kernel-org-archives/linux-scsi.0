Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021075.outbound.protection.outlook.com [52.101.100.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D7B3FF8A5;
	Tue, 30 Jun 2026 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817776; cv=fail; b=VVuMVZhKwVejgKdH+S516sifpGPHkj16HPH8c1aMBbC5jWQQvujTq+NY7NPIRzCneEHQ8s/i7tig25CB2+a2coyFWKMa7CBE737AG9KwGThxi6y7TLhepkT2C+kiqarxXSHbeao6SxNaH6RfBMhC2ECh9C0bw3y0qLguwy9DGT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817776; c=relaxed/simple;
	bh=iEnXy8hi7mfUE1wsqlrCRWwdsgyS6SF8petWt+yJ9oU=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=G5ubRM9SaNZWkDHsEqtp4jMCtt3hfHPFJv9CWM5GJKkHkuVGnK4GRo5tXlc764+kiO5TRfwRDG6acyWXYvqSJLjehOoqd4zBFD2neMdq2gvHJYmMYYaGxm8Djapu7Kcqd9sZqrflwIH7q7odYQJw9+2OCfklLewbQ62Bk2mTXvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=SSC+oU8o; arc=fail smtp.client-ip=52.101.100.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="SSC+oU8o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ORaSbaKgn8sR4bbyijgAiirszSS9CN+u20E4OvAF1v3og55g2GFD42MwQsTBgeZBV8pi20GJXRw9/vp6J5v3XmS19lgJ0ZTlRenjc0guWgYBe4qRVs0V97UyoLkfsZSb6vPR2qGGSlG/AMlueKd7MVJN0JjzkAxgD67A3qDCJkXRRPwqDWauHkeT21FsjbP0gMv+YEDlKWRvEsEfSsxCNImXXb7I7ZpVlCWFuk3EuR1835INg8PejYEBQOgXxS2A40Sgmi/5+S5+mEqGc6zw58zrriiFx28PiOJrMgu1vfgGzEIcR37d3C+f2wmzufM38qYSnhTJUYP5rBR8tYx6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcuL1r1Cq2//Dr5Xo3KRw7qVMRMX9Vgg11W9k8j/ItI=;
 b=i1dsn3gk3/KdxmnCmAhoRCL3hXQ2caoYFdrFwRjJnslZdpEZweOGOWhEI4WkiDnTM2Mjf/wOkZAhS9w+fOb+c1TxTG+cmjd3PSN69RxAeZacxRIGsmIDfu+pmpcQoPzmR2BMsLAg4rScbfWJJ63Plt/OPfnv9HrclDkzB2CPbxhrFgpWyeaIuOBjaLoA6w1ywqfgnY7VZwFUiEdbTID4Ith4kl9b0KPtrQlxOZdGxHCzpa2RbCm1zaSDoFli23sU8v8olHIAQH7n4r6PCFZ8Z6PNzlHvKcYkBnwN9slOtWnzzuXGwgCgsBzgZDYybkDMEQcz0cq9nw9Ax8/CocxrJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcuL1r1Cq2//Dr5Xo3KRw7qVMRMX9Vgg11W9k8j/ItI=;
 b=SSC+oU8oFma5HwADNj0ORkuf7jcI1G2hnAfKrVHEFxO4vRcVcjTfMSfgUm29EqNV+u1SSsYvmK//t4Gc90Rrb+chdW6IIJyJmfGXa8Rffdhn3ID9zJ+xaTEj8Xg0KsQLj3KbJwzYVtJJDkJVZSRjpQdMPZI9Wkb5wC0y8pj303U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWLP265MB6625.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 11:09:28 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 11:09:28 +0000
From: Gary Guo <gary@garyguo.net>
Date: Tue, 30 Jun 2026 12:09:05 +0100
Subject: [PATCH v2 5/7] pci: make pci_match_one_device match on ID instead
 of device
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-pci_id_fix-v2-5-b834a98c0af2@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
To: Bjorn Helgaas <bhelgaas@google.com>, 
 Zhenzhong Duan <zhenzhong.duan@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 GOTO Masanori <gotom@debian.or.jp>, 
 YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Vaibhav Gupta <vaibhavgupta40@gmail.com>, 
 Jens Taprogge <jens.taprogge@taprogge.org>, 
 Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-pci@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, 
 linux-scsi@vger.kernel.org, industrypack-devel@lists.sourceforge.net, 
 netdev@vger.kernel.org, Gary Guo <gary@garyguo.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782817763; l=6579;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=iEnXy8hi7mfUE1wsqlrCRWwdsgyS6SF8petWt+yJ9oU=;
 b=wuNc/Elt3idcswT6Ptdu6TS0yabeuyiuyxuc7tudTnStwMS1itJ+T0nZzd2vV9buJLXYmpVFq
 k7UHWokVuBuDJlT1Htr2/kQzIziUTmAN7fxqF0eUEDlTjZGQ5i+VMur
X-Developer-Key: i=gary@garyguo.net; a=ed25519;
 pk=vB3uIX95SM4eVrIqo1DWNWKDKD2xzB+yLLLr0yOPYMo=
X-ClientProxiedBy: LO4P123CA0142.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::21) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CWLP265MB6625:EE_
X-MS-Office365-Filtering-Correlation-Id: bcc7c2ae-9c00-4758-af64-08ded6980be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|23010399003|18002099003|22082099003|56012099006|921020|3023799007;
X-Microsoft-Antispam-Message-Info:
	k+JN6SO0eJtD3Ezwg6IQwloH8QM7NHfHP7hhC8ugh7AxaFt8/hUUfbndFostO2Ecv9/hZxzyfMI47NCYBctLEnQVXnHx1T0RzYZTDsnV/V2/A+isOUhjlKbylVPBB09yiexXl50GnBYVmiOinE1LxYSOqYuszWuO3deUJwwQBFobSyH8uDQIVYLTTIgKEwVFSovXo2+lWhLeIFBC2TbngjYS6DomQ77Wsm1UVohOr17OZmay4KMbb6Ew0cp69Siv8vjp1Xyar7Bd0n8Y1XpQivOiO0tUWUL/yNUCUxSsghX67chhG2Jrd6+JRr3gfW6QlgQfUy1eA2H30csFqG3q4qVrk2RoZa9D6R954AfQl54jK3YIYelrKihadrzbjalzhW48DB5+mcZQ438tghONp4vxc4dMimjxJx6RaafalpCbKVX9HSRBQsPAgteWeYltlb6P7tlnLX7XjYm7pafb2ksto/WbzOUYlxaCDBZ9MAu5XEirBCds+IF529KRW0MITz7UD7Mb8JsZr9mE67La1RJZNa/6ier6eN16Y86N15S37ljR1LvbB85n9LBacY5K6B04G8R4ZmByeQiSD3miXUS+vPm9wCoZth+wxWHUo60kP6yksRKi0oVm4JCGbyizi4+3iHgr7Ya+xrLcKWyjeiULbC6HEAFqxqH3ou0FXHcddLm+pQNPCi+3OBJjF/vskHZ69beA99J3aMBbSUkZRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(23010399003)(18002099003)(22082099003)(56012099006)(921020)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVhncU5oU0RVQnZ3U25QT21yZzdoTXRkUmhTeURxaHgzSkRUbUdRaFFHSWF1?=
 =?utf-8?B?andlQ3Fqa245TS9PS0tLSWhHUnBvczdwUkJSZ3JmT3M5dk1QSWdmMEFVV3Jr?=
 =?utf-8?B?dFM3WHFmUHRqV042Z0kweXdETEhkVFY5TnNRci9qL0VadHVXSTI0SXlYa0gw?=
 =?utf-8?B?enVnN2pBS3l1M3B0c0NPL3ZidERMbHpwbjk4dVlUMDNWVENkZ1FXT3hla0tF?=
 =?utf-8?B?alNodE1ZQlpWajZuNlZGUkZPdThmSnJGZ216VElKTnY3TXBUZlEvNjI3ZGxX?=
 =?utf-8?B?REhxaFhHZCtlQkMvQkZ0NklhSS9IR3dFQjlBWWdmQUZRMGh0emU5aldXcWxJ?=
 =?utf-8?B?YVJoUDA4TXQ0M3lDdWowTUlGVzIrRUlPWlF5NVZYcVFmQjZLSkFDa2p3QU1y?=
 =?utf-8?B?bmFENVc0bHBFZXdsc2l5cVBhVDZVQ2t1eVc2c1RjaXpBZlk3NG42eklqbWRN?=
 =?utf-8?B?dmI1SUtQNENuSlpsS2xiVVc0Z0I5M0c4VGJOUGxuV1R0ZWJHcWpjeHh5Z2F4?=
 =?utf-8?B?b1Z3OC9xQ25IMkkwV2FiV1F0QXlRSWw1NzZ3T3lOZUQ4K2YvZ0E4RnpkR0ps?=
 =?utf-8?B?bkR0ak5DVmhmWTNiVFlSUlVjazh5eThZQ0Y0U0dqWjhXUzZvZlh2emRzaEtr?=
 =?utf-8?B?ODhQdlF2b2o3anlDWC9TbHNEcnBwY0ZoVm1NdVdoL1VJYnMreFo1UytwNlJP?=
 =?utf-8?B?d2tiZTdZWEhkYk8wRkRtUDNJUDV5cnJNQ3dYdW1SM1VGMEFFU05MRjBjL2pn?=
 =?utf-8?B?bGoxMTh4V3NWNkpleWp2SUVkbC82MDZiNzFhSUVmY1gxUXlGdjdydmxYT0p5?=
 =?utf-8?B?ci9jTXdDVVVFWkw5dkI4ZW93Qk5wVjQ4MzJlUW5rTG9xRy9USko1TjczWkJY?=
 =?utf-8?B?YlRhcVJjWDNGNmRUaGZubzllazRaRlIwNnZ2K2Q2SFl0bVFaWWFlWkRJS0Np?=
 =?utf-8?B?MzNRdHFIdDViTk0xRE5qV2NjUkI4TjJhazJwcUQ1Z0MwRERwd1hXaUZBUERo?=
 =?utf-8?B?VWJuZHNxQ3FReklXQ3VtbVRMcCtFZXFYOVRsK2czb2hoR2JaZ0s3S3YvVDNm?=
 =?utf-8?B?c29BT1l6YTNMWGs0aVFNdEY0cGlRQllvUzk2VXl2QWV4cXBQT0srL0gyMVkx?=
 =?utf-8?B?TVZXQUxZaVJ3QVJ4L2VVSDVYYnNzMDF3aTlZZ21TbzFqeUZHMmdCeVNnT2x0?=
 =?utf-8?B?aWE5MEFqc2M2TE1xQ2M2eDI1TitVRVZNeUlqUDgzWHM5emk5RFErSkVSZ2hD?=
 =?utf-8?B?aSs4c2QxRkZqek1DVTZvUnhHWUFSdmxBZFpnRXNpNlpZeW9kZXV5cUxoVjgv?=
 =?utf-8?B?dmFHaTN4aXJYYXorUE5TUUZpK1lrcHJQZVRZOW5EM01UdE1xaXp3ZCs0cVor?=
 =?utf-8?B?dDd3QjJ2QXVRaXBUVFJ5cGp2TGE3RDBHRHRmS1VteFFrYUxvaFpaS21DTGhl?=
 =?utf-8?B?MkZHK0ljUE94d0IxWWV6a1I2R240MDhXK1hIbWxCQTM0LzJJM2Z4WUt6Njlq?=
 =?utf-8?B?MnJsZXpldUltWFRqQ3loV0xaSTZuY0Z1SE1Uek1CaExDeHBxbHk3ZkhTcmZp?=
 =?utf-8?B?ekZmeURJaG10WlVRZmJ4cGNpWWhlY0dlQTc5bGUrdTdyQzRrMXc5VVlwdHV0?=
 =?utf-8?B?RVFtUDVNNEtiakRyVEo0Y3JacTR1M0NTNkszR3ZBT1N2ZUdVaGVOa1VVN1ho?=
 =?utf-8?B?R0FnTVBiZUs2Ny9Ta3JSTFc0RmRLVFpHMlhCanQ5cHZnSlhWN3lKQTR0cjAw?=
 =?utf-8?B?aTJ1ODFudFF4ZmMxMVppeDFJUjF2ZGNZSDU3VFo2RkVXSjZPUXU0Z01XdTYy?=
 =?utf-8?B?Uy9kdUpYS2h5ejUvN1JFbVZrQTdFYlllcUVveWJ6eHlzMHBDQ3lrRkRtYThE?=
 =?utf-8?B?M3B4Yk5tYzVwVlFtdUhORENZWU44ODllTjUxQjl4TkhHeDdNWkhvRUsvaGQ1?=
 =?utf-8?B?YUxYOWVUZFdKZEh4cWZwd1dUUEVxS0VyanFWVWR4Wk9KN0JFVExmNU41OGp2?=
 =?utf-8?B?Y0lMZUdKNkpWU0JLOTBXcDFidzNEQlBvUnZOMlNWL2x4emZSa08zNDA4eUtM?=
 =?utf-8?B?Z2d4TWcrWkQ0VnZDMDNJaktxdy8xMnNFa1R2WkIzcTU1dU9keUx5YzRkeS9C?=
 =?utf-8?B?RjNuUjZBclc0NGluRWVWNllPMFcyaHZNdTNlU09DbVBEY1FjVCswZHpQNkxH?=
 =?utf-8?B?V24zMjR4a3ZBeU5JdmdaOGEyNEY0dDI5NGtxQWxGZldrRXQyeUdtMXZjMWNB?=
 =?utf-8?B?UTltY2FlREdMT1BXejVwWHcwT3dBZkczRzlDUzFRbWREbENSVTBHcVViZzRs?=
 =?utf-8?B?VGJIQ29xNk9tY3o5S1NHTGFheDB1YkZQNFhmd1E5UUNSS2JIbGY3Zz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc7c2ae-9c00-4758-af64-08ded6980be7
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 11:09:25.6953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3M31Rqx59G77+v889DLkCJMLae9P0/u/GJT1qsqIKu1ke6/bldTnghWT2tGcsXQSA0xHTfRdhMIRPDdb9Tsww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB6625

There is a need to match just IDs instead of against devices. Thus rename
this function to pci_match_one_id, and add a pci_id_from_device helper to
make it easy to convert users.

Similar convert pci_match_id to do_pci_match_id, however the existing API
is kept due to quite a few users.

Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/pci/pci-driver.c | 38 ++++++++++++++++++++++++++++----------
 drivers/pci/pci.h        | 36 ++++++++++++++++++++++++++----------
 drivers/pci/search.c     |  6 ++++--
 3 files changed, 58 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f36778e62ac1..0507cb801310 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -90,6 +90,27 @@ static void pci_free_dynids(struct pci_driver *drv)
 	spin_unlock(&drv->dynids.lock);
 }
 
+/**
+ * do_pci_match_id - See if a PCI ID matches a given pci_id table
+ * @ids: array of PCI device ID structures to search in
+ * @dev_id: the actual PCI device ID structure to match against.
+ *
+ * Returns the matching pci_device_id structure or
+ * %NULL if there is no match.
+ */
+static const struct pci_device_id *do_pci_match_id(const struct pci_device_id *ids,
+						   const struct pci_device_id *dev_id)
+{
+	if (ids) {
+		while (ids->vendor || ids->subvendor || ids->class_mask) {
+			if (pci_match_one_id(ids, dev_id))
+				return ids;
+			ids++;
+		}
+	}
+	return NULL;
+}
+
 /**
  * pci_match_id - See if a PCI device matches a given pci_id table
  * @ids: array of PCI device ID structures to search in
@@ -105,14 +126,9 @@ static void pci_free_dynids(struct pci_driver *drv)
 const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 					 struct pci_dev *dev)
 {
-	if (ids) {
-		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (pci_match_one_device(ids, dev))
-				return ids;
-			ids++;
-		}
-	}
-	return NULL;
+	struct pci_device_id dev_id = pci_id_from_device(dev);
+
+	return do_pci_match_id(ids, &dev_id);
 }
 EXPORT_SYMBOL(pci_match_id);
 
@@ -138,6 +154,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 {
 	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL, *ids;
+	struct pci_device_id dev_id;
 	int ret;
 
 	/* When driver_override is set, only bind to the matching driver */
@@ -145,10 +162,11 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (ret == 0)
 		return NULL;
 
+	dev_id = pci_id_from_device(dev);
 	/* Look at the dynamic ids first, before the static ones */
 	spin_lock(&drv->dynids.lock);
 	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (pci_match_one_device(&dynid->id, dev)) {
+		if (pci_match_one_id(&dynid->id, &dev_id)) {
 			found_id = &dynid->id;
 			break;
 		}
@@ -158,7 +176,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (found_id)
 		return found_id;
 
-	for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
+	for (ids = drv->id_table; (found_id = do_pci_match_id(ids, &dev_id));
 	     ids = found_id + 1) {
 		/*
 		 * The match table is split based on driver_override.
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4469e1a77f3c..0567a8762baa 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -442,21 +442,37 @@ static inline int pci_setup_cardbus(char *str) { return -ENOENT; }
 #endif /* CONFIG_CARDBUS */
 
 /**
- * pci_match_one_device - Tell if a PCI device structure has a matching
- *			  PCI device id structure
- * @id: single PCI device id structure to match
- * @dev: the PCI device structure to match against
+ * pci_id_from_device - Obtain a pci_device_id from a PCI device
+ * @dev: the PCI device
+ *
+ * Returns a pci_device_id filled.
+ */
+static inline struct pci_device_id pci_id_from_device(const struct pci_dev *dev)
+{
+	return (struct pci_device_id) {
+		.vendor = dev->vendor,
+		.device = dev->device,
+		.subvendor = dev->subsystem_vendor,
+		.subdevice = dev->subsystem_device,
+		.class = dev->class,
+	};
+}
+
+/**
+ * pci_match_one_id - Tell if a PCI device ID matches a needle PCI device id
+ * @id: single PCI device id structure to match against (needle)
+ * @dev_id: the actual ID from the PCI device (can be created via pci_id_from_device)
  *
  * Returns the matching pci_device_id structure or %NULL if there is no match.
  */
 static inline const struct pci_device_id *
-pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
+pci_match_one_id(const struct pci_device_id *id, const struct pci_device_id *dev_id)
 {
-	if ((id->vendor == PCI_ANY_ID || id->vendor == dev->vendor) &&
-	    (id->device == PCI_ANY_ID || id->device == dev->device) &&
-	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev->subsystem_vendor) &&
-	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev->subsystem_device) &&
-	    !((id->class ^ dev->class) & id->class_mask))
+	if ((id->vendor == PCI_ANY_ID || id->vendor == dev_id->vendor) &&
+	    (id->device == PCI_ANY_ID || id->device == dev_id->device) &&
+	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev_id->subvendor) &&
+	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev_id->subdevice) &&
+	    !((id->class ^ dev_id->class) & id->class_mask))
 		return id;
 	return NULL;
 }
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index e3d3177fce54..c8c4bfe7817b 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -245,8 +245,10 @@ static int match_pci_dev_by_id(struct device *dev, const void *data)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	const struct pci_device_id *id = data;
+	struct pci_device_id dev_id;
 
-	if (pci_match_one_device(id, pdev))
+	dev_id = pci_id_from_device(pdev);
+	if (pci_match_one_id(id, &dev_id))
 		return 1;
 	return 0;
 }
@@ -418,7 +420,7 @@ EXPORT_SYMBOL(pci_get_class);
  *
  * Iterates through the list of known PCI devices. If a PCI device is found
  * with a matching base class code, the reference count to the device is
- * incremented. See pci_match_one_device() to figure out how does this works.
+ * incremented. See pci_match_one_id() to figure out how does this works.
  * A new search is initiated by passing %NULL as the @from argument.
  * Otherwise if @from is not %NULL, searches continue from next device on the
  * global list. The reference count for @from is always decremented if it is

-- 
2.54.0

