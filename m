Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013065.outbound.protection.outlook.com [52.101.127.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93B4143C69;
	Wed, 21 May 2025 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747838010; cv=fail; b=b7gU5zEUdqyXFlsk1G8daEqwVesrRrya/nLOXy09dOFEf6oVWjWjBarNUt0vfEsSLzkT0NbpxSHGvomEYleiiKiHhep27j5rIpteqoVUQLjftLfJ73whwcVn4aJOcN+ohXa7reeswof0+ImpHAxYFisSXVHdY2j1rfx/jqkp8pQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747838010; c=relaxed/simple;
	bh=vmQALVeBCw3GlZAC5LIPTC9sr0NmXX3emgYnqYNS52Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MB2cer/wTnNn389G3Q/L5sjK9EeS98kRakJMpLSddrzhA7NZhgxh7MM5XQBprWOEEwS2N93tjinysvuVZ1pW3YopaIkazQadUP9leLE/Z1hTu07YyzkObp07Sl1uUM0TnZrR2EP3g5XR8YibtfdfnxD50C1MRNwXNe9Q1XSxerw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=JcpIP8A1; arc=fail smtp.client-ip=52.101.127.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="JcpIP8A1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fSx7T+vADR9guiiyMWENWTlH63x+sffE/RuTogsagY/RTDhsssgglGBuj0zDnURmPyX4oJRxbn48+7LPvNj8azD6naie6s2KRmdHxrErOrkuDBGo7DXWVPiOjCuHjbypgz4VDDqLvwTc/py8dqI02CWoIpjRw7GPdRF1UGKXJvTeOyz4lC/I7g298toSescu1i7/CTJ8ZVSQfM2uvQVPuvM/oAfGz79tyNu/S8KiO5Ze7YwqSyg6ySx2NBnOaaihdtQG+8GBAPZBnJ6G6f2h99MNEWpmVJFLTfOT4ZfF3MD6aOvEi9tGz6lRBPOggT4TN1EODgE7N88UIR3HnRut5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xg2jOESXo5XxrQRjgpTPbmbPZk6PRCS+NkZwRmKScA=;
 b=Z1o5kzMAW9RcaXFSP96ntxTCg6kgVcaPJXI85Si18Ca8rbuzndDS99C+2Y96n715I0Pur+/sS+bZehv1NhWV0MKrr/OKW0JeHFO/2dfN3AqcBgGefe7aIt0nSRwjqhWLVdMhvjKoNXKL5ZxbFIz65yY5vtkY345bcGYei2KeOHXOfybuIkPT8dw4UGSFk7aKlnWGIUxOY+3DuKGQD4wbmUz21mQpfltMwl+2eDowPndmzHboz7NWMLfRNbR0yJ5NX4N3Iv3sdciZmnUbeqDfxVNr/Qrg3bozjg9dwnP0xQ/naVvjcG3HBxMpuhyru2CEVt6I/6NWGuR5hHi6dqwJ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xg2jOESXo5XxrQRjgpTPbmbPZk6PRCS+NkZwRmKScA=;
 b=JcpIP8A1rEUtJSwyoSDX94623reIirXs15+xx8tsfT82PkzLwVi/ahT4hJJ5QzEGirjqkwDEn4JqKil2xXhdo7TH3gYm7K5dqujyp7ELtfblCrOXaXS5Cz/SWGzdN3BGwZHAk2BA+oPxWkytBkReBMrbUUvk7Q/nxwQsI6yw6u5FZOS1XvVqbNKuKI1PAiWsMEigJcBz55uQSkyKqI5ohcsSoBqE8q7JKUIj4rLZgVY3oHI1raYuTuuhjp+9v3bZ7bpFHOzXXtWdRKZqUzfBemG1d4AKYdnep4KSDEzMj8FVJ53XzM7F+uUJuaslGNH0YgDjC6H+b1TRtcpkcOLLLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYSPR06MB6605.apcprd06.prod.outlook.com (2603:1096:400:47d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 14:33:25 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8769.019; Wed, 21 May 2025
 14:33:25 +0000
From: Huan Tang <tanghuan@vivo.com>
To: peter.wang@mediatek.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	angelogioacchino.delregno@collabora.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	opensource.kernel@vivo.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com,
	wenxing.cheng@vivo.com
Subject: Re: [PATCH v5] ufs: core: Add HID support
Date: Wed, 21 May 2025 22:33:17 +0800
Message-Id: <20250521143317.637-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ab468bb26dafca673d7ffca7dff519b7cf024cdc.camel@mediatek.com>
References: <ab468bb26dafca673d7ffca7dff519b7cf024cdc.camel@mediatek.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::23)
 To KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYSPR06MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: 7079b35b-27e9-4b2e-059f-08dd9874720c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?81fWjTU95yIl3uk2jzZeZEo4p6u8PBaYCl1IKuOaRO71v0KQAk7Z4AZKTDYB?=
 =?us-ascii?Q?NIoaIjkskhjleu7HHAsMKZJ1QqAD7cw0KfczCeNnaHxQDn8xtJSUNQH1Guok?=
 =?us-ascii?Q?FlxAursfIFbuuCZRG8Kdguzuob0SsgBSmXSUjWb/GDGEuGt+ZFKaYR1CvIbR?=
 =?us-ascii?Q?3uMvzKPZyAvm01eW38ZN2ChBmHOC6dVDhdL01teqkVY+5mG8b27D3zSlIWWc?=
 =?us-ascii?Q?cWLA4+MMkv2i4ChFJMP5pGdFTPiibbSL/mluolE8m+HlhGAeowMF9ZSNr67x?=
 =?us-ascii?Q?DvEOeMSBozcAcUpt1upAIh7MpwMQex7Za9Q7KyJ3JxIr0yJPWu/S63jfOZoe?=
 =?us-ascii?Q?CT4D1n4tCc7jkaQcJKZY8q3dABhIfh2Ez0CrG5YkpDR6odTUOINq1S4FV1KT?=
 =?us-ascii?Q?KfbpqJMUEPYfc5fvS7Zrbjfn8DF4Ik57125vu83gva/HK3PwwDwSiArsh4WJ?=
 =?us-ascii?Q?lrwLi2Jew4bHdbYHFv7DtpHAs1Q+EfkCaPOrqeii0nEfZfaAF/kQncixyzeT?=
 =?us-ascii?Q?tv6JZjXxAvUoX5kJ/WfcNyXomLpFbIjkifxd71Glkk7TCL2GnumbwfqqAOwf?=
 =?us-ascii?Q?oiiBKoJ+F3PEjbu67ZW7z+UgyfOANQrcVQKk1lv5SOIsAteWRsqy8zOE2Xrk?=
 =?us-ascii?Q?wIiZjnd6godk4J8RLpwk8L4oT85xSZMTLTz3KpJtQaOV23yLBei4ApFX00fS?=
 =?us-ascii?Q?T5Xa3Z7xhohDGRCrMVVFyT+INrgkS+eNmrB/lCwGw0j72M8yl+P1GhyQfwBm?=
 =?us-ascii?Q?0N2Ih1UlzEO9WdtDE8GHJZ+CdUb9tGt2usYgFvgpAJrVi3kLmhvZ5IJmGLRt?=
 =?us-ascii?Q?rhyUPs8bJa2cbAQSHAXoh8Un+5ReQNYQm4/l9+arkgzAlaMg54NONOWNbBy1?=
 =?us-ascii?Q?FY9VwPE8rYl1HqyTLRUwzBydRB/PyZk6oogNbWX3WkSfi04TE+eHchGAR5jB?=
 =?us-ascii?Q?Ka73iRcCWWOrvB2GdBOV12hX7EQFhMjv62F+egZA9G6Zt3iqdHCrYW9+ZHmk?=
 =?us-ascii?Q?PzpwS1fa15OLZHs4s7BVlEyoUmbEIDo1kf/DMS0NvBlO10sA63MeA44ZWu4n?=
 =?us-ascii?Q?4w03dI03iJIAD+TWdybfmiYR5dmx8YB+cACSTXGdjA0QxJXhE96zUf6SdTF0?=
 =?us-ascii?Q?ag+7V8e6h/GojIO3o4Qa34Ynrzv62tk3zAioavogToWGHYMTxd6R5RSxFra/?=
 =?us-ascii?Q?MYzR3vQgNorHtJG7STBelNYtlAlFsS31fUEWdtVKYWa0gNjJAKG1x2b2yiTo?=
 =?us-ascii?Q?al+HUwaa0d23UlaVdXkj8+CHrOsvEP3acUBa8nj3wXqAMrbOQCjFkfPFM1f4?=
 =?us-ascii?Q?b+XDsBf0FBMUfw0aCpHYHDSPZgW1FxBti5p3PFAGbgGzx6DwnM4f917GIDaV?=
 =?us-ascii?Q?/rb7gIinHhtpdptM9hNhPtwxbdxrimEu8y0OW4VMFBDqQ0hgr6mFwMH7c2zi?=
 =?us-ascii?Q?1aVbNyc3+rRPYOc2gkK4dNLjxvfaR6YkhkcQkYbDi+UXOVk0FLiHiw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Me1BQWvxHnOenhlHowd4vf6mAGmBgJ+J/TkXMQalyJSRPVwI/mHdPBEUTw0?=
 =?us-ascii?Q?4DVNaU3Q3A7balMF7YAwN2cqS0CbWDCzICyqr8ivU6GDEuGPJqA9WQrCQ8sG?=
 =?us-ascii?Q?f2QrnflDQMznfrrKnJDJWuugOm6DZu3pbtxxCUh9gMMahxoXackEMDY6v9nk?=
 =?us-ascii?Q?mu4q5plG6EoENpBmiEbKjsr5Q50CEdnnAV3eO1JI+zRxbU0pEwEjt7jVR09L?=
 =?us-ascii?Q?n3DUG5bU8P1qBa4tBjIw/i/uLSE5B2eQSybQ4x+FRuTJxSbLnzvutvPhc+gj?=
 =?us-ascii?Q?+CmbmTpGyPHkOTF7E4qJUaXu6cZO6z7sK6Qk6qYodbcJikbbyKkBED4kfELg?=
 =?us-ascii?Q?utcbJR1IZckVXq/SUO95RmqpUCFUVX04w4rQp8ThY/Xc5tqYpWWTET/P7c/Z?=
 =?us-ascii?Q?kQ6Sr5Ght4yxVLRJZgeNV8ZA8pC5dhiHbtZU/Le67BYKOlKb+31zGSSVKDYv?=
 =?us-ascii?Q?fzl0hhEWDDskKK7RobcNlkQfSoEyxWoAF+jgw0g65yNP/Eyqb1KhGpI5ND2B?=
 =?us-ascii?Q?v3ybvGG8Yrs/DY9Z2eSRamwzV8avjXJOLmfBvk1nn8ZUsXlv7yds2j/2aLO1?=
 =?us-ascii?Q?XjqWt1Mk57pb/GU2zXDkFEdgQqYbwUrQau59VKVFEBZkMzNlcXrz5AdohNEa?=
 =?us-ascii?Q?A0uPvuBgbeXykRc46S0R+dtss5UF40Cc5rmFhsw0iAdCucUCXE5nNn0gcWXX?=
 =?us-ascii?Q?Xh1DyQqPbhwpR8zM0N0I1yfJO0IZkAaLRcVOTQ7raN4vHqfL8mMFSSF0OErm?=
 =?us-ascii?Q?Gfw/1WJukUTTeQUkgN88rYv3/ZP/Jyz+xxDEV80aGDNLkg7KpEkr/h53/Muh?=
 =?us-ascii?Q?0ditXll2TaoZFMiDIQNu/7EPdxPEV/xubpzD2f6xiRXlMiEm0nc/RUhI/8oc?=
 =?us-ascii?Q?U3nBiZMXwE1ru/z8hk3/p3bEspxE5bqV9o5BDj6hh4koL2U8rHuqyFUjiwP+?=
 =?us-ascii?Q?Q2yz8j9j6zp8eEoT0Ud1aIJvEafE/4Cis/iws8GCr66Fvzu3jxlq90XqRts3?=
 =?us-ascii?Q?8uxVXOYSjjqS8bXH6r4b2/zCaXbPg9vpuSrFlKaHpCe56E0erFEwOgDEp1Jh?=
 =?us-ascii?Q?6CXG/mKnhzUcsZu2o4t7mFcbNmC9nMeA30WJzTqRt2/GS4i1MwC/gNjOJH7u?=
 =?us-ascii?Q?PemDnc4dA1nZ/JlQm9E9Pmwk+VXZeZCAugqXZ+iaQQVqHamJ3AlcxV83P7Zx?=
 =?us-ascii?Q?aEcpuYy7q5Hen760+ab/kJPrka2sWYCd3lgZEkhk3s8PZVmgGhAPyg1bvVi7?=
 =?us-ascii?Q?Rn+je0wWHwTbNT6qgutuk3LLMKgdT5/kWd5/0RE416m7k9xS4V4AsnJRUji6?=
 =?us-ascii?Q?nPoC/0zRx3JGR7AynYZw+GsGw50OKLFIrbjQWsm1JQbol9n9m901FaDxx5+z?=
 =?us-ascii?Q?4Hwia2Me9X+0IbV6sxIXmWWEW3rwZDdysnIKxQZmf4r0Fo/LFkJkcSM7CSIU?=
 =?us-ascii?Q?Qy/IOZbYU79/AxQcEXYe7zHv9L0/wfz+tjshCx1KcTY8fBieYIX7CjcXd/RJ?=
 =?us-ascii?Q?vr0UV5nFcs0rNZR5z6QtAfsPAHdq/zgHHO7MEvlYlIyG9ui/i/4fYzh7A0TW?=
 =?us-ascii?Q?Uaqee/etccFAxPz1lrO/Zlo05M9nlmJaiChtZCN3?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7079b35b-27e9-4b2e-059f-08dd9874720c
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 14:33:25.5740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d8rQORL12QuVN6kdOWvpzRsJyxpap9P9DDtI+WXASDsHtt7A0kc9KAr7DGHrdkW6NHvYYvft6H8T6fOCG/o5Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6605

>> +static const char * const hid_trigger_mode[] =3D {"disable",=0D
>> "enable"};=0D
>> +=0D
>> +static ssize_t analysis_trigger_store(struct device *dev,=0D
>> +               struct device_attribute *attr, const char *buf,=0D
>> size_t count)=0D
>> +{=0D
>> +       struct ufs_hba *hba =3D dev_get_drvdata(dev);=0D
>> +       int mode;=0D
>> +       int ret;=0D
>> +=0D
>> +       mode =3D sysfs_match_string(hid_trigger_mode, buf);=0D
>> +       if (mode < 0)=0D
>> +               return -EINVAL;=0D
>> =0D
> =0D
> Hi Haun,=0D
> =0D
> Consider use below coding style for readability.=0D
> =0D
> if (sysfs_streq(buf, "enable"))=0D
>     mode =3D ...;=0D
> else if (sysfs_streq(buf, "disable"))=0D
>     mode =3D ...;=0D
> else=0D
>    return -EINVAL;=0D
=0D
Hi peter sir,=0D
=0D
Thank you for your comments and guidance=EF=BC=81=0D
I think your modification will indeed improve the readability of the code.=
=0D
What do you think of the following changes?=0D
=0D
ufs-sysfs.c=0D
+static ssize_t analysis_trigger_store(struct device *dev,=0D
+		struct device_attribute *attr, const char *buf, size_t count)=0D
+{=0D
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);=0D
+	int mode;=0D
+	int ret;=0D
+=0D
+	if (sysfs_streq(buf, "enable"))=0D
+		mode =3D HID_ANALYSIS_ENABLE;=0D
+	else if (sysfs_streq(buf, "disable"))=0D
+		mode =3D HID_ANALYSIS_AND_DEFRAG_DISABLE;=0D
+	else=0D
+		return -EINVAL;=0D
+=0D
+	ret =3D hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,=0D
+			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);=0D
+=0D
+	return ret < 0 ? ret : count;=0D
+}=0D
+=0D
+static DEVICE_ATTR_WO(analysis_trigger);=0D
+=0D
+static ssize_t defrag_trigger_store(struct device *dev,=0D
+		struct device_attribute *attr, const char *buf, size_t count)=0D
+{=0D
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);=0D
+	int mode;=0D
+	int ret;=0D
+=0D
+	if (sysfs_streq(buf, "enable"))=0D
+		mode =3D HID_ANALYSIS_AND_DEFRAG_ENABLE;=0D
+	else if (sysfs_streq(buf, "disable"))=0D
+		mode =3D HID_ANALYSIS_AND_DEFRAG_DISABLE;=0D
+	else=0D
+		return -EINVAL;=0D
+=0D
+	ret =3D hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,=0D
+			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);=0D
+=0D
+	return ret < 0 ? ret : count;=0D
+}=0D
=0D
=0D
Thanks=0D
Huan=0D
=0D
=0D
