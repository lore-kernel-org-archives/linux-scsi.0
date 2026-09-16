Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013057.outbound.protection.outlook.com [52.101.83.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B5D3A48F6;
	Wed, 16 Sep 2026 16:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576629; cv=fail; b=N1Ic0XXL0yFi8CVQ/rUlX4pQOjeoBaLspDtjB3uD7hvqEXAkBVOTIzCmqFYa2y52hD2Q3+HKLwVVWar1IXIXdai0V3XoUaJT1jikkuXzdi5Lu1ybrWi4xHVON+QKZKWU+2Yxe1vSsX8bFgnW0AFYNr2cVucgtUDQ4OvdMV+EfK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576629; c=relaxed/simple;
	bh=xBeARWKHndUs8d5n4Y7zAAXfxisdfXfN9jVpzML43jM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TG2ak09skdGaOq5f+MidxnEPObJ9kBxwk9E6lBm/WszuqSog/UoV3g3u6vSQTr5DdU344ZXYUGEzsrZNQlllL1tcj3UCiqCZ5ne7ap+lJUXjqtqPu1OqgrRvEwwJl5AXpKG5ArNT8sAzeZjAnLrtX/gXrMA+zPhh8M1hwK39qgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=fail (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=RGYaqZCr reason="signature verification failed"; arc=fail smtp.client-ip=52.101.83.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="RGYaqZCr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=irFvVgEpvX2j8+Lqm8ISupSwcQoKRtAje3b0DD4hmari2U27vV/twZQNxLkEu9Xdzk3dstzi2ARErLMw/QN85vvl10Osey0oWln0c4cuBwe/pX8O08oPCdVJQevRC5v1Ivt34ItIiTurZQj9p5AM9vcxTl+SEZyMNGsd211C4QAhaqEb3q78hs9O7BjbgURa8k+UBZkZjs1YKda9+W1Z8Jss0zZ+Ych7wBJMzuAzu2rjV2q599Yj+bthlCRQVRGKjttzoBf8U66QXjoh7FKqwXdtcmrqtl4muEo7fWWW9PJuh8Ul+p4bXtOZswmCMctdGgtQs4q77F/ReUJwaTPQJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8krv2gqv+mlepKZlaHNRIJow3r7l5IVQl2mdE3hwx0=;
 b=aXFofQOvbmw4j9rRer8fGdJm1QjKVdiWGVo36oBWDBvhbEqn1QdEbpmVjeCs01uJXXmZisJXAEL70pgFoGfFJwiHiqdEbIUjabXQo1WM3XaGGx293cJbTydXWbROth+bm8xJVF0hsoQItWskO+XsaMRgdSEJ/cIbzy3KLBe4IwkYjb0x1nBV6GgXS8RVsBJLJb//g1Auq75qf5UNiInmlSOI+8RS1U3+LR1khx9Kv/w79e6A7VZLWq168mvrNOHLkqr6Qxh7ymS+fvTsvtjmk1Jzwp2hvl1tNG4rCuemmtTuDGCCR6h9gTu1fiP1EaChdMo8IdiRJxVilMe6C6Ec9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8krv2gqv+mlepKZlaHNRIJow3r7l5IVQl2mdE3hwx0=;
 b=RGYaqZCrHaEYyDz6g/EJuLMgx8S9NLT5YoORs7hWM1vlQYpnM33m+Rn8THMAXQl3sdwqgluNtNYY8howh+5kQb35phYN+JR3+tahpS6xCfQnpHkafBsv7pSCgs7YqT9gEbY+VD9VHu5G9oI6KXlfFVDQItC0FJ9sSrhqAwQwOOmWX0WCSn8YaYROnUjPrWOaWgm10CExmr4Lv0+RIp6WS9dxH7lsPwPTJDDIcILvQSf71FzAFIQWu3rqGGq5+K6BZ+HoQDKgNTLrQssLD0OgaPGhfgrEyqElYVDJ4eA2v97/Sju+T4tEBGPH6dr5NF1g5RTDoobBzsbA8tu/0wzPGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AM8PR04MB7364.eurprd04.prod.outlook.com (2603:10a6:20b:1db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 16:37:00 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.012; Wed, 16 Sep 2026
 16:37:00 +0000
Date: Wed, 16 Sep 2026 11:36:51 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: sashiko-reviews@lists.linux.dev
Cc: Larisa Grigore <larisa.grigore@oss.nxp.com>, conor+dt@kernel.org,
	robh@kernel.org, Frank.Li@kernel.org, imx@lists.linux.dev,
	devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 07/10] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
Message-ID: <aqrFo6eFD7fGtrHe@SMW015318>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-8-larisa.grigore@oss.nxp.com>
 <20260916090010.6C7111F00899@smtp.kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260916090010.6C7111F00899@smtp.kernel.org>
X-ClientProxiedBy: CY8PR12CA0014.namprd12.prod.outlook.com
 (2603:10b6:930:4e::16) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AM8PR04MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ab8be02-4db9-4f62-9917-08df1410bb04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|19092799006|1800799024|366016|6133799003|18002099003|22082099003|4143699003|10067099003|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	HUw1m83ugK4Xyb53DTHMtMPQPnVDlE+ck83agDg/4khRcjR1sYfgfvXl0kj58iYklS6DI4NFrMx2oFjxrBkMernl5e6yWs1JE77Ota3JdzpCVvBQ/lq+qiypfcZmTgiVgLEawEf8p+s+WpF3ZjRaDOd60/ib86eYYwhhsVJ4KbDOlMnD+/3kR+9uUyN1xp4CKa4Ac6LxHP3AsWiLdydOkodbFTWTaXnQmgGSVQwqtMAKbZdtqCrAWMno++eCz3MudkmN9iY7QCjIi6nbt8vdcJmBs8oNwgWxJEeeXem1qk+Af/5G/L6gloVAf9E6c2mTLXmTFfBiCKPFrXwVSx3TMvyS9e0kRfOVX9LPkB0GasyDtdRAh7dxxnB/pMUHapiJCo/zOHaYWhMnwdzZ2WUjES0h74JaH5O40Hc3/aRvOyDjvyEF18P2RaJ0JAK7V4/ZujuGuLGf5gbwN9+dHJNfLxzAIIsdQ4Z4rd5OsKCQuJ9uCLrJHXtmPvZ7Tqabx+xv6hupLaNqE0Fjnwik/C9uXuzIjumiSsdhKRnVpG98RbDb+YKqqSFNeGqBdN6b7PZtQQbDtbON1mD36gUSwiyGfg2mkKgRepf0Rsm5Kil1dkM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(19092799006)(1800799024)(366016)(6133799003)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?ki4QeF0Ln2Bt+TfC1EhgzEqEkWjKYyGPbEBxgv5Rzly4lOp4ApM1kKEdh5?=
 =?iso-8859-1?Q?uRru3IVNugXK/2/qmRw3IHz5BBlRGiSLvH/QTsWaFc70p6l/ikk9P2FVnn?=
 =?iso-8859-1?Q?BCU9J3MgZR04+R8rxIDDkaRlF4Qy6dT47znl7aSBAIPHMzutU4Suh202xq?=
 =?iso-8859-1?Q?fy9VrwGK44r2VsSZdUqnqcqhw3KfZjhKFjSv+Ryso2e1b/IKJmpp+x8W3r?=
 =?iso-8859-1?Q?o8XtwXMOqgXKVpNdgsVHU+BtQwofY0lP4pHM2MzLvz96Pr3q4YTG1Sarai?=
 =?iso-8859-1?Q?wnvx+dsOgzIrjgk1W4ng+FCAEYTAdjc3BeIW9qTo9tWLgCQxxM3AawxxQA?=
 =?iso-8859-1?Q?eE2h4xE8nATQat+N1yASdiwPg6HcejDKlvJYH3m1X51TJUaanN0LwWNcxF?=
 =?iso-8859-1?Q?HW+tFRW9by72KNZ/sXTmzOscPT5XkMZ/o5RQgcIxZpJV1pS/3JURRILMe2?=
 =?iso-8859-1?Q?NZznJjUeRatrVxTGs0UKm5cdbiMtK5WI4M/jMYV8c+JjDtDI4a3ctNNeKw?=
 =?iso-8859-1?Q?EFd0KmnptGW/a94ZaEpkDPoF+naDtXRFsgcqyqrvedA4iXY63gpx45W6Ye?=
 =?iso-8859-1?Q?AeOi+B0ZioEoLONPEWtzdfjkpqukn9x/2fD/2o/klb3AuKzEPmrlmuW5eo?=
 =?iso-8859-1?Q?2ylm5PARNPYFXeH5h0+/iROTUmomwj9DKv4uAJWkjQry12c8YTln4H1HoN?=
 =?iso-8859-1?Q?DKLFdwSgng0lpJPWiCt61O3RvmliDWjept0dK1n3EANkCtRy5VYr9iMaos?=
 =?iso-8859-1?Q?wxfwDYiuOyWbiz28iEP+ca21ejLuHm98zwCzlPx103vNwMWeripEGJQQ80?=
 =?iso-8859-1?Q?UbTw0MeXYpbFYMhFFz4EMcv3nJ1WOk0RBmYBhzydBkbHgVjOuyTko1z6cY?=
 =?iso-8859-1?Q?1Uz+6+pOPkUUf5hrULOSJF5kVJH0aeVHS+twReVR0Nhy1JnoUg4pdq1piB?=
 =?iso-8859-1?Q?77HRE7koWi3UgxusngXJ4iMOFTIlOYsy/aFiqk++KuheDGIjoTAyeA4yAp?=
 =?iso-8859-1?Q?g4X1sbEUNIKGiYLYqfhVxbaWANW/x+HcHu3Po5liJU1avWZqdAXf+32e9w?=
 =?iso-8859-1?Q?nhAo+YSjRxCU2NmPoSh+RnSmqA95RJGvSxzgBwRlFe8qtSwhSDUjNSd6il?=
 =?iso-8859-1?Q?dV+EAcvQodSdG5xR2qXschcDvd8DVrER+6KG2RGh4A5S75RqKfH3b8s+r/?=
 =?iso-8859-1?Q?7dZ6PYeDQgfTm8vWjtjQlvtlC6pNl9a6nWJUkPOsWoEesAfoIK/aUEUYNW?=
 =?iso-8859-1?Q?ViUs+gME7ZZePoMVDpbrawMBL+NnKD0oQLfM21+8DpEKdjMrmVymQ1fOCo?=
 =?iso-8859-1?Q?mrWUnHTGHv714ERmuhGEyrgrf0XrK4HROht+cOwnWJ+SnAeJY5fY7dTTss?=
 =?iso-8859-1?Q?/+SvFe6IKOo/j9NAwrUjQ0qovkViqfmTuCbHolWM1LovdsHLER4xtcS+aC?=
 =?iso-8859-1?Q?BzoSKm+j3Iuv7dpaFHhSE/LNYvjw6LxW2OfeUde3nwUKleip51y30S0Ejh?=
 =?iso-8859-1?Q?zY/Z8pz4Yncvr83rwOqGYiedg03K2HvhjJIXq9ZlO6gVxZg5KiTCjKenL1?=
 =?iso-8859-1?Q?6GkRrqzDi8vjbziyoNvWH+oc2tWJ4nFP50IcUgLD9mGkAGO5Kxvjyhadx2?=
 =?iso-8859-1?Q?XQV3f3E7zew1MeEAQE3UQeQMn4HRf5vlJ/ss+FKjBN0Z2L7mHopxk7zUYs?=
 =?iso-8859-1?Q?yhV7UTPaEbfruxkfBH2DEEZX+g6cy7MPN+iwaeQTYYePzBEraPZkquK5K5?=
 =?iso-8859-1?Q?kceAlUfjg/14VBSXyYi0CcvG4l1zO+XXIfA8/tNQprPMba+FnL6nQCYESX?=
 =?iso-8859-1?Q?dqzCkTj5WvK3QYncn3XLxRCLlBXueLVNlJiMQozY16pNv0CSaHvD?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab8be02-4db9-4f62-9917-08df1410bb04
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 16:37:00.2345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3BYns3cSzbI65LfZ2EYPqpNK3CA4pqMpvQHdrvX0zlYF5Dq+EIpLd+GTjprVkkp7A17DWAZO/AVDZaenZ1/FUtoznsustHoyfaj1puN16Q+SQVkdsOuG03fYYQlE9UK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7364

On Wed, Sep 16, 2026 at 09:00:09AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] pm: positive return in ufs_s32n7_link_startup_notify() causes unclocked access
> - [Low] pm: missing pm_sleep_ptr() wrapper for .prepare and .complete callbacks
> --
>
> commit 774c9ff68bb8216bae4f82205ba8ce70b0364e59
> Author: Larisa Grigore <larisa.grigore@oss.nxp.com>
>
> scsi: ufs: Add NXP S32N79 UFS host controller driver
>
> This commit adds support for the UFS host controller on the NXP S32N79 SoC,
> built on the Synopsys DesignWare (DWC) UFS architecture. It implements
> S32N79-specific initialization sequences before link startup and applies
> post-link calibration for HS operation.
>
> > diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
> > new file mode 100644
> > index 0000000000000..4f9a001562024
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-nxp-s32n7.c
>
> [ ... ]
>
> > +static int ufs_s32n7_link_startup_notify(struct ufs_hba *hba,
> > +			     enum ufs_notify_change_status status)
> > +{
> > +	int err;
> > +
> > +	if (status == PRE_CHANGE) {
> > +		err = ufs_s32n7_link_startup_pre_change(hba);
> > +		if (err) {
> > +			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
> > +			return err;
> > +		}
> > +		return 0;
> > +	}
> > +
> > +	/* POST_CHANGE */
> > +	err = ufshcd_dwc_link_is_up(hba);
> > +	if (err) {
> > +		dev_err(hba->dev, "Link is not up.\n");
> > +		return err;
>
> [Severity: High]
> Could this propagate a positive return value on failure?
>
> When ufshcd_dwc_link_is_up() fails, it returns 1. If this positive value is
> returned here, it will propagate up through ufshcd_link_startup() and
> ufshcd_resume() to ufshcd_runtime_resume().
>
> The PM core's rpm_resume() will treat the positive return value as a failure,
> marking the device as RPM_SUSPENDED, but will propagate the positive 1
> back to callers of pm_runtime_get_sync().
>
> Since callers typically check for failure using a ret < 0 condition, they
> will assume the device successfully resumed and proceed to access unclocked
> or powered-off hardware registers. This can cause a system crash or bus hang.

look likes make sense, please check.

Frank

>
> > +	}
> > +
> > +	err = ufs_s32n7_link_startup_post_change(hba);
>
> [ ... ]
>
> > +static const struct dev_pm_ops ufs_s32n7_pm_ops = {
> > +	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
> > +	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
> > +	.prepare	= ufshcd_suspend_prepare,
> > +	.complete	= ufshcd_resume_complete,
>
> [Severity: Low]
> Should these sleep callbacks be wrapped with pm_sleep_ptr()?
>
> The power management subsystem guidelines require sleep callbacks like
> .prepare and .complete to be wrapped in pm_sleep_ptr() to prevent them
> from becoming dead code when CONFIG_PM_SLEEP is disabled.
>
> Assigning them unconditionally can cause minor memory bloat and potential
> compiler warnings due to unused symbols being retained.
>
> > +};
> > +
> > +static struct platform_driver ufs_s32n7_driver = {
>
> [ ... ]
>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20260916084411.941297-1-larisa.grigore@oss.nxp.com?part=7
