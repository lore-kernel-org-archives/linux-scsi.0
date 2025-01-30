Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4512E4A35
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 20:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738268760; cv=fail; b=LhvulbRG5xJOsY/4jiR7DIdGWxYlXEECrTl/0JmBCqM+xXSm/L16lUaCFz52/G+R5ve05+U+SjroLlTp0ER+YqRvOQjVSdmuDVxt9bDxNKsvsgSnDZfD4dLOgvzHfUDhP8URSsD9PXIv6optQPc9b9D4B8CM6meDDYn7LIx9zlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738268760; c=relaxed/simple;
	bh=u03ynlepnqGXUuBFO15Mp7SbElJxtMLz6Qt5xvly918=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EwHD3WlQcxb6bwPreeH0DFkHPchzF+62XCanrrM8tAJbwOQaNLYITUQqSszXuOuzVplRUf5D/YU18Y0vJ7gNV/KbKFFMW6YMCStbFjm1wdLeCuUdStyl5mDoIBH41gjjc/dLAMAflCAobbRxbHQmc/NphJxJzeS+6w7WGamSV/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=OyQJ/Q6m; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="OyQJ/Q6m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6y44gCapnrGsPsRwr3DPfD4cIsALhjgxfm298O3dnmm3PGvjPjvSmZUDyWEaoYlNwsRsgfmVx+XERftrGJZnrkQJ5EOZEJq3ivR+s1Ug5oBmAK5IQp2kEopSvoaYhsXdwprjZWy1qXhGxCe7/19uNQkyVgq4jJm7jaK4kODu5LHYNu0feqpRzC23m2O9iR3fzFo5eeFHssQtX8q+hragkhUYWpvBAiUOdu4pAT4Nh8H2geXYBhsKuRH0W0JfK5P6ei4+O1UaQa9TjU98dGMXq69YoXiD1SGMWi5bAouRJfZnH3hlQWLiifERi+JRjYV8ugVSNvtlhfdtKziEFtPyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u03ynlepnqGXUuBFO15Mp7SbElJxtMLz6Qt5xvly918=;
 b=LZF3ghyON4qy9E9OtZLyrPvE1eakrNhTVKilkUE7V6UW0KoFquBbBuMYR7HT0LRyBhsU1H6gmqdgHNsBhLlSDo69BnZWf3i3vPT5lSmJUz8n7I4VBpSO9sA3YKAenEqOreCqXipSRYqzi+NZKJ+1FnLkqPUQEZ2GEfZguD9am6f+8hVkfYBLxuqbnoLA65G04cJUe5oynur110qkViGueXvURcig4xgbx4jLXc/DGJfwXhcLcJxW78K2vtJ3cjLgHCyHbxSN+zWmwXUfzLJfyy9UzsgzcHZcgaa+xZTEC6Utzz/1jX0t7VjjWKqzJpQnI5dmOyK6pU00iDYajNhmYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u03ynlepnqGXUuBFO15Mp7SbElJxtMLz6Qt5xvly918=;
 b=OyQJ/Q6mKzt4i/cg0seAmNAzGzrHwMCrVE4OMiqaNAx5xXfApLckrmYGcDFZmZckW8ZSozXLDCgPqpOQrlWRhCMjGK5EsrIDHbCuusoRWKkVBLpP0AudstomTmmX9395QfSUtZJxqNNNyMmdw1qkV9WPtbrqzezarTC4esmrE8UsbOWEFmnhiejwQkOpDpzR5BS1iuY8W5r5Kg/FD8ISpo8SCFW3RyClg94/O2CybjvuFgQI5dB8mGsxGvFljEXsuwPeHKLFySHOm3B734vTmEaHgCWbQYZ2jAOAgIb0XhqEgBRrZ2v3JHdpOeWT/yjr5zXZozvzK6dgQ+0I3Xob5Q==
Received: from PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8)
 by SA3PR11MB7554.namprd11.prod.outlook.com (2603:10b6:806:315::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Thu, 30 Jan
 2025 20:25:55 +0000
Received: from PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898]) by PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898%7]) with mapi id 15.20.8398.017; Thu, 30 Jan 2025
 20:25:55 +0000
From: <Sagar.Biradar@microchip.com>
To: <john.g.garry@oracle.com>, <jejb@linux.vnet.ibm.com>,
	<linux-scsi@vger.kernel.org>
CC: <thenzl@redhat.com>, <mpatalan@redhat.com>, <Scott.Benesh@microchip.com>,
	<Don.Brace@microchip.com>, <Tom.White@microchip.com>,
	<Abhinav.Kuchibhotla@microchip.com>
Subject: Re: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IRQ
 affinity
Thread-Topic: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IRQ
 affinity
Thread-Index: AQHbcQMKpgCjOokuCU2o8D6HU8kV77MvEymAgAC0vlM=
Date: Thu, 30 Jan 2025 20:25:55 +0000
Message-ID:
 <PH7PR11MB7570AD90146D81815C022A0FFAE92@PH7PR11MB7570.namprd11.prod.outlook.com>
References: <20250127213223.318751-1-sagar.biradar@microchip.com>
 <9a8fb5d4-3c36-478a-8376-7af267b7b6fe@oracle.com>
In-Reply-To: <9a8fb5d4-3c36-478a-8376-7af267b7b6fe@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7570:EE_|SA3PR11MB7554:EE_
x-ms-office365-filtering-correlation-id: cc7ed681-a37a-4bda-5ac7-08dd416c4c92
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7570.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Bd/6sD3JO4pBn7Mf6qys6WWGLFM+gj+9uftuiFnxzYCcdig6psIEp+DfV1?=
 =?iso-8859-1?Q?jwBcZGeANlAHQTGrq4VB9yAvfbDw2GknDKhFMKGmeqf7MdPq+dcziGVV/r?=
 =?iso-8859-1?Q?lEwPCn3tKVPWEjbErBDw1q3FsY23pq6VswjDSNrHsuXKSgBC8gMlMpYJyZ?=
 =?iso-8859-1?Q?LbP5NkSts/2pS8xBkYSp2+dFuBn27TVvZ1QaS16PEA/o8jxhORcACd6Vle?=
 =?iso-8859-1?Q?KBq+ML/2proDLPVzEr1Zuhn4yPWr5JYJ9M4oeAHTOyt3rgh9V2RgRqesb4?=
 =?iso-8859-1?Q?4v20HKW5Z1FNNz5J0DFgCdSPuOSJ50nT4SCNC5eZXxDM1lSmNNhPOoKr4/?=
 =?iso-8859-1?Q?uMZmJ9AUnuKzzyK/vHPz3rCTTjGw6peqQdjnxqp0wCC/OPpzwLGOG13fhk?=
 =?iso-8859-1?Q?8y/tqQiF7ICD1JyJDhrqOf0wZq3bpn1VJ03BOmlpnkjoR275V46zDgMdu7?=
 =?iso-8859-1?Q?4JxbjWTDhl6R57iNqwp1/RcXsAhOup++IVjrTZwBGGaAt9aMnJS78BpNBX?=
 =?iso-8859-1?Q?VUyjLLJdWeOKtrD3Gw+QI8TveRnBGmYvOvb9RLCzoRRY+NkbBfVju27HWc?=
 =?iso-8859-1?Q?A14VOVxaVgFCKBtrZXfVnrmloX46cg5A7FsuT8Vg8y7f7qpFJe9bey+Scg?=
 =?iso-8859-1?Q?HbCXpQaDoEZ6N2UU/u4u35QkugTUNAjKXeOGzvJMzPYDfl1Hc9LvYMLL6d?=
 =?iso-8859-1?Q?ZWXqZGEki6kz+aSHqNyUYnuMQxxoauCTh+OsDToZgZEzBf+4HVB8eenxnM?=
 =?iso-8859-1?Q?2JbL2GDSBOKOzgsd2+SpRQPmhx3Ok2zUL6Y9oySSB7avbaR3YGu1T2AxFI?=
 =?iso-8859-1?Q?KVt95pwQ70icd8EeJM5gV5h1+ndzJj74vuU8eR9+ZL3BiDU321MaeUOPDa?=
 =?iso-8859-1?Q?z8SkL23Vc8IPK3c7wDo1zTZvR9BA29wbAq8TCEaWvObJZ5xR4rJcAuLM3Z?=
 =?iso-8859-1?Q?m97eOxo3mbG4NcZfJ70IJFaEaivdJqVCmngOkzp1PvqcrD0+BNs3ZdOz2s?=
 =?iso-8859-1?Q?meaPfhvobzOBEvsaUMuedc3nBap0oIAtcWZSC59/hBEzWoHAEXl4u58CsD?=
 =?iso-8859-1?Q?RqKjVbmRqv0b+bfHErO7WYBONVybhZ+GGS0omw+j+oQJZdxzhYwL1tzVNR?=
 =?iso-8859-1?Q?jlmtvffG7jmcV+6EWaobLcVREOCAj9S+/RqiyZKsjH20m2syjseiJ0QoRu?=
 =?iso-8859-1?Q?gwstyxSAe5qIJOGn4PK+5m0WH/M3ENqvyox3DzZUuUGFD3fok/aZM3EBWv?=
 =?iso-8859-1?Q?2/Z+Psyf+zyY5QPQzrqdQFJ3R0cz+zYxCy26eMgtByz1ZQig7GGf5qYAnX?=
 =?iso-8859-1?Q?rIZXlawtcwLj4Qw+axz26ZZQ3Jkluz4LqpPEsVSwgCTlsewnKOBWzdnG6o?=
 =?iso-8859-1?Q?ABhm82Ge3ERnqEuEXXQILkA0GMuqGGITtpjjQ8XMuj1Wf7F5PgBYWnoU4o?=
 =?iso-8859-1?Q?dA4HXlEdvbELe9sBZfSulHbCNaxzB3tfC/75MW2RFbJwjxSA1694QF62Gn?=
 =?iso-8859-1?Q?xcWR59fLSfVbgEM2YiS0Z/?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?06Fak47P32Q1cMw0IU5YTvU7P+9Xx2zv8eCK9AZmYMUR38pqCLx9fXW2Rm?=
 =?iso-8859-1?Q?F0MzFQ0HAUiR3FmW8cnnJxB1RrfWHxAykZd3BWtpu9ZebtCbqOFM20DJoH?=
 =?iso-8859-1?Q?1NbvzsBGOAnm2FyyCI83xjlaL925Y69X7lyjzLjzjzjXmllhPv5lefs1jU?=
 =?iso-8859-1?Q?EkWzFHokYeqJEgY+NT1qbrHw4C53xfP5Htg9fds5fUbgsloJiwdZoBD+TQ?=
 =?iso-8859-1?Q?/f28SYHxlj0a4XIVWA+cdMTux0VSuLcKeJa4kmkKhw9ETdqvQRCd23rrMJ?=
 =?iso-8859-1?Q?TtY7TkYT2/p04czwdm/r1TpMfSz1xSorZYPfhjOTFmvC5mPmkt5wY9PS6S?=
 =?iso-8859-1?Q?9sZy5a6ipyhrfUW8oTErc6L53nX9zxCrtrI+J2Ypv9eqtJMwFyM59t9PGg?=
 =?iso-8859-1?Q?F3TmYHRweYED1eZHfodT5bWwWNIvJgiA1iYCtrvjQujsEf8bUEH6M1AYGT?=
 =?iso-8859-1?Q?nfX75z+Ew1qovqkVWAlzGdXyf1jsGApDzH/eX4+30Wl8Uj3jLrFJvXVEjO?=
 =?iso-8859-1?Q?/ZvAKUeXI5B15nU0YwxwQCnG/N3uhc0owtOvyct67OYbocAuHHH5vJHhIp?=
 =?iso-8859-1?Q?FQXvNsDEnDNyrL21LEKPSMEh4ZrbDt0aU8BFjZJi3h2N4zCyB1HHGxi+tU?=
 =?iso-8859-1?Q?iM2G+LMIhjQEdCu5WGpoZRMr/RmrWqgjT5C+cHON3UuT2Kba/6VbgTIUPB?=
 =?iso-8859-1?Q?czngcoSVkVOzVpvVwJCLOhS7LFta/72Dz6W+1R3d8tEnlxKTIhM8CFlnej?=
 =?iso-8859-1?Q?Fwog7LvlJx9hudPTX2SWtqAS1+nf1JWCr3htUU1oD+3NALqd6shNySzdgH?=
 =?iso-8859-1?Q?HGEMXg+C2FCVi0ZtsFD1dtdWH0qvac6lfuSAPS/yUwlG+MenHyrfP+FdlZ?=
 =?iso-8859-1?Q?IiuLjRIuUQkFW5EOZBNt++T3SjImgKMacLOQ+D2xJ6+6pVuQw155itzMHc?=
 =?iso-8859-1?Q?npOJUMS9emIXZJCeyVYeq5oo0QG1V+zNk58P0gN/nMZWGfOj9xiFmE6kGv?=
 =?iso-8859-1?Q?l2fziOTp5lIRYhslZROnnPa5lIw1tAg3h8rrz/2VyEyNAhH7VwN/lKxRz1?=
 =?iso-8859-1?Q?W1fg2IrTUmpH/zNMHWQusRbf7b7LNuXehsx7PgDMbKsr5LtWjjG7PjtcgZ?=
 =?iso-8859-1?Q?qdSGIH4PslNbiqHCJ5qXobWk2hKGEtHuJXUj1f2fxMEWiE1GHoDYZCG67O?=
 =?iso-8859-1?Q?Dad2H4qC8fQAX+iWMLZmrxtimcIBg4LQJ0PsyzsqwwKFdmQu+jiR80Mv1B?=
 =?iso-8859-1?Q?DtVMx+LjtUoJtqZxaK9bnxR5lbXx73fRwj7CXREwODLIDM//Z9KuF84RHz?=
 =?iso-8859-1?Q?v8oYPX2WDYYnDcDagSziTYWCvzxPhMiRqjQgAOQwlKjTRH9yA+IdEU6fEs?=
 =?iso-8859-1?Q?dRS0sSgPSokx0+SHqJxUcy2aYQsqr4aCf/91CylhlxFHImBM4K7rH9/L9r?=
 =?iso-8859-1?Q?XFYC5qWDKB1I8681jCcS+HkAEAgm+Ay715T7WwH48v3uzh8A0VtInEac/E?=
 =?iso-8859-1?Q?yQegeHgwyFOkihWbgY8KfxhLMXnYOqeGKCshwjGxFuJTn6jsKhUMIwVBHX?=
 =?iso-8859-1?Q?ZzQmCMgnc5CMDezbCjFziimRkFdWygnI2DqB35n8d2mGLFjdo2WWu8P8Gk?=
 =?iso-8859-1?Q?BnCKcn3R/s9IiMGKYTSh2JB3gUHBTdWnCB?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7570.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7ed681-a37a-4bda-5ac7-08dd416c4c92
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2025 20:25:55.2817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8YBWkP4qOw6GFtoousdCkDMCkUAFKGmH+g56jwsj86O2447far70WCI+yjQrS3fDOofE2kUNtruqiVYYqKC1daqqfIBxQ72nZ9e1PAC8Yl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7554

=0A=
=0A=
=0A=
=0A=
=0A=
________________________________________=0A=
From:=A0John Garry=0A=
Sent:=A0Thursday, January 30, 2025 1:37 AM=0A=
To:=A0Sagar Biradar - C34249; jejb@linux.vnet.ibm.com; linux-scsi@vger.kern=
el.org=0A=
Cc:=A0Tomas Henzl; Marco Patalano; Scott Benesh - C33703; Don Brace - C3370=
6; Tom White - C33503; Abhinav Kuchibhotla - C70322=0A=
Subject:=A0Re: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IR=
Q affinity=0A=
=0A=
=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
=0A=
=0A=
On 27/01/2025 21:32, Sagar Biradar wrote:=0A=
=0A=
> Fixes: "(c5becf57dd56 Revert "scsi: aacraid: Reply queue mapping to CPUs=
=0A=
=0A=
> based on IRQ affinity)"=0A=
=0A=
=0A=
=0A=
Hmmm... so is c5becf57dd56 broken?=0A=
Revert did not break the code.=0A=
I have corrected the description and submitted a v2 today.=0A=
=0A=
=0A=
> Original patch: "(9dc704dcc09e scsi: aacraid: Reply queue mapping to=0A=
=0A=
> CPUs based on IRQ affinity)"=0A=
=0A=
>=0A=
=0A=
> Fix a rare I/O hang that arises because of an MSIx vector not having a=0A=
=0A=
> mapped online CPU upon receiving completion.=0A=
=0A=
=0A=
=0A=
Is this actually being fixed here (along with now exposing the HW queues=0A=
=0A=
by setting shost->nr_hw_queues again)?=0A=
A heartfelt thank you for taking your time out to review the code and provi=
ding your feedback.=0A=
I appreciate and value your inputs.=0A=
=0A=
Yes, that is a part of the fix - but the entire fix involves not only expos=
ing the hardware queues,=0A=
but also ensuring that the queue assignment aligns with the hardware config=
uration.=0A=
i.e. In this patch, aac_probe_one( ) correctly exposes the hardware queues =
by setting=0A=
shost->nr_hw_queues based on the number of MSIX vectors (aac->max_msix),=0A=
which indicate the hw_queues available(the need of multi-queue).=0A=
=0A=
=0A=
=0A=
>=0A=
=0A=
> A new modparam "aac_cpu_offline_feature" to control CPU offlining.=0A=
=0A=
> By default, it's disabled (0), but can be enabled during driver load=0A=
=0A=
> with:=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 insmod ./aacraid.ko aac_cpu_offline_feature=3D1=0A=
=0A=
> Enabling this feature allows CPU offlining=0A=
=0A=
> but may cause some IO=0A=
=0A=
> performance drop. It is recommended to enable it during driver load=0A=
=0A=
> as the relevant changes are part of the initialization routine.=0A=
=0A=
>=0A=
=0A=
> SCSI cmds use the mq_map to get the vector_no via blk_mq_unique_tag()=0A=
=0A=
> and blk_mq_unique_tag_to_hwq() - which are setup during the blk_mq init.=
=0A=
=0A=
> For reserved cmds, or the ones before the blk_mq init, use the vector_no=
=0A=
=0A=
> 0, which is the norm since don't yet have a proper mapping to the queues.=
=0A=
=0A=
>=0A=
=0A=
> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>=0A=
=0A=
> Reviewed-by: John Meneghini <jmeneghi@redhat.com>=0A=
=0A=
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>=0A=
=0A=
> Tested-by: Marco Patalano <mpatalan@redhat.com>=0A=
=0A=
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>=0A=
=0A=
> ---=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/aachba.c=A0 |=A0 6 ++++++=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/aacraid.h |=A0 2 ++=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/commsup.c | 10 +++++++++-=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/linit.c=A0=A0 | 16 ++++++++++++++++=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/src.c=A0=A0=A0=A0 | 28 +++++++++++++++++++++++=
+++--=0A=
=0A=
>=A0=A0 5 files changed, 59 insertions(+), 3 deletions(-)=0A=
=0A=
>=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.=
c=0A=
=0A=
> index abf6a82b74af..f325e79a1a01 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/aachba.c=0A=
=0A=
> +++ b/drivers/scsi/aacraid/aachba.c=0A=
=0A=
> @@ -328,6 +328,12 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arr=
ays:\n"=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 "\t1 - Array Meta Data Signature (default)\n"=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 "\t2 - Adapter Serial Number");=0A=
=0A=
>=0A=
=0A=
> +int aac_cpu_offline_feature;=0A=
=0A=
> +module_param_named(aac_cpu_offline_feature, aac_cpu_offline_feature, int=
, 0644);=0A=
=0A=
> +MODULE_PARM_DESC(aac_cpu_offline_feature,=0A=
=0A=
> +=A0=A0=A0=A0 "This enables CPU offline feature and may result in IO perf=
ormance drop in some cases:\n"=0A=
=0A=
> +=A0=A0=A0=A0 "\t0 - Disable (default)\n"=0A=
=0A=
> +=A0=A0=A0=A0 "\t1 - Enable");=0A=
=0A=
>=0A=
=0A=
>=A0=A0 static inline int aac_valid_context(struct scsi_cmnd *scsicmd,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct fib *fibptr) {=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacrai=
d.h=0A=
=0A=
> index 8c384c25dca1..dba7ffc6d543 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/aacraid.h=0A=
=0A=
> +++ b/drivers/scsi/aacraid/aacraid.h=0A=
=0A=
> @@ -1673,6 +1673,7 @@ struct aac_dev=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 handle_pci_error;=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 bool=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 init_reset;=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 soft_reset_support;=0A=
=0A=
> +=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 use_map_queue;=0A=
=0A=
>=A0=A0 };=0A=
=0A=
>=0A=
=0A=
>=A0=A0 #define aac_adapter_interrupt(dev) \=0A=
=0A=
> @@ -2777,4 +2778,5 @@ extern int update_interval;=0A=
=0A=
>=A0=A0 extern int check_interval;=0A=
=0A=
>=A0=A0 extern int aac_check_reset;=0A=
=0A=
>=A0=A0 extern int aac_fib_dump;=0A=
=0A=
> +extern int aac_cpu_offline_feature;=0A=
=0A=
>=A0=A0 #endif=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsu=
p.c=0A=
=0A=
> index ffef61c4aa01..5e12899823ac 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/commsup.c=0A=
=0A=
> +++ b/drivers/scsi/aacraid/commsup.c=0A=
=0A=
> @@ -223,8 +223,16 @@ int aac_fib_setup(struct aac_dev * dev)=0A=
=0A=
>=A0=A0 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd=
 *scmd)=0A=
=0A=
>=A0=A0 {=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 struct fib *fibptr;=0A=
=0A=
> +=A0=A0=A0=A0 u32 blk_tag;=0A=
=0A=
> +=A0=A0=A0=A0 int i;=0A=
=0A=
> +=0A=
=0A=
> +=A0=A0=A0=A0 if (aac_cpu_offline_feature =3D=3D 1) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 blk_tag =3D blk_mq_unique_tag(scsi_=
cmd_to_rq(scmd));=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i =3D blk_mq_unique_tag_to_tag(blk_=
tag);=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fibptr =3D &dev->fibs[i];=0A=
=0A=
> +=A0=A0=A0=A0 } else=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fibptr =3D &dev->fibs[scsi_cmd_to_r=
q(scmd)->tag];=0A=
=0A=
>=0A=
=0A=
> -=A0=A0=A0=A0 fibptr =3D &dev->fibs[scsi_cmd_to_rq(scmd)->tag];=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 /*=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 Null out fields that depend on bein=
g zero at the start of=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 each I/O=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c=
=0A=
=0A=
> index 68f4dbcfff49..56c5ce10555a 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/linit.c=0A=
=0A=
> +++ b/drivers/scsi/aacraid/linit.c=0A=
=0A=
> @@ -504,6 +504,15 @@ static int aac_slave_configure(struct scsi_device *s=
dev)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 return 0;=0A=
=0A=
>=A0=A0 }=0A=
=0A=
>=0A=
=0A=
> +static void aac_map_queues(struct Scsi_Host *shost)=0A=
=0A=
> +{=0A=
=0A=
> +=A0=A0=A0=A0 struct aac_dev *aac =3D (struct aac_dev *)shost->hostdata;=
=0A=
=0A=
> +=0A=
=0A=
> +=A0=A0=A0=A0 blk_mq_map_hw_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT]=
,=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &aac->pdev->dev, 0);=0A=
=0A=
> +=A0=A0=A0=A0 aac->use_map_queue =3D true;=0A=
=0A=
> +}=0A=
=0A=
> +=0A=
=0A=
>=A0=A0 /**=0A=
=0A=
>=A0=A0=A0 *=A0 aac_change_queue_depth=A0=A0=A0=A0=A0=A0=A0=A0=A0 -=A0=A0=
=A0=A0=A0=A0 alter queue depths=0A=
=0A=
>=A0=A0=A0 *=A0 @sdev:=A0 SCSI device we are considering=0A=
=0A=
> @@ -1488,6 +1497,7 @@ static const struct scsi_host_template aac_driver_t=
emplate =3D {=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .bios_param=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 =3D aac_biosparm,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .shost_groups=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =3D aac_host_groups,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .slave_configure=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D aac_slave_configure,=0A=
=0A=
> +=A0=A0=A0=A0 .map_queues=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =3D aac_map_queues,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .change_queue_depth=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 =3D aac_change_queue_depth,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .sdev_groups=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =3D aac_dev_groups,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .eh_abort_handler=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D aac_eh_abort,=0A=
=0A=
> @@ -1775,6 +1785,11 @@ static int aac_probe_one(struct pci_dev *pdev, con=
st struct pci_device_id *id)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 shost->max_lun =3D AAC_MAX_LUN;=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 pci_set_drvdata(pdev, shost);=0A=
=0A=
> +=A0=A0=A0=A0 if (aac_cpu_offline_feature =3D=3D 1) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 shost->nr_hw_queues =3D aac->max_ms=
ix;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 shost->can_queue=A0=A0=A0 =3D aac->=
vector_cap;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 shost->host_tagset =3D 1;=0A=
=0A=
> +=A0=A0=A0=A0 }=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 error =3D scsi_add_host(shost, &pdev->dev);=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 if (error)=0A=
=0A=
> @@ -1906,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 struct aac_dev *aac =3D (struct aac_dev *)shost->hostda=
ta;=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 aac_cancel_rescan_worker(aac);=0A=
=0A=
> +=A0=A0=A0=A0 aac->use_map_queue =3D false;=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 scsi_remove_host(shost);=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 __aac_shutdown(aac);=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c=0A=
=0A=
> index 28115ed637e8..befc32353b84 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/src.c=0A=
=0A=
> +++ b/drivers/scsi/aacraid/src.c=0A=
=0A=
> @@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)=
=0A=
=0A=
>=A0=A0 #endif=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 u16 vector_no;=0A=
=0A=
> +=A0=A0=A0=A0 struct scsi_cmnd *scmd;=0A=
=0A=
> +=A0=A0=A0=A0 u32 blk_tag;=0A=
=0A=
> +=A0=A0=A0=A0 struct Scsi_Host *shost =3D dev->scsi_host_ptr;=0A=
=0A=
> +=A0=A0=A0=A0 struct blk_mq_queue_map *qmap;=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 atomic_inc(&q->numpending);=0A=
=0A=
>=0A=
=0A=
> @@ -505,8 +509,28 @@ static int aac_src_deliver_message(struct fib *fib)=
=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((dev->comm_interface =3D=3D=
 AAC_COMM_MESSAGE_TYPE3)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 && dev-=
>sa_firmware)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_=
no =3D aac_get_vector(dev);=0A=
=0A=
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=0A=
=0A=
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_no =
=3D fib->vector_no;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (aac_cpu=
_offline_feature =3D=3D 1) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 if (!fib->vector_no || !fib->callback_data) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (shost && dev->use_map_queue) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 qmap =3D &shos=
t->tag_set.map[HCTX_TYPE_DEFAULT];=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_no =3D =
qmap->mq_map[raw_smp_processor_id()];=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 We hardcode the ve=
ctor_no for=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 reserved commands =
as a valid shost is=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 absent during the =
init=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_no =3D =
0;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 } else {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scmd =3D (struct scsi_cmnd *)fib->call=
back_data;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 blk_tag =3D blk_mq_unique_tag(scsi_cmd=
_to_rq(scmd));=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_no =3D blk_mq_unique_tag_to_hwq=
(blk_tag);=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 }=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 vector_no =3D fib->vector_no;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (native_hba) {=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (fib=
->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {=0A=
=0A=
=0A=
=0A=
