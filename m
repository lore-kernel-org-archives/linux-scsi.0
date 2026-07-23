Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022122.outbound.protection.outlook.com [52.101.96.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD173409637;
	Thu, 23 Jul 2026 22:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844114; cv=fail; b=SFrqJL1cpypUgwisP3BCvnGavSH+XeyVmqYbC+RWwA5ymNF9XpWCMTXLyPC1/cVe3GFge67HhuMDCJzB85+iAlIh+ecFoWsQJhbjIV6VI+zmOI41WUTDw3cImqv421EFCIiA9vsGtKy1HbKvcfhZ0J+4eTQamjdNjLcU5INyhK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844114; c=relaxed/simple;
	bh=pYQgPO5wiRCC5h7KJp/z49CIDNLvmHAQCTa3fZfgvHs=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=ZP0sq7YQupSUQ7M2sRt4+ZvB2iNQU6WKkY5WqGPnMyc07Q4rLnwvxN9aTKoweOsJvQGHe4UUo70m87Nv50D65mA9N75NhHWKhL4ieRDMVNl0RR6sQJ1VXoTAo6bIPkVpAYNSFbtyq67saPW6CIiBVeptLyjiN1WVTQ1pxX9+AgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=LxntWCI5; arc=fail smtp.client-ip=52.101.96.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="LxntWCI5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0sbRAdoOEFxnJmRv6aybiRDg7deCketsHfKPEEfCAqgzJCjaKLeQAzNdkprZUDTvEihunva5xXGD9SA/UKUiPe1fEuo60itDrJuDo43eQZdc/ZAk6T9oluYVeTITinZ5624Ncsu5N3r3dpK93C8VjsbZN67zD48Ie9Iwwq8qo0VuzaSERTjbywjlyjWEmnATViv+EU0mqstrUbaMpqBBMFflH0xcNTPN+plLtSldl1ORgCmSdvDaQdJm12GfYSfJbkOHPqMsiFLW29mc9YuaqG+FcZgxm7puAeS/lWdJZ57yPwKbU/EsBuC4GcB0p9MJ87R6pqTv78RAb2WTERyMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RW4gY9UhdXKHzCxAtkQ7v4/KkEzW742bBR1lTORUrPw=;
 b=TfXUFI9Za1SYqw511wOAezRqrWdq1WJ/RJ56JNdam/vUUDtMEpHydDG1lrjfuTmxvtcJvPnJHL/vVr4fDHVI8ayBB2cOZ5fYLrl2mREbQ2/02RnXsL+D9wjKVWyNm1YA+ps+3GkzZVpD577fxon7blr1BNjmAebH256hXY/5odwt2IKdsmCna19anDxoXqAf4gF8YH34F4knTrA24oL5mWZ8nm5lWvpnSAAB+sbmbHcnGT1dJ+IDPyVEAp50/DYluAG0xNDK3bwJOXVj3QIhpg/R3Bxs7mh0YHjD/bZZgY5QH3MCFarLgt3qBmEAQcy28RE5X/iv0W1IRRbU1f6BPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RW4gY9UhdXKHzCxAtkQ7v4/KkEzW742bBR1lTORUrPw=;
 b=LxntWCI5fv0Iceo5oBnhxvxUjIz+NAk9QDrfDTLTG2XshVgMlmOzCGV2wi3+JU8nAOFKjg8ozfDD8s4HaxCarr+UHVrULmVAV4gFrzY2+tMXhf+GrS7jcIfBwJslgZO0L155pVEhTjWKRo3ck26l+CA4CdBK4Hwgh7dUePWuFCo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 22:01:10 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%2]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 22:01:10 +0000
From: Gary Guo <gary@garyguo.net>
Date: Thu, 23 Jul 2026 23:00:46 +0100
Subject: [PATCH v4 7/9] PCI: Make pci_match_one_device() match on ID
 instead of device
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-pci_id_fix-v4-7-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
In-Reply-To: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
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
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 David Airlie <airlied@redhat.com>
Cc: linux-pci@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, 
 linux-scsi@vger.kernel.org, industrypack-devel@lists.sourceforge.net, 
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Gary Guo <gary@garyguo.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784844066; l=7173;
 i=gary@garyguo.net; s=20221204; h=from:subject:message-id;
 bh=pYQgPO5wiRCC5h7KJp/z49CIDNLvmHAQCTa3fZfgvHs=;
 b=gMOnapS0Z/YNCmQr6oaIOvmACeaoTbVj3C/risynNl8reo590MNdq/2QVD4m66jFPk2jvfDqH
 xQm+vCALGYdBG032Jws6tlFVi0QyQ5B56rMN2WfsNs4W5YopIh+FLdy
X-Developer-Key: i=gary@garyguo.net; a=ed25519;
 pk=vB3uIX95SM4eVrIqo1DWNWKDKD2xzB+yLLLr0yOPYMo=
X-ClientProxiedBy: LO4P123CA0115.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::12) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO0P265MB2635:EE_
X-MS-Office365-Filtering-Correlation-Id: e296a4a3-fb40-462f-9dbb-08dee905e77f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|10070799003|1800799024|921020|6133799003|22082099003|18002099003|3023799007|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	51dCGjYFm2hjRiNFX9dZsHBRNWy906CsBiKKObPqQjtQ8FdcylqO9El0sM7U3DEzDqeu+Tyn5D6Arkeh0hUWIdAMFrey2AdTP3FCDtzhtIeMTVgJ3i3SIG2OZendSsH9FysQ/575+PJwLcfHfASJnZdmL1WvV5DP4jh7rGQEnFe1WBAPXje53ZN0GdCmSnFvXNBWxYNc5zwfKd/LQ8Mg80FaptdzZRHBzks9OzsYTOCt8vEp7ly5IyZ8MvOEQO92zpAqrVBAxrwjKdJ3DHv58IltIfFgkMCDGNniGT5UXNIKHhKMC17VCtQQ7ubhqI76BW+AHW4nB4vJuVF3qU2sLJNwd2HBe54/cHLFKYijpY4aKa8aYv9jgW8Xr7dgnfIInUXS5KAKTaottQIFmVt+C8tOgHcNtn6eaXw0tiloR70LPM6mbKonC5yNwp4067PdqCepVfmjwaKkohYJ91oVX4iSE73ezHiztGyneLyN21mBqt15P89RLD2O+coyBhqApyKEd+sYQejIysrVqUevBRteNARIEUSIxZu6WhqP0s0tUzXTQP3Mif2nFjDhelHkLsOBgWb8esCgoBJxLB65eU5AIWFmVojzGhPI56CbSapHyCrdGQCe8Tp0pdUuvugbGMpMpWYeO4DbZpPS5roNQQai0NQZEyfa1rAhMheYJ1TDKw6FNRR1i8D+X5EIl50VBA9D2Sie2mSM2wx2bOo1PA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(10070799003)(1800799024)(921020)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWVyZWxkNTliZ1VsQ2tSci9ESnp1V1RQZ0ladXBnLzY2MEdTV0tpOGl5dmhx?=
 =?utf-8?B?TTB5K2pwQ2w0WTFxTnloTFN4eXB5SHAyeG5uS2twWEN6Y3NHZDkwRE0zUUVj?=
 =?utf-8?B?Y1k3NmZzaG90MTJucjBpOVlHdExqcEhHUjhTZlBPUFNocm1XZlFkejFYQStj?=
 =?utf-8?B?c3QwVmg1MVpxUkJYc3NrRUtaL0FmWTFhVU10bWl0b0MxSTNRd1VGbGRXZFpw?=
 =?utf-8?B?WXB6V0RjVlZmMlhTN21iNEtza1pZbHJtOGw2VDFrR0pmM2NVUXJ1eFBTL24w?=
 =?utf-8?B?TjJEUFlMZFFnSXFGeE9kcGkzZ01LR011d0djVXprSVVZQkhXb29UREphdEQ1?=
 =?utf-8?B?ZUxUTWpabnFnNlBOendGTzJRdWNyTm1rRm5HVnFocTBScStSWURraUNHSE1j?=
 =?utf-8?B?Vng1Q2MvcUs1ak5LWkVLSm5qRXRscTluZWdEaDlQaUNoYm5jNTFuSkFjeU1H?=
 =?utf-8?B?ejRwZ2hXVmxNdUw1N3hlRGpqR2hJSit6d3hzK2dvSFFIQURhdmdKTjY4KzUz?=
 =?utf-8?B?Y3cxSTUyYktRbGh4ODhhN05mMFRsRk9vQmoydmRYTXRWWm8rUWY1ckJVQzJo?=
 =?utf-8?B?MTZ4Yldnc25ZT0ROL2ExaG9TNXFQT1Z0SHFHcG9Ec2FLSU81czFqMkhWTGtM?=
 =?utf-8?B?RWhSS0FFVEFjTGdCSTNQc3oxcm93SnhXM0J1aVFFUkJUam8vUlFtNUwwU25i?=
 =?utf-8?B?ZlpzcXkyZ2FhMzdzUC9Xa29kQ3RiTmdETG5TSWZWaS81aC9mVGt2MWcyeHNu?=
 =?utf-8?B?Y05kS1JTdXVHdFBmV09zT1FvSU9lRCtrWFBEaE16UkxjbExiWkZrd29EbEk0?=
 =?utf-8?B?bU5qTWttM0RINWFGc3ArMk90Mm1WTXZ0bWJTdVpPNkxPbVF2THNSQ0d3aG5t?=
 =?utf-8?B?b0pzTDlWdC9SdmhxeTR2ejYycXY5OUMwQ1oyNGVNL0pZL2pxZ3B4N1ZNd3NO?=
 =?utf-8?B?ZnBObndxT0RKWExxdXlLcjUzYjZnUm9ibVJFY3o1NFFDcVZVZTdJNi95ckxS?=
 =?utf-8?B?SjRHTWRkMGxSN0F0T05IUlQzNVdUQ1lQdGI5UWRFM1M4S1dGWHRSejFqSUdv?=
 =?utf-8?B?RVUwUit5SG4vUk5LT1pERk9iSDRYWFZXTWZwcE5iRXpIaDhjRUZZTU9LNkhT?=
 =?utf-8?B?NThnamRzMldqdG10S09JOU1lS3d1TDUxWGY5QVlMNFRyYzJwaTl3bzJHSi9P?=
 =?utf-8?B?ZnZOSnpNQUFDTlMwMG1JRVVBcFdaZ2V0TkRsazVTOVczYksvYmRqT3Q1dmU4?=
 =?utf-8?B?bzVnTlRFcURkL21ZTm5aTTRSaTJIZDBrWlpnWGEwS00wcHJ6bFV0WXp0enZK?=
 =?utf-8?B?K0pRRE1UcExCdHErUkMwZWpOaFVHSVZITk8zVjR2SGhNaGdma0p2dHQ3SDJ5?=
 =?utf-8?B?bWJzbW9ENXpDTTBxSnYyUC9DZVlxZWtPUGhNMEdhekJOM3BRQzFYaVo2SDVh?=
 =?utf-8?B?bTltQTRsMkVWdTBlckFtcG1ZUVVwUnBOYXNLSFZBa05JYlJWUWxnSDl1bjFz?=
 =?utf-8?B?L3FPNUZzTkRWS0hidzE1bzJBWkRmV0R3Wi90VGJsay9HS08ySWFvTys3RkdT?=
 =?utf-8?B?OWlvalRwRUlZTTQ1T2QxbGdnUXhoV29zNmMvU0FrUWUvUWNCeTVSeXdadElD?=
 =?utf-8?B?aU9USUNRUThqdzcwOU83TEJidmR1N21ZTGlqWUw1dXJLekE0cXkvRnY4MWs2?=
 =?utf-8?B?aXAxSEQrYmREV3hodWhrRXlFOTBySTkwbE9oTXFDZWZEM3JPL0VNQktmVkdM?=
 =?utf-8?B?RTQrek5ZdmdpUUFnYi85cFJPQmd1U2ZsMkZZNnJoUEd1WGROUEtSdjBZU0k2?=
 =?utf-8?B?OG9oWjJuSW5vY1ZiWTY3emZrVEpqRFhqNktWcDFXQ2pOWldqUk9aT2IwYzBv?=
 =?utf-8?B?WkdXSm1QQnV2ZzZDU3EyZXhBUy94aXBkOWdVN01heGkrLzdtdFIzbERxdGRY?=
 =?utf-8?B?QUZnaC9USVVIOXNtcVlrbUd0T2p0L1pPMWxvdktsK3lTU2JLT3pscDRVQ0ho?=
 =?utf-8?B?cERRYWN1RWQ3b3J0eFpSOCtFbmR3anBMbll5YjhlcWhEOUpPRjFpaFo1T0pW?=
 =?utf-8?B?VmdtMUJvcnlJdnROdGhkSnlkanRlaGRZZzcyYXdRa3NrN2F3ckdxN2RsZzlz?=
 =?utf-8?B?V0ZzVWVsQkJNMEVQMTNHSmdKMGt0aDMzS0ZOWkwwb0JjcjJwT0lPYWdzTElO?=
 =?utf-8?B?enRIM0E5WTVCV1NIVmZnd2ZESXNodHNWeVlqQnZSRU9VUTBCaDcyTTJZRFkz?=
 =?utf-8?B?d3B6QTVTWXNTSDl0Ym0yR0l6RDhsWnlWd3VGMm9XcGtMZVBkR2VDWkdMMDVx?=
 =?utf-8?B?UEdndk1BYU1lN3YyVlQvVkdxanNiNzZWYUpFdnVMbDBDRndLa1hGdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: e296a4a3-fb40-462f-9dbb-08dee905e77f
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 22:01:10.1718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GemVT4dC7dDrwKarlVSc3A7BTNSDBkElbQK44xyRO2+e3M+GzafsdlYVxgCiSAiqmswv2NpSXqnx+lQGbXLvzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635

PCI dynamic ID needs to match IDs against a new ID to see if it already
exists. Existing APIs can only match IDs against devices, causing the
dynamic ID insertion code to create a temporary device only for matching
purpose. Rename pci_match_one_device() to pci_match_one_id() so it can be
used for this purpose instead; add a pci_id_from_device() helper to make it
easy to convert users.

Similarly, convert pci_match_id() to do_pci_match_id(). But keep the
existing API because there are many users.

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/pci/pci-driver.c | 38 ++++++++++++++++++++++++++++----------
 drivers/pci/pci.h        | 43 +++++++++++++++++++++++++++++++------------
 drivers/pci/search.c     |  8 +++++---
 3 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f36778e62ac1..c9424edb4548 100644
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
+ * Return: the matching pci_device_id structure or %NULL if there is no match.
+ */
+static const struct pci_device_id *
+do_pci_match_id(const struct pci_device_id *ids,
+		const struct pci_device_id *dev_id)
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
index 93731242d314..71cda71f3bc9 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -443,21 +443,40 @@ static inline int pci_setup_cardbus(char *str) { return -ENOENT; }
 #endif /* CONFIG_CARDBUS */
 
 /**
- * pci_match_one_device - Tell if a PCI device structure has a matching
- *			  PCI device id structure
- * @id: single PCI device id structure to match
- * @dev: the PCI device structure to match against
+ * pci_id_from_device - Obtain a pci_device_id from a PCI device
+ * @dev: the PCI device
  *
- * Returns the matching pci_device_id structure or %NULL if there is no match.
+ * Return: a pci_device_id filled.
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
+ * pci_match_one_id - Tell if a PCI device ID matches a needle PCI device ID
+ * @id: single PCI device id structure to match against (needle)
+ * @dev_id: the actual ID from the PCI device
+ *
+ * ID can be retrieved from device using pci_id_from_device().
+ *
+ * Return: the matching pci_device_id structure or %NULL if there is no match.
  */
 static inline const struct pci_device_id *
-pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
-{
-	if ((id->vendor == PCI_ANY_ID || id->vendor == dev->vendor) &&
-	    (id->device == PCI_ANY_ID || id->device == dev->device) &&
-	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev->subsystem_vendor) &&
-	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev->subsystem_device) &&
-	    !((id->class ^ dev->class) & id->class_mask))
+pci_match_one_id(const struct pci_device_id *id,
+		 const struct pci_device_id *dev_id)
+{
+	if ((id->vendor == PCI_ANY_ID || id->vendor == dev_id->vendor) &&
+	    (id->device == PCI_ANY_ID || id->device == dev_id->device) &&
+	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev_id->subvendor) &&
+	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev_id->subdevice) &&
+	    !((id->class ^ dev_id->class) & id->class_mask))
 		return id;
 	return NULL;
 }
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index e3d3177fce54..34f8de551d58 100644
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
@@ -416,9 +418,9 @@ EXPORT_SYMBOL(pci_get_class);
  * @class: search for a PCI device with this base class code
  * @from: Previous PCI device found in search, or %NULL for new search.
  *
- * Iterates through the list of known PCI devices. If a PCI device is found
+ * Iterate through the list of known PCI devices. If a PCI device is found
  * with a matching base class code, the reference count to the device is
- * incremented. See pci_match_one_device() to figure out how does this works.
+ * incremented. See pci_match_one_id() to figure out how this works.
  * A new search is initiated by passing %NULL as the @from argument.
  * Otherwise if @from is not %NULL, searches continue from next device on the
  * global list. The reference count for @from is always decremented if it is

-- 
2.54.0

