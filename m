Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F0B1D5170;
	Sat, 14 Mar 2026 01:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773451104; cv=fail; b=e6OGL9GemCuxi4rYnzDMiMGssjpksouiqAzr4r1dvYt2jO4z4TgsRcy7hdbH4Y0Yej5vkOyY7pK8xiCvEkn/wQmGUBVNVECV9tYydIT4OtvqSA+KNa2Xy5ERJYBCwHZ5F6uL9qAS7OC0yCNKnO/7ZzpiYIeCl2L/Ro+jJEE21lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773451104; c=relaxed/simple;
	bh=xXtcySQlcxiRO+LYpSbHkgQ/PIJZuKpDV90H+6HPBVo=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=g9FVA0bX5puan/+gZScitqEbFPFOtQ/N2batAxHvCzVGuSn9q6sPi1GH26U50JerrYCzoupR54mP7+bGwoyp7GFbFsPRsARchHPCXiehNtUt5STdb0Evj/a0h+lpfpx9D1RsH1UcY8nLCP9DcVFcqhgH/WBCdVY8U6vu93u+kPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synopsys.com; spf=pass smtp.mailfrom=synopsys.com; dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=hazQtI2p; dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=abK1zRMG; dkim=fail (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b=eukmZrVC reason="signature verification failed"; arc=fail smtp.client-ip=148.163.158.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synopsys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="hazQtI2p";
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="abK1zRMG";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="eukmZrVC"
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
	by mx0b-00230701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62E0oHrO486010;
	Fri, 13 Mar 2026 18:17:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfptdkimsnps; bh=vljmr2Y+rJJwvrpcGdJ
	JRkbBElTbGCrI8+Yv608S9j8=; b=hazQtI2pRfrlnlkkEN9f+XdnQOev9cG3ALP
	tChb5iCHK3ZZ2JpbNr9EiefLXEmLKh7DcMdWM4+nbx2TYIZKXSGLSPnY3kEI98vK
	/O7mAz4x7k7N8+QyPtSfNZZd7nUSnx4OYhs1KAujYzBfRmdFlWeLdH1XiwJ+jpIT
	BFdLpYzYA/iSF5xfym1v57GBknRDRBIojKrX4seB6C9hAQHTE7OZYzPXR7gd/a6j
	Tc6zYz0/1eUQGiWUMOkTCWBcBVeu2C17bcLiNYe2nOKHyAFW9LVhVwQDSYAF1V5+
	Qb1TsCVgJo/RQRJvMjtLs1I/fvj3PUM0sLND42C9SYD1MM4SAtw==
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
	by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 4cvg2h5nkf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 18:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
	t=1773451068; bh=xXtcySQlcxiRO+LYpSbHkgQ/PIJZuKpDV90H+6HPBVo=;
	h=From:To:CC:Subject:Date:From;
	b=abK1zRMG+iq3b21Y/ciGmtdnFNW4DOnY/KNGO40D0KLMipfuRph1EIkd70/pWuRmz
	 57b21hxajFj2qEXwNZGgvrOXkx7RVGr9/L2Q7xqWLAsUuga40QdYtnhmWk0kCSk9ob
	 cwoGg5SlJ1SH9fw9Yeu6vPnAhxufIgxr0bfNlmRjMQFPmKJrVV2lF5Z3C8Notcq4TW
	 aVk91mcRC2GBM09CNNMAT21vy6Ag2P18aJyXVpufTEFqBBLDEFn0rj7BuHt8kfC4ju
	 yYoGRyHw9rcN64HJgOcxwRLTahGdYurxKLUSBFKZwK5nLzVbyVll5lKAucXoEG9HxH
	 DL+CAkRv5hmvw==
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits)
	 client-signature RSA-PSS (2048 bits))
	(Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
	by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E092A40357;
	Sat, 14 Mar 2026 01:17:47 +0000 (UTC)
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "o365relay-in.synopsys.com", Issuer "Sectigo Public Server Authentication CA OV R36" (not verified))
	by mailhost.synopsys.com (Postfix) with ESMTPS id 9FCFFA00D3;
	Sat, 14 Mar 2026 01:17:46 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
	dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=eukmZrVC;
	dkim-atps=neutral
Received: from CH4PR07CU001.outbound.protection.outlook.com (mail-ch4pr07cu00104.outbound.protection.outlook.com [40.93.20.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
	by o365relay-in.synopsys.com (Postfix) with ESMTPS id 613AD402B2;
	Sat, 14 Mar 2026 01:17:43 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H3HEagsAMuYPTa1eNmoK+m09X1EM27XeE3aNKjej7SZu512Rd5raFaanrMTc0z9cJY49E3vnang/bg1XVBQrVtBniY1X+utN69JA5RrEBpTTNYJ8xxCBPakRxzicA37XizMMe4v0OrfwKY7TBzjpNhWGQwSxU4CiSPTRLH6X5Alet78UZAxosY98sX9jvxJrIFXwA1tNboG1X/1i1yiMf1ODHSnH2SCGK60/k9urvHyRyM//+rZ+FHVO/XpEbV7kijovAQMpS0PV4Kjqtzh+KeMISAduNggnKFSNTXu8nHQZJ3QrcDy6EBK+z1y6CgcA5a8CppKW6YUeL/oQpm8S1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vljmr2Y+rJJwvrpcGdJJRkbBElTbGCrI8+Yv608S9j8=;
 b=uPETU6mc54g6ZOLgM5HT6pA1P1qcwzUp6YNqKCrOmsfoeJ4wEbWIPT8V+m/s3FaCGOZhF9dVEQR8VbW4zn6P8wWzpO43Q51MTZauOYQoyz1vHyrNMoHcZpYOxzdsZsrQcp3WMmmQriGALqTlFK1vnwGDQR6eok9WS0ZKtG+Qx+KlVOKE0GGE5CrN8t5Gvr4sHjRub9eYbgx0Hez9LbLlRIP5RUddZAubVHkJ0e70Z7mm31JO/Ayji1bbOdbHK4/a8SA3uBhO7aYO0MMbNdvymvIt3uiE0CEaxapRjXQUhlGCCYWflHKcBJFoXJ22tDMTWqVYbj7edVJO9+JHGnqUsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vljmr2Y+rJJwvrpcGdJJRkbBElTbGCrI8+Yv608S9j8=;
 b=eukmZrVCTGsierbHeFLa/ELngYji897N2GH6zL2MO3c33WYJLK+rc5r16u+CNFGj9/jHnKpRi+eCIItWzg37kVQZLlSw/RBG9wMh6zQVAjhMufaFGfYEvWLD7K2cxLXlTPZ2T2Su56L96VyHljad3a6w8mUcM9yTGoMXj/FktnI=
Received: from LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16)
 by CH2PR12MB9520.namprd12.prod.outlook.com (2603:10b6:610:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Sat, 14 Mar
 2026 01:17:40 +0000
Received: from LV2PR12MB5990.namprd12.prod.outlook.com
 ([fe80::7b72:b921:b9bd:4899]) by LV2PR12MB5990.namprd12.prod.outlook.com
 ([fe80::7b72:b921:b9bd:4899%6]) with mapi id 15.20.9723.008; Sat, 14 Mar 2026
 01:17:40 +0000
X-SNPS-Relay: synopsys.com
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To: Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Kanchan Joshi
	<joshi.k@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe
	<axboe@kernel.dk>
CC: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] target/file: Use kzalloc_flex for aio_cmd
Thread-Topic: [PATCH] target/file: Use kzalloc_flex for aio_cmd
Thread-Index: AQHcs1BZwUh5WhAsA0+RZYfARu7Yaw==
Date: Sat, 14 Mar 2026 01:17:40 +0000
Message-ID:
 <f1a2f81c62f043e31f80bb92d5f29893400c8ee2.1773450782.git.Thinh.Nguyen@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR12MB5990:EE_|CH2PR12MB9520:EE_
x-ms-office365-filtering-correlation-id: cdd42861-8c92-4dbd-4542-08de81677c6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 G0yqaf5wHxlmDTrGT4p4iAT5TxGmZEb0TGaq/tUMXsL3rPOuj0/nh0vJhzL+Dv21CsuLYSBqWGvV2ptaZxeeZmIkA/NylQz4OUD8MI+UFX3NLlwC1c3zEQ8Gtxijw57P0g7OqcUwxxEBD/ZN7tYePnRmYFMwqxBFs0TVGXUShYEpN1LXxP+GX2gZ1PZHVDNQZ0e6Njmy4DPkDjUIwgdBkCxSBcshYRzCqCSUOiYvT+32277jWFspDGm3JRAZQPolOW2xZHwqZXsOZa8rTiVh+K6bFxaogf4TcvoYYnWTRNwjvyU5U/o1woPPn+lp6YYO3awQzM2k0nDQfAm6fX/IKrr+BgYtmC2Xl8eQHtxGNxDmN+ybtN8MZiEdRgZYMUYD4zSd3/YXX73GpiYmR5MwdT0dyXWaX9N7U9BYddTFlFI9iqhMzWdkg2XAgIimNiYUyJE2iBZNBY9p43sedNO7wR0niHwQnB1arF3S6ZKO4eKRnKqfFMugW6JzBa97uZGiIXJwbLR4rmRMxSYKeu4rp6SoM9U/ibAUQRQ5QynqTf0nZ4+ZkRk+ZpQG+dECctJCdAprWxKQrvHEWysdbHTBHYOWliXmo5PdOpmJgSz31zL2GlpA+5WhDrrm29zwUV755qgv6o+u+eAyztFXE3BEdMDfLguzwWxGCHFdSSTINh7o8US/ZmyZCTWkQAqd2k7KxxOFlYYiDElPNiiynkvcguDdOhVpECE/Kp+JQTyEkqHpUaSDNJiJ/w3vlD7Z1/bkb4dEqsjhbLxfKmjJvfgtSnNuOP4LwGd8UUpfTtQcmxw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?btcKFBLVSy41xIVhJ9KYonHVDsHbx5LSLNceqKS4Cw5N8KUirwJt/ZLWQQ?=
 =?iso-8859-1?Q?wf08CgNmr08rnilOuJdMDnBFNxVLf6EcPtgVNf3lWh6JiQ3Eg/OcigZgx8?=
 =?iso-8859-1?Q?BI0MskKoFNS1izVDZ716ZdqLlaGUfoPHtegsZsaBoOQKcpg1z+yniGgpE2?=
 =?iso-8859-1?Q?kFcDjEFksJ6CWxlKEjEYsbBv2pJ69Zl0YzqR70QGAgyK1C66KqOxCo31/2?=
 =?iso-8859-1?Q?XI4HTmIeQBfU8mW6mhPTI7qvFVN7BwGbfO03aYQGnPIe/afdI9kI7MgbER?=
 =?iso-8859-1?Q?ePyGeYBZdwQOjaYjmy3mG8o1G24lhFgyff6llir8KgbDuRYi++7Dpu8KFZ?=
 =?iso-8859-1?Q?D754T8qJ18VlfVckpbJobvuHBP/OT4cacJnJDKosnEWHyjv1MBYYT+wbeg?=
 =?iso-8859-1?Q?z/v1tijMh0XAD4+bA3jWyjohpeBGF4SvJ4FQ9BAmOfqnQFERzWVnAmsxMF?=
 =?iso-8859-1?Q?+hY7dTUoxegMcCFxSzdX8zRETxTe9bozoB1SxG/k7ehZOj5cjvyyCxWL1/?=
 =?iso-8859-1?Q?bbBEVKJ4YB5FHZkBsgO+OEeq7t/UniGzSBS/iVdkqyQd7n4hsiDhhBvy+n?=
 =?iso-8859-1?Q?pVhaHWcKRfH5pkaXyr2uWY/lsEswoEPVaR5Tf3T32XUmSxuW9BY87RyyIm?=
 =?iso-8859-1?Q?+WQokGyLX+rNVpXLgCvUPdlgxwMkOo0/GCHZskXl8qpvTRHXTZrXDgsLmb?=
 =?iso-8859-1?Q?v/mWvH/eIIdyP3RBsTgjiH8c9V+ZLSk+tWCPf6Uj05vGAmMaan1auVsUZN?=
 =?iso-8859-1?Q?eCFFeduxadjNS054HjPZY7HhzLqleYcl6YO+NYEPDXNk1utZPieH7nPvSP?=
 =?iso-8859-1?Q?gDj2rEkahggMFELM0Aq0Ew5eLjP6l228qBnWoQtGCGUDkcHRMaoDNqCjEg?=
 =?iso-8859-1?Q?XxnTU98TaXDisjkJ50QaSPp5gvL/8ieDA+wBRp0FrKQKSP/zhfYMczJlZn?=
 =?iso-8859-1?Q?og6HmjGO4LrM4byEekQs3VMUpdgGFuUm5PsnujrX2L7DAHqxIpvPMbhtxj?=
 =?iso-8859-1?Q?o1NEhNRgJyWboTrN0TIaULGOEIXw4EXigqWGzpKm+8QoUekrX96l/ef3LX?=
 =?iso-8859-1?Q?ZA5qpLeKWuDwtHBm9Kjv095SlQJvXhMEcl6b08JFi/0+oXz0x9HVWkMnZX?=
 =?iso-8859-1?Q?zVOO3MjxkVeXKEBZNsBZIi4rOrutUYr/dG4rwaDutvGLE69H++pzaINv2A?=
 =?iso-8859-1?Q?Q8RAqEY4+5zcXPWWWFMb9CRFhea1zY4ja+k7MUrmOEqbnocgzjz2o4ccqV?=
 =?iso-8859-1?Q?4FhBf0wNOEWdHhu6abHiGLxMd8lkvh853YEAWsCWHa5UP+DSLPu6O2zXf/?=
 =?iso-8859-1?Q?J+MdNeduRiQJzj1LUVB6sO6Epi0DmaN94fU5oPOLxhMvnJ1RJOLdGSetHm?=
 =?iso-8859-1?Q?uIIrsIhoEWk0yPGK8xMJzV00TZlv32tO4lYMhdQYKwTuih0KHgzUvRhm2R?=
 =?iso-8859-1?Q?hSsnA9h/62YyMhQ3mQvzFVjRqmsVDn+P72dc7I1RmRl1DVX6X84xH+RZXv?=
 =?iso-8859-1?Q?audI+e5wNbicrTmv11FwxqdjxQmQ/5vVRVD+TjJKe0KCwD5YXeXICuPkRk?=
 =?iso-8859-1?Q?MlakwX16jw2a+3ElSC8QyGtPunJ6rV+GzsIZOFLZddZIb/3zC5OcNIUKvg?=
 =?iso-8859-1?Q?MlIcr3UyQwMi9uymcwf2eG0qbX5opZp8WgrpWrjmw6+KDnceZgo4dduM5I?=
 =?iso-8859-1?Q?K3J3gjSMYdKtVH9e+hOaz5IjgbLLjW93VmDrC3AvGOBRcYOwpLnK/fkycA?=
 =?iso-8859-1?Q?C8EvYWeSUdCkcDjNYAO/wY7G7C/Rs7R7aPQ04baTQ2oXofFkxIxR1kMUQm?=
 =?iso-8859-1?Q?UGWweoA7Uw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	wAwcmjLGv66cR058UfKoXsGrvYat+6pgmHwDbaU2b+EvDo+n2yocJ/MEZwmvqwkuEMW/PuWKlV2GUwXlBNZFtBKfeOvlvNXv9VeM0Zio8NMFRB7q8tp8xnZhklLA3BmorJG0H8Rr4dnXTMXoVsTRz66INed3PbIvqAk1FeTu9X1ENHQ57GUEs5KbDDn61r+j2IuhpDS9hv89YgNaFx8IiO130MviDLWKh2NDvXgZ6FSmJSlL05kbISNbDH5arPEwGd+sqrsVboLlGBwCZdPvKgPTp6vQK7p5e4yVD1q3c3DQspPmLD3sNfm9JUeygeLVH0FrCKVgwzTw6adwMtOR8w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wo1W9g9JTLvbeFgRWQP7l/fwDcz01msmB5HWbDWlw7Ge+T4ATzqFM3ZsIDDZ0NWJEENDm7kCJwnjZN+WKbxv7piLBvFfMc67WhyUeHvn+Ig4IiQMz9ig3vs0AEcLyUqYjQohLkVp4Q3RV7M0Ye/Ygg+h3QME6Tqn9udjQSpZOJmSQ7QL1mRcq3AiRIna1AY+9Sqg/fGDRU2ZVXEn+vTq0JfiLG7S635TOPRrzP3CbZS3dic1r7IUuqm/7US5Hp/Nclr+EHKmffEAem3OeDSdEaccU9vquKKuaFMdGAZK00FpjYVAQSMPy7er5BQy81+1QuDCTZ7UpPct3Mth2agjEUh+XmMAGU7+EugkVZjgVOtvUEdX0LjnAMi/y2kP0cXrf+JaY2zLg4Lw6uPq7YfHkMK3k4hXwJV0gYpMtu1H3V+74rPgOAVrXn3QKBYl7Z8WtYtUMIauwTFiCEtpQ9RHH3zWgXIs3zMmHpotYjhagd603b8M3plKZvHevUquHvCxQLH2os3ezuFlPy32ikjFOuFZTlID8m8ek4XUdsLgcAbQZ//QC9V/dr/M7cykKe2cGtvfrlZznwFU0HIquuZhsqnoWgA3nKtTAEvcFZ4+aZaerZ2AKI8JAcnN4rUW3Y2ysSXml7No/rihGEKP0JTZhw==
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd42861-8c92-4dbd-4542-08de81677c6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2026 01:17:40.1897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hcEUDSGkOXRWkfALaa3l7AEp5ssUj9ruTyP1+8O+yIKbV49vylk5LSRKl3PbD+VCZn9YpOUSIM0Kijom6XoXpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9520
X-Proofpoint-ORIG-GUID: UM9ZgLorMwMOHstvixytzo7C5Wi2SYlQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE0MDAwNyBTYWx0ZWRfX4nhPoI4JTw4j
 YtmwsbVxJ0LmcjB/M+SFT2gg+MubgM3e1tVs4yoiZ8X6l+P+zD9VS3mPrvTDS2Kdt+qk956a9I4
 QjvgQIITljPTMEbCdfq2LOwSP2wMy+6OUKAQfMdFFvL7o7zI9xqUPjn4raLV3rdCBz2J0wpNqmV
 mSis1PB/Zdkz3qSloxWVsHbGjTmRSyJwE069TW5uh40JwDGD9WI1+rVj4NIMJ3nqdEEbuFMq+4j
 Kysb2ubqBMSWZ4eIYYNFb96DyHAWR8rMA1Fh/qf7Uuhe2SRarrxKJ/+MmQMA+8Y+XaeTSHkYgYk
 jlrN+N6Ms8QT+APtGCN/6FzQZy1Zmx2IUmJtVahlXaVKBRyC2uuHkUUnKVa9ACgyI28+QA76K87
 gteFz0G0Nw9oqDJhnlUagtFBCWfeUi7r7fuVYMH9Ns3LErgCnMrBFbhxtMITYUx7ZwB4jpH07uy
 DJFPY0BWRbbKMSSG9gw==
X-Proofpoint-GUID: UM9ZgLorMwMOHstvixytzo7C5Wi2SYlQ
X-Authority-Analysis: v=2.4 cv=KP1XzVFo c=1 sm=1 tr=0 ts=69b4b73d cx=c_pps
 a=8EbXvwLXkpGsT4ql/pYRAw==:117 a=8EbXvwLXkpGsT4ql/pYRAw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=Yq5XynenixoA:10 a=qPHU084jO2kA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tU_645BZ7FZt8VqRJtHG:22 a=jSPayVjLy6xbsuKauFBc:22
 a=VwQbUJbxAAAA:8 a=jIQo8A4GAAAA:8 a=LigMoSc4cSOPXTMD8JYA:9 a=wPNLvfGTeEIA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_05,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam
 policy=outbound_active_cloned score=0 clxscore=1011 lowpriorityscore=0
 adultscore=0 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2603050001 definitions=main-2603140007

The target_core_file doesn't initialize the aio_cmd->iocb for the
ki_write_stream. When a write command fd_execute_rw_aio() is executed,
we may get a bogus ki_write_stream value, causing unintended write
failure status when checking iocb->ki_write_stream > max_write_streams
in the block device.

Let's just use kzalloc_flex when allocating the aio_cmd and let
ki_write_stream=3D0 to fix this issue.

Fixes: 732f25a2895a ("fs: add a write stream field to the kiocb")
Fixes: c27683da6406 ("block: expose write streams for block device nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core=
_file.c
index 3ae1f7137d9d..3d593af30aa5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -276,7 +276,7 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlis=
t *sgl, u32 sgl_nents,
 	ssize_t len =3D 0;
 	int ret =3D 0, i;
=20
-	aio_cmd =3D kmalloc_flex(*aio_cmd, bvecs, sgl_nents);
+	aio_cmd =3D kzalloc_flex(*aio_cmd, bvecs, sgl_nents);
 	if (!aio_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
=20

base-commit: 1c9982b4961334c1edb0745a04cabd34bc2de675
--=20
2.28.0
