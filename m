Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022088.outbound.protection.outlook.com [52.101.53.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21E940DB56;
	Thu, 13 Aug 2026 14:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786632880; cv=fail; b=QvKu1zldlCAYyHgG6jLWq/OfK9OFhvhR6SBDZBL+18KYaXDFYnLrKsRQatyz8FhYCE8djR5QAtWgVp3WqpzhuQHF3XGDnDGawdkneSE7vgniN9cFf/5CKSIgluW01w/yl0MS6zLW6mHWkSJN7VK8c4qyzGyw72gSVOd2/ZfDmHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786632880; c=relaxed/simple;
	bh=UzKVxK2KBqSD+oNCoS1rLmdcYPNjDYwRvA2v3tO1gUY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JgHqNXBIC6299xljxsgUrS5CNW9NaJNPNv/uCD62NSqUHMO5gNzuoR1Kml7Fi3XqOkf0eDTBv8lTCxKR0F7aOzocuNymJMLTwXIjLkZiNKkHmwbv/+Xo7w/qGodEx/yNCsWNbxzvI3XsyMyPTH4ZCq4b5xY1DbwWK8vTNJ0Dc1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com; spf=pass smtp.mailfrom=chelsio.com; dkim=pass (1024-bit key) header.d=chelsio.com header.i=@chelsio.com header.b=CNnZ1kEQ; arc=fail smtp.client-ip=52.101.53.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chelsio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chelsio.com header.i=@chelsio.com header.b="CNnZ1kEQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKkp4oqCSv7lYTPg/Ot2o9sQg0Exrxi5E8++PX7UUmJdhItkKhk+8zBknwmgkY9QkTkh5ub1u50OBJ9giC47NV3sHVnEe91IbIPg3g42lv4ky2/ueUnXMAOlXsMgOlz13IYb1GV8km66nGtdBPpvQ77neF7WNtoxK9yArjqOeO/CHhmlup1ihK/Cfwj7dgRQP2s/44A6ravb6FMD3Hol/eEJQMHfCAVUB44SFRu+4lDMCccaAT7gdg+Im9nbal1ZaRNeqk3IPik46ShE5ly50EId/KSsHZIkZRn5DL9CfpgVL/NLGpMJq/TPmj11rcuua1J6zZ8nZnWQTDXtGvOeJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=np1esvjamXhz/NKHVcgvS57frNe749cBYIEvsWTnoRw=;
 b=Tgj9jUE8m0gobmq443tKudnQTDqrm69QiaNdiqFXKRoM1JHQOHx1lStqCRiX0mGkFKhREa1DLl6ZQ/rP76ee6Nkv0H/qL8+CSvJ66bk5X8jj+hVz00TFcjJ+6tcPY1yRIO++nDcUxqoDzjt7aW6zvJqXb90H+9FLMYTmHdesNnbqY3rCjeMSPnTG7Q0GnvIe9Ege+rYNuX9mfAs5fXLBuX9DOJCTs5Yq4BvQ0mhyBvj0D/912tcGmu0h0T3mlIQUDugR3FxcwqIDCFD9YsjqEAtGT11F1WxeqrG6OncLpxU+UUs96UkK9hoI3Z9z1W+tZaOH2gcGwJhbiiQqqw9c2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=chelsio.com; dmarc=pass action=none header.from=chelsio.com;
 dkim=pass header.d=chelsio.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chelsio.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=np1esvjamXhz/NKHVcgvS57frNe749cBYIEvsWTnoRw=;
 b=CNnZ1kEQbwcvQte6vVZNiM1oCXiJYS/lF9pzbdfX7rVoNPkxkWamhljPsfANxbFAr47ysDSaFYh0wcKIohXIpVf9o1cCaoSijxwr6VhxrfATCgcavCSgXjr18UgJcQzYA/kyQ24CURFswaFsWsCyFs+cJlzk4f/0ka0W7N6zVeM=
Received: from IA0PPF73BED5E32.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bd2) by CHAPR12MB999225.namprd12.prod.outlook.com
 (2603:10b6:610:2fe::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 13 Aug
 2026 14:54:33 +0000
Received: from IA0PPF73BED5E32.namprd12.prod.outlook.com
 ([fe80::92cf:1858:5560:593]) by IA0PPF73BED5E32.namprd12.prod.outlook.com
 ([fe80::92cf:1858:5560:593%7]) with mapi id 15.21.0292.019; Thu, 13 Aug 2026
 14:54:33 +0000
From: Varun Prakash <varun@chelsio.com>
To: Fan Wu <fanwu01@zju.edu.cn>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] scsi: cxgbi: fix retry_timer use-after-free on adapter
 detach
Thread-Topic: [PATCH] scsi: cxgbi: fix retry_timer use-after-free on adapter
 detach
Thread-Index: AQHdJHpo/u19QsG+/kOppl+nk1beV7acHQTQ
Date: Thu, 13 Aug 2026 14:54:33 +0000
Message-ID:
 <IA0PPF73BED5E32280057B3EBBA6889877DBCDB2@IA0PPF73BED5E32.namprd12.prod.outlook.com>
References: <20260805013209.418861-1-fanwu01@zju.edu.cn>
In-Reply-To: <20260805013209.418861-1-fanwu01@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-vipre-scanned: 0012206101B662001221AE
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=chelsio.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PPF73BED5E32:EE_|CHAPR12MB999225:EE_
x-ms-office365-filtering-correlation-id: 02a36fdf-061b-460f-af43-08def94ac93a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|38070700021|10067099003|22082099003|18002099003|56012099006;
x-microsoft-antispam-message-info:
 VBI5NbWjpv6Y8naj2utudvp8yGlQTV6lAda8M4f08x/D5WBQRcsnhYnG0+djDO+uAVNG8tqnSh0FhX44PV8dVKBrc/hsipf4zKKkOB3F/G4B7iId/AwL1fru+sFSKDJiP44jidUIDhm4R6+PN8eahq7EKETm6wsZ4eOcBnLGq+WHnt3SKWNqROMtjpRPqFP1Ud3NoPY6Y4bNND5YCw8wasedtfJyveWxEmZYcy2moh58Zyab7hTkpDMyjxEiEdV/7ZL7dGy5COL5gb3SJhh5QrN6widq/S5ItLwjbtBgyj02tA0EemtfzOhrKOwrVc6XLgSPa8mWQJPmdWi8ygG5LbKcc0FPHD3FctimkKW4WQj4p4kTpw+bAZh+6t6gh/hO9fPzy+wUZCC/xovorXKKJIfOhB3e57A0CfFdPniBXFHJEs6l9m6hhx7T9BqTZQVKYQncmiadaAJTAOtSwuQupG05JVYvXwGcJcJPyBX4yNtfpSjrtwIvMNrxsHppEpjkBMaqBOuvwrN311A0NtecztJz9UUEGkMyJ7fQYMbk8yuR5kilY7RUi+17BaXY91TKqWNDS9hmnNcgoYGUzi+brO4E7s04h6JPfdbPfTH1XbGVToTzlYGQvkd7t14eQUMVGPlpnVrB37pqiWNN9dVNCkC60UuIv1CRcXLdtR1rRJqLTD2PwLPNp8Jt71In4nheo6h9ndka6FDzxQInfPELs3ZSjTUTSzqHrdJJhL5YJZU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF73BED5E32.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(38070700021)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?j3duDhdembiPnlST/e/ftq4pzY8+IO7znz7qbCUb8Fa2ZwfyzqhmFyXDdo90?=
 =?us-ascii?Q?qS9bJwaFNwjPNUoXlQIEjBgrrCEY5dVMlflkqUnRrwk2qO6+mzwfNHinZzQj?=
 =?us-ascii?Q?k8p2IAs3rKeRHTKGCSdCgwh43uNS8WLAPP6BPp7FQ0Ryq6KzWGx+bJom9bFV?=
 =?us-ascii?Q?6bRpUIeReOce+PaJx8pR1tZbQUxbcEJoYaF9o3Hw2ETyifmzue5wSlHrBiJm?=
 =?us-ascii?Q?StcNagE81bYSDwp4gPwVdcsCTiFvLbRO1ibQ9mvkzUsgQXAImCWTlO5XHkNk?=
 =?us-ascii?Q?yIjEn5rhdlIj0Jl7Ctg6mWZqqoVhE8uh83Vcovbi/oqoWNYVhcfKQyLbdtp0?=
 =?us-ascii?Q?mNnEqv7FIwJpPTNdJuFZVKbGhihXdVg3evVJEXiNIENpxcw0kpYfMvHE6cI+?=
 =?us-ascii?Q?HoByj746acF1L9j63EjH8dT7oDgUfYh1M47TkkZUAAliyVREL2MXKLzD013/?=
 =?us-ascii?Q?Nwp6Cua8H3refhYYF8GI2uMN9ZjswW4b5ecOU0H4oeLVyZRajiB/FmWgcxOY?=
 =?us-ascii?Q?eNKcY1IBUhX/lHJ2eOuFUUGhy6dXEpRZ86EsOT3LWP73Y3yDuLF/c/3eoYiJ?=
 =?us-ascii?Q?/1W4ne/ikNciQKC3hLQob6X5y3jytuSRwjpDgc9jOtqA4vXsFoOo4ozyOOfu?=
 =?us-ascii?Q?/FgdOtWLLEeZ/XqtSh4vHWyChj8toZ2VUsWqzPvCpdAepsdrJ5u0VrMa/N+Y?=
 =?us-ascii?Q?zMeO5rb0hMSWv2hJTcOiUQmtYzJDwqUvucf7HCnZJTJ1xQwiUwwIyXl3JR19?=
 =?us-ascii?Q?gK2dfhDtgMMXkqyo/PArlVlkHPWhDWVryou7jYsSux67+tMb9hWDshjBqwAS?=
 =?us-ascii?Q?KbSojM5oN1msaaKSuIYQLPvG0UURWrF56PaohIhv6L39uO52fJYEvxp4usB6?=
 =?us-ascii?Q?/VvcTZ9CI5jP/US2kId4tI90sT39aW2oRB/LETwVtt6zqL3Lzerbt78hA+fq?=
 =?us-ascii?Q?hCaCdQPKxEyxOkR/pxjoe/q804eerc7IReTYZKuCBSD4ONFG1zg6Dj/OGtsd?=
 =?us-ascii?Q?V+QgoNlNZgJHj5XU4gU7ZXnvOT8e7VW0RhDQUf+ApW3YhLt3FbBUS5fSasmq?=
 =?us-ascii?Q?+42qoABjt/fiWSE1Ybi20/MB+s8gyOypkam3yC7TaL1sZ+2jxjmc3URlfaGi?=
 =?us-ascii?Q?rAmRlcCuc8rzzzFJCewRvAI828/UN2/iagmu2iCNjgmUo0+YMiEnDF7JKj0c?=
 =?us-ascii?Q?WE5yUZQUA0AgvZyCnHJXSiks1F1RkiYV4EKTNdeQU99APdBc0DbkVl5kptcZ?=
 =?us-ascii?Q?lCRKNcBKOcDP5r+hGNBIzDpTowElvgExFD5zi0M2GAW72FtYlQQDOgQ8FTYd?=
 =?us-ascii?Q?nvxRCfemVi//ckmm5vKLCqL4Svyf1XFkPXDv8Re/xVt5CDwibYBjEEtqwmC6?=
 =?us-ascii?Q?2YoOSk7Ly7LamEfPPeqHrOBXzLpp9CwhQwWl8iUj9lsEQASuDkUelpEwgCGo?=
 =?us-ascii?Q?2UDPjMxCholcXysmCLwAPW3Szo1+erEhTdiFoGpA1Xvepnx7QPk4PmJYIKCp?=
 =?us-ascii?Q?cwUVYQ47JpTQ4batnxpKMpDLQoKbpfjHS3ZAn9JiBefMBPu+5CLxP8mcz1U+?=
 =?us-ascii?Q?G5vjhps654x1RqoBMiFw5FNcrRK64iGDd6h96/4TwtlDtSuO7Qn9kJKCp4nF?=
 =?us-ascii?Q?/Gqzol3+NKOg5SJuCV34Rc+3AtT1vLUUQ56D651L5PDv2DUcln18hYzAdQ2v?=
 =?us-ascii?Q?FmsdfWDDQPMINpnXrnOnFXrg7j6rD4Vhgj1RBkQpvzuL/+LvbT6CLHdaxDPr?=
 =?us-ascii?Q?C3EhMFIQ+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: chelsio.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF73BED5E32.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a36fdf-061b-460f-af43-08def94ac93a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 14:54:33.2019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 065db76d-a7ae-4c60-b78a-501e8fc17095
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vbNbenij7s9gixxM0hejiOqczeMuLFzjoEvbRFRBXRPRGq7a0Jp28tnoUjZiQo55cYqE/QpsztR4YXbt13V9CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR12MB999225


>@@ -1001,6 +1001,15 @@ static void csk_act_open_retry_timer(struct timer_l=
ist *t)
>	cxgbi_sock_get(csk);
> 	spin_lock_bh(&csk->lock);
>
>+	if (cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN)) {
>+		spin_unlock_bh(&csk->lock);
>+		cxgbi_sock_put(csk);
>+		return;
>+	}
>+
>+	lldi =3D cxgbi_cdev_priv(csk->cdev);
>+	t4 =3D is_t4(lldi->adapter_type);
>+

With this patch csk->cdev will always be valid, so there is no need to
move these assignments here.

Thanks for the patch, please send v2 without lldi and t4 assignment change.
