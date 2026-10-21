Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=46.29.101.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792596738;
	b=pAvrv8cdAnwQXJozF7z80MpHEXcUJi+Gxeads8VIkU/vLdYVbYljTXfLdl/DbqziFzVX
	 p3NBhV7UF58J7xaZf25WTwupFs/DHkGMVhFjBgjhLhNwzu8gHW7WaLFBQw6pxPEQW09Ib
	 obLUAO8uUEBP4aS03VzJ6EOj58PZhnt83/uV1gWUcvHAGTkY3MXIQy/glZNH4+8xpdgca
	 oQSieDW2OSSBtYq6dVK6FFglxkcY2KvH/5OiXy2mWD6A6r1ZWRJMZJsehkCRzc2e1NLNp
	 bMBnsb6z69WRYw4Q+XoK4w+KthXFwmHPcphr89z/j4GsRcpQJnB1Kl/oGy6869BNGCQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792596738;
	h=DMARC-Filter:Received:Received:Received:Received:DKIM-Signature:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:Accept-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:Content-Language:
	 MIME-Version:Content-Type:X-SM-outgoing:X-SM-Actions:
	 X-SGG-481ba73ae510d215d7d91bff9f2a28ac-STATE-CONN:X-SGG-UMAMSID:
	 X-SGG-481ba73ae510d215d7d91bff9f2a28ac-STATE-DATA:
	 X-SGG-481ba73ae510d215d7d91bff9f2a28ac-CYREN-AS-RESULT:
	 X-SGG-481ba73ae510d215d7d91bff9f2a28ac-EXPURGATEAS-RESULT:
	 X-SGG-RESULT:X-TM:X-SGG-MF:X-purgate:X-purgate-type:X-purgate-ID:
	 X-SGG-RESULT:X-SGG-DKIM-Signing:X-SGG-Platform;
	bh=6zp7mBcrjE3I16Czr5kUUm7ES2JLl1bfTzxkkZR6ZNw=;
	b=0WLQ45gUeDx8VoZMAJR0Z45XQHdZEp8VhWHxK55Jej7FjZXV/hVhJs7vXk2HCrLUpO3F
	 OwEEENW8T+mkpT/tKBUpvU8cnco8dnGD/CvldIzsieEgch0+vrPmvErSN74aPdFVKIs1E
	 xSDVEKZD6eeXtEo55DxBFMdEryF78Cll/5u7UFYtw+wzsKp37U2LYMC3Q9jO57Y6YAbhY
	 EoquRlv2p41CswO073+P+YVur0pX6dRl+7TKgsq+8QUvQ0BW0gSwa0ku7LN48eOd8zxaA
	 7ZuRzZcGWq6CAyHOqD3wP4cHGYUV5JW5RqzNVukG69oycO7BRser+mCrZFfKfesD5qg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=DATANET.DE;
	spf=pass smtp.mailfrom=datanet.de;
	dkim=pass header.d=datanet.de header.i=@datanet.de header.a=rsa-sha256 header.s=default header.b=MJaWvqGk;
	arc=fail smtp.remote-ip=46.29.101.2
Received: from muc-mta02.mas.t-systems-service.com (muc-mta02.mas.t-systems-service.com [46.29.101.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F3606A31F;
	Wed, 21 Oct 2026 15:32:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 192F3606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=DATANET.DE
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=datanet.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=datanet.de header.i=@datanet.de header.a=rsa-sha256 header.s=default header.b=MJaWvqGk
Received: from eegw-mx1.mas.t-systems-service.com ([217.150.145.227]:39607 helo=secure-email.t-systems-service.com)
	by muc-mta02.mas.t-systems-service.com with esmtps (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	(envelope-from <tulbrich@datanet.de>)
	id 1xJYIR-00040z-27;
	Wed, 21 Oct 2026 17:32:08 +0200
Received: from muc-mta02.mas.t-systems-service.com ([46.29.101.2])
          by eegw-mx1.mas.t-systems-service.com (Totemo SMTP Server) with SMTP ID 272;
          Wed, 21 Oct 2026 17:32:07 +0200 (CEST)
Received: from [80.157.1.58] (port=50136 helo=securemail.datanet.de)
	by muc-mta02.mas.t-systems-service.com with esmtps (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	(envelope-from <tulbrich@datanet.de>)
	id 1xJYIK-0003Yb-0G;
	Wed, 21 Oct 2026 17:32:00 +0200
Received: from securemail (localhost [127.0.0.1])
	by securemail.datanet.de (Postfix) with SMTP id 4j8tYq0h8pz8mQc;
	Wed, 21 Oct 2026 17:31:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=datanet.de; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; s=default;
	 bh=6zp7mBcrjE3I16Czr5kUUm7ES2JLl1bfTzxkkZR6ZNw=; b=MJaWvqGk1XXf
	HECUeYi/A1dfdCBRutxir1IGghtnfqNLdjNTvLsimzUUFpzRdecZx/L8b0/6er4G
	QjXe2r6YWXg2tOmwcN8rkNDfHRnRc2TApOtQYRKBQMhDD+us8Z4Ho1e1du9NODtN
	1Iq7UIBy9ri1v3iVkkMmW9hjSn3TEUpZO86jICc0as870MZQ895dUALTWeZl9ZL2
	RiLboa5lUhd4Tsxu/NZt6EeyjfI3GX3W+cqQlQL0BLmVJceHH3fEKV6UvJSroN5H
	BWDBhPjp3fNxmn7qp0A6/NIYGrOMVK182aFuKpS5D1t02m3LjwbKgFDbtNbEUIaw
	iVkWP6PQKA==
Received: from DB3PR08CU002.outbound.protection.outlook.com (mail-db3pr08cu00205.outbound.protection.outlook.com [40.93.64.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp384r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by securemail.datanet.de (Postfix) with ESMTPS;
	Wed, 21 Oct 2026 17:31:58 +0200 (CEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbqMhqiI/D6SLa5/SLg5CqGllGel1i3cCAIg5YtV+7xOfbwNRFjvX0axuAVVE/VL7mR6XI6HlVMS2C8hQ7auhJhvQ9MU1ycxDdTBMvk8XOTOPHFBWe9ZsBLkHMlm36Zunoucj2IC8x0kLIRrbW8hMJlOzm7yuulOTLsJV7gJrAKoQ2+nSEjY3+x3dyQ+sIDYRsPRlNN1McXxNQ6N+28vrkrh8lPOW7Rk2zFCGhFHeKjdkYMviD48tJ/Nd+RKDvKlYawpM7TSn+xCQdgi+jKfda3PwCZ+aYPbBFs2ILC00vcEzdvf0DB4wcpiNSrEN8Cd34DK13yt0fYotqpL0u+zcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjUz0aUNY5TEXj7uRDz6VFvkxeG8Dukyx98CIFreDE0=;
 b=DwDPCNjG0glUpFZt9umwF4rrydpxOwDlfjTGIg756ZeqyKq4d7Rl2M3Fc8YyOT7l84RZ7OuOZ80mHQ8OVyaiE2BpM7UMbOLe6MBW7GJl9AiE0eCK7MBSLHz17X57NjKHtlcjpbq6QNIrlAr5Uds9/doLC8IDttj/VNbOSelqEU2mT8fuL4IOWEC1bcxbH8qqxp6eRkHZjFIDvPNX2jypYrKMLhLFuJx0Bm9Z3JNehsBdzzrlz0hyU0AlhW5C0ff/Wg8UzMg57aLUFS86QEvaKs1FZl1X2Z7+wfnVPCmFSJk2B4iuylzLnMpjX+NURIXNClcG+ATPN9hfdp+UYihSaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=datanet.de; dmarc=pass action=none header.from=datanet.de;
 dkim=pass header.d=datanet.de; arc=none
Received: from AMDPR10MB9503.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:73b::14)
 by DB9PR10MB5332.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:336::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.2; Wed, 21 Oct
 2026 15:31:56 +0000
Received: from AMDPR10MB9503.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2421:92c4:f055:8dff]) by AMDPR10MB9503.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2421:92c4:f055:8dff%7]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 15:31:55 +0000
From: Ulbrich Tim <TUlbrich@DATANET.DE>
To: "submit@bugs.debian.org" <submit@bugs.debian.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"justin.tee@broadcom.com" <justin.tee@broadcom.com>
Subject: linux-image-6.1.0-54-amd64: [6.1.y regression] ==> lpfc:
 use-after-free of mboxq in lpfc_sli4_driver_resource_setup() since 6.1.178
Thread-Topic: linux-image-6.1.0-54-amd64: [6.1.y regression] ==> lpfc:
 use-after-free of mboxq in lpfc_sli4_driver_resource_setup() since 6.1.178
Thread-Index: Ad1hcToyBjROJCDoS9Cv3zfayHyC5A==
Date: Wed, 21 Oct 2026 15:31:55 +0000
Message-ID:
 <AMDPR10MB950396CA8B1BBBDEC7EB50F5A5662@AMDPR10MB9503.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US, de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=DATANET.DE;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AMDPR10MB9503:EE_|DB9PR10MB5332:EE_
x-ms-office365-filtering-correlation-id: 178351ef-630b-438b-2e45-08df2f887051
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|18002099003|3023799007|261009223027099003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 b/W3JWAXQlVdtjO4qzAn0DErZCEEYApqJLqvOotMNGlnP6zkQrrLVFzEaDBfxHOXtbHA2k2T4i3/iSa3D9L506uipsyrf+xp9Ys8eisDDsSOG92b376Hoh9tA1QwJ2ae8h3VfYf3aWJ6mgVVuI0cYVUpjefFkIS6rPqu6Hqym2t5lLkBOqtwNHOTBEq5y91cIjugjjD3onyh7MlsKWgBCjM5pe6UoXg+g60WPmj8yFrliB2v/Kwz0lh53r5jVCgjk34MyZhIZxGW5tcyCQMn4IMJKbRUA7f0yRek5U8b4xi0U+dVMWIkxi9mmPTx7qzXaxqBs3/BjN5K2dnJnv6xifvea/Nx6dvmxMVz5wyZ6RpFYu5WmTroOSxV5GSEjPBybjx7CmXEJYHKCD/9R7E94CQsY09Nh1ydEQfjW1SfWiijTkiEUW8bC1QJmWl9HMZhbJA9YcOYR9T0NJV7/dzV2CvnHwgwbHhvOZRRowr1+i2d8zWm3beL8zgsEuCcXf5c7Us0L2H/YKE2YEkRhbEj2tdDLwONu4ouVHjelYCn1b1PQXUnybfuP+YyHcN23OYqfmUmwa3GUb/unlLhUHgscAbxT42xubN4jC98Ke1EiTYyByry9IHlAFBYDhqQPujEB2sOSJbLFFKzAlS1F9iv0gxnrtTaEUjynN/tcs7rPdEA2jTIK7Be773HpREezgVBbNPS+gyxZjoHc22iCkvOfvexcokrgKLfljxOAy0xGu4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AMDPR10MB9503.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(18002099003)(3023799007)(261009223027099003)(38070700021)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?oSuE55W2LQD+l3YN8XyebxP5YtqKGDIJa9iknKyUNGYLKVcefuLJbeNBSB+w?=
 =?us-ascii?Q?UTkVYQVnlf2pW1hUBFIyV+x0iwWQre7TvfIQt85gVWSgi1J1SJMtfzKBbQTa?=
 =?us-ascii?Q?VAWFlK6fSAdreQGtjm91acD03Jugkn8yD46keHEFcJ/mgZ202PCPG43cH/Ve?=
 =?us-ascii?Q?75ry+8B8NB2wrY8kNZCtWrdqXF3P+RE6Nmt9xuYmqq0vM+tXzQIFcFqahbPm?=
 =?us-ascii?Q?6oV5eYxQgWnr+yI352GkPVjV6gntivekYZZnGU5+PutwAzo/PdPYM+mwxtoD?=
 =?us-ascii?Q?/MmuGYCYn/uC5/JdmMWfiHlhjtVv6EHMtPhGBP2G8cMwy9OPcvDeNzbC9kjT?=
 =?us-ascii?Q?yZpHEJmHJN+AHlbKE1sLkN/idvp0Gg5KMToiHsWkvSGF6YQ4NGE8p6r7cC8O?=
 =?us-ascii?Q?XU0j8bJ37OtRDR8r8/pVEwQQ9w2sls6nqChJwUq/GIEgCb+lheWawOS2Y4Um?=
 =?us-ascii?Q?de8rUfC6G3/CyehNFttiH3rBU9dfrR31t4Zmmti7lzedAaKcHYC5JYAreFU8?=
 =?us-ascii?Q?w8Tu7KNDsQvazaK0gaUgyw9Yme+LUpZHXi+N1kaESB+w+T7hgUdhBYCC+cht?=
 =?us-ascii?Q?1ZiVzTSqO9YHYZnmLfuxCmShCbL4XcrKRpoH//IQe6QjrAKuj2pfXFYzwjqr?=
 =?us-ascii?Q?XAe2IHQ7KTw51Lc+ChPbt+637Vm8BokOCJNB5GVExMKuEIDGc34H77anBe2D?=
 =?us-ascii?Q?OqNyF1QEChThQiDnFwViEDTFNJUHSOiN3APPFGRwjUbl221zVULuQ3LRU5UO?=
 =?us-ascii?Q?RZow0lcZvKDc3tuL8I/eAxF5V19Ps5KLStjgcH3c+MY1DgCONtCigm9aRJtS?=
 =?us-ascii?Q?lZoWU1Q6oFIkg+D8/gyo2oT7C42Cd0OakxQoaktnWzCPyrDCh+d8DwN/KOBM?=
 =?us-ascii?Q?ejJQ68R8JAruYhTDxDRS14oX3BGEXcatdnP0S7KcAiV91Wh0BUf+h3GuCBoC?=
 =?us-ascii?Q?CQ1vbjJ0tCVDVZ9WjhaQXn3n09ZNU5z4hLfry5CkKU1lUFqXh7Qc1ORWWxDx?=
 =?us-ascii?Q?41PT70zXelhIz7Ax3Ynbd9pKvYTDYnzW2L35ZlXJwDISrwUsEbDERDun8nCN?=
 =?us-ascii?Q?iWC4z54SlejmV76anacCeTja+Uq8CRM9dDHR2pAmpqBIuUrRnz/1xBQQJVAQ?=
 =?us-ascii?Q?P+AQAg3qKV+P9N2dnH0uPqHnrM9F8nqGGGViEshRBKNMM17cmEU3MdSHGsCu?=
 =?us-ascii?Q?r6rJud8cwHhy4O7eY9ETaWxDJ7IvHI4OqWUlfGLojq2vnEzFEMF6x6X+MIP+?=
 =?us-ascii?Q?LWvXNdbsCnauVXat5uaUI4xzxHqWj4DN0hann890OurZNp6zOC5IAeP264eD?=
 =?us-ascii?Q?97IVuNd8gsPuA7Nq8xqWkRf8JvDLOBhg3ZO9FflgROeifUN+gRHry5H+h7Yv?=
 =?us-ascii?Q?tixda32otT4KPPICJv0BVDHv930OxcYTvsqNP6IFQ5XqTqM+q+Dt53nlN1/4?=
 =?us-ascii?Q?CynJUN42ulsK9HkhZXK5+vcFmqQdpWxktpXPW7rvGDF7MaqUT+N9kkg1UpOr?=
 =?us-ascii?Q?gQ4aBo4EA11ZByMd7rMdxivGXZChDLTcQlcdBAAuXEBt+NLSJoZWjaGKUVwa?=
 =?us-ascii?Q?zVBqk+zXuTUT3G7B4W9HfMPA4VXwAzxElfEMGi96e2Ju/SjDX61DwZGOX5Mp?=
 =?us-ascii?Q?ClTTGea1Pr9hnzrZf12oaQ6wZX7SuJv5HHBWmJhxc6C+F+nS26G9fkRJF5YI?=
 =?us-ascii?Q?aLT9rQCi9i5gbBv9mXlzZqL+6Ag1QB6qqmYKNTGccSvTwfkr?=
X-Exchange-RoutingPolicyChecked:
	gpz/euXoWWQYch7JxpbJu/AXmy13dAWbi1k21wCdiLcCITH/87309GdjnrcvNoHFQRfIxgTQkWW2CDGU/ET9nHuBq9xsjmzJowT+u2RqG3EGqaeMUcltRIgf3L2Oje8bvGkSVxCDnPngaUEelqRfVA5FvZ1wPekNjA7Q6iAqdSjB6BCpCvlm4DL3tjvIHHCGp+bPMCwK0KsEwCkQ12EXjviCCTH6tL+qRioH6nBHXjmrt+INg8lsFi4ticuiZwcIgRiYfcsj3MeA9X1cxYzXghNSlO3oBUO92vPdUZq5go+5vtqpunyZImp1rQ6ljb7K4E8CWe2I3tYDsiaxubySsw==
X-OriginatorOrg: datanet.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AMDPR10MB9503.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 178351ef-630b-438b-2e45-08df2f887051
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 15:31:55.5809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0b8cf347-87f9-4f76-81a2-185f5c59cbfd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a9rpqZlzfcje5V4GhRmyUPB5Jy4DgGwAT4NbZkCq7m9wndcZJCxXG1jv59PT/L6IfKMobijvDL6oEBvetUYA2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB5332
Content-Language: de-DE
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg="sha-256"; boundary="----D192DF38FA612D8E67A6B6830097522F"
X-SM-outgoing: yes
X-SM-Actions: SMIME_SIGNATURE_ADDED,ARC_SIGNATURE_VERIFIED
Authentication-Results: muc-mta02.mas.t-systems-service.com;dkim=pass header.d=datanet.de  header.s=datanet.de 
X-SGG-481ba73ae510d215d7d91bff9f2a28ac-STATE-CONN: 
	 ewogICAgICAgICAgJ21mcm9tJyA9PiB7CiAgICAgICAgICAgICAgICAgICAgICAgJ2FjbF9jX3Jl
	 c29sdmVteCcgPT4gJycsCiAgICAgICAgICAgICAgICAgICAgICAgJ2FjbF9tX3NwZicgPT4gJycs
	 CiAgICAgICAgICAgICAgICAgICAgICAgJ2FjbF9jX2Ruc2JsJyA9PiAnJywKICAgICAgICAgICAg
	 ICAgICAgICAgICAnYWNsX2Nfc3BmX3Jlc3VsdCcgPT4gJycKICAgICAgICAgICAgICAgICAgICAg
	 fSwKICAgICAgICAgICdob3N0JyA9PiB7CiAgICAgICAgICAgICAgICAgICAgICAnYWNsX2NfaGVs
	 bycgPT4gJycsCiAgICAgICAgICAgICAgICAgICAgICAnYWNsX2NfY29ubmVjdCcgPT4gJycKICAg
	ICAgICAgICAgICAgICAgICB9CiAgICAgICAgfQo=
X-SGG-UMAMSID: 20261021153159Z13677muc-mta02.mas.t-systems-service.com 1xJYIK-0003Yb-0G
X-SGG-481ba73ae510d215d7d91bff9f2a28ac-STATE-DATA: 
	 ewogICAgICAgICAgJ2FudGlzcGFtJyA9PiB7CiAgICAgICAgICAgICAgICAgICAgICAgICAgJ2Fj
	 bF9tX2N0YXZfY291bnQnID0+ICcwJywKICAgICAgICAgICAgICAgICAgICAgICAgICAnYWNsX21f
	 c29waG9zYXNfc3BhbScgPT4gJycsCiAgICAgICAgICAgICAgICAgICAgICAgICAgJ2FjbF9tX2N5
	 cmVuX3NwYW0nID0+ICdvZmYnLAogICAgICAgICAgICAgICAgICAgICAgICAgICdhY2xfbV9jMScg
	 PT4gJzAnLAogICAgICAgICAgICAgICAgICAgICAgICAgICdhY2xfbV9jNScgPT4gJzAnLAogICAg
	 ICAgICAgICAgICAgICAgICAgICAgICdhY2xfbV9leHB1cmdhdGVfeF9wdXJnYXRlX2lkJyA9PiAn
	 MTUxNTI4OjoxNzkyNTk2NzIwLUJEN0Y4NUUyLTlFRTIxREEwLzAvMCcsCiAgICAgICAgICAgICAg
	 ICAgICAgICAgICAgJ2FjbF9tX2NyJyA9PiAnTm9SZWZJRCcsCiAgICAgICAgICAgICAgICAgICAg
	 ICAgICAgJ2FjbF9tX2MyJyA9PiAnMCcsCiAgICAgICAgICAgICAgICAgICAgICAgICAgJ2FjbF9t
	 X2M0JyA9PiAnMCcsCiAgICAgICAgICAgICAgICAgICAgICAgICAgJ2FjbF9tX2NoJyA9PiAnb2Zm
	 JywKICAgICAgICAgICAgICAgICAgICAgICAgICAnYWNsX21fc29waG9zYXNfbG9nJyA9PiAnJywK
	 ICAgICAgICAgICAgICAgICAgICAgICAgICAnYWNsX21fZXhwdXJnYXRlX2xvZycgPT4gJ0FOVElT
	 UEFNIE9VVEJPVU5EIEVYUFVSR0FURTpjbGVhbiAobm8gYWN0aW9uKSAxIDE1MTUyODo6MTc5MjU5
	 NjcyMC1CRDdGODVFMi05RUUyMURBMC8wLzAnLAogICAgICAgICAgICAgICAgICAgICAgICAgICdh
	 Y2xfbV9jNicgPT4gJzAnLAogICAgICAgICAgICAgICAgICAgICAgICAgICdhY2xfbV9jdGF2X21h
	 bHdhcmVfbmFtZScgPT4gJyIiJywKICAgICAgICAgICAgICAgICAgICAgICAgICAnYWNsX21fZXhw
	 dXJnYXRlX3hfcHVyZ2F0ZScgPT4gJ2NsZWFuJywKICAgICAgICAgICAgICAgICAgICAgICAgICAn
	 YWNsX21fZXhwdXJnYXRlX3NwYW1fYWN0aW9uJyA9PiAnbm8gYWN0aW9uJywKICAgICAgICAgICAg
	 ICAgICAgICAgICAgICAnYWNsX21fc29waG9zYXNfc2NvcmUnID0+ICcwJywKICAgICAgICAgICAg
	 ICAgICAgICAgICAgICAnYWNsX21fY3lyZW5fdmFsaWQnID0+ICd0cnVlJywKICAgICAgICAgICAg
	 ICAgICAgICAgICAgICAnYWNsX21fZXhwdXJnYXRlX3NwYW1fc2NvcmUnID0+ICcxJywKICAgICAg
	 ICAgICAgICAgICAgICAgICAgICAnYWNsX21fc2dnX2RtYXJjX3F1YXJhbnRpbmUnID0+ICdmYWxz
	 ZScsCiAgICAgICAgICAgICAgICAgICAgICAgICAgJ2FjbF9tX2FzX21hbHdhcmVfdXJsJyA9PiAn
	 MCcsCiAgICAgICAgICAgICAgICAgICAgICAgICAgJ2FjbF9tX3NvcGhvc2FzX3NwYW1wcm9iYWJp
	 bGl0eScgPT4gJzAnLAogICAgICAgICAgICAgICAgICAgICAgICAgICdhY2xfbV9hc19waGlzaGlu
	 Z191cmwnID0+ICcwJywKICAgICAgICAgICAgICAgICAgICAgICAgICAnYWNsX21fYzMnID0+ICcw
	 JywKICAgICAgICAgICAgICAgICAgICAgICAgICAnYWNsX21fY3lyZW5hc19sb2cnID0+ICdBTlRJ
	 U1BBTSBPVVRCT1VORCBDWVJFTjpOVEMnCiAgICAgICAgICAgICAgICAgICAgICAgIH0KICAgICAg
	ICB9Cg==
X-SGG-481ba73ae510d215d7d91bff9f2a28ac-CYREN-AS-RESULT: ANTISPAM OUTBOUND CYREN:NTC
X-SGG-481ba73ae510d215d7d91bff9f2a28ac-EXPURGATEAS-RESULT: ANTISPAM OUTBOUND EXPURGATE:clean (no action) 1 151528::1792596720-BD7F85E2-9EE21DA0/0/0
X-SGG-RESULT: 20261021153159Z13677muc-mta02.mas.t-systems-service.com C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:off CM: SIP:80.157.1.58 SMF:tulbrich@datanet.de
X-TM: DSMSIS
Authentication-Results: muc-mta02.mas.t-systems-service.com;dkim=pass header.d=datanet.de  header.s=datanet.de 
X-SGG-MF: tulbrich@datanet.de
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151528::1792596727-577FC5E2-5271B004/0/0
X-SGG-RESULT: 20261021153207Z15437muc-mta02.mas.t-systems-service.com C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:off CM: SIP:217.150.145.227 SMF:tulbrich@datanet.de
X-SGG-DKIM-Signing: 481ba73ae510d215d7d91bff9f2a28ac
X-SGG-Platform: 481ba73ae510d215d7d91bff9f2a28ac

This is an S/MIME signed message

------D192DF38FA612D8E67A6B6830097522F
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-version: 1.0

Hi all,

Subject: linux-image-6.1.0-54-amd64: [6.1.y regression] lpfc: use-after-fre=
e of mboxq in lpfc_sli4_driver_resource_setup() since 6.1.178
Package: src:linux
Version: 6.1.190-1
Severity: important

Since 6.1.178 (commit 299f5baa1321, backport of upstream 1bd28625e25b "scsi=
: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()"), mempool_fre=
e(mboxq) is called before lpfc_get_sli4_parameters(phba, mboxq), which stil=
l uses mboxq; the error paths after it free mboxq a second time.
On an Emulex LPe35000/36000 (10df:f400, FW 14.4.730.15) this causes slab co=
rruption and a GPF in __kmem_cache_alloc_node during boot; the system hangs=
. 6.1.170 (Debian 6.1.0-45) works; 6.1.190 (Debian 6.1.0-54) fails; booting=
 with modprobe.blacklist=3Dlpfc avoids the crash. Reverting the backport or=
 moving the free below lpfc_get_sli4_parameters() should fix it.

Greetings,
Tim

------D192DF38FA612D8E67A6B6830097522F
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
6If6kyrV+PgFISRFhO44a2xZ6Vx/pQ0DXUov//OHV6dpo1rKqpFoJIQlNkf4kVvR
QlbA76oZVvVF8ec9disjqfzDVyELEv0CJvO+wM9HojfuJTCI2jinpSho80CYidyk
MgaBMah2Q6OM89sbBiODnx4g1PreuoxABInFSc88hrSBlGLHQ1jsDpTPwi/3xFtt
DLtkQO8d0sV5WbOX/lNcptATF+cSnI6OOJ9agn4V4qQSPg706F3/Z+AdDpj4NjAs
Vsdk9OYO8dCg5JL/9XY0GR2cZOx8hzOIgfWHKkXFH+Gp7En4Nrtnu42MGHaWKB1c
0cMYx6rrjRfZZXHSx9JmWPFt6SeuvcoV/Op95qU+mzVQjrxD7WIEuX8Snxpl5GbP
AIr6JsA9Ckp9vGyN3xwF7wVxdo5ZTgOM/piZjLTEwLi8devdmCseov3wPnoid+Jh
usExmnVQoNLOXP+uNdZGateexjmAVTvTkpasm7aC5JgKtzgicbc+P4SY+YToSiyK
STbCD3SdgXEkMz/108mfIjDoh2RXqp2u/2HtUqukuuXbaoRNYLj9d+IlTtixjocU
qekASUq7y3qtSdTkZzCBaNwH7MF9APUq3n2OUuhvY9wPAgMBAAGjggFwMIIBbDBc
BggrBgEFBQcBAQRQME4wTAYIKwYBBQUHMAKGQGh0dHA6Ly9haWEuc3dpc3NzaWdu
LmNoL2Fpci00YTdmMTc4OC0yNmI1LTQ4ZWMtYTU0Ny1jMWNkMGJmMTdjM2QwEgYD
VR0TAQH/BAgwBgEB/wIBADBABgNVHSAEOTA3MAkGB2eBDAEFAQEwCQYHZ4EMAQUB
AjAJBgdngQwBBQEDMAgGBgQAj3oBAzAKBghghXQBWQIBCzBRBgNVHR8ESjBIMEag
RKBChkBodHRwOi8vY3JsLnN3aXNzc2lnbi5jaC9jZHAtM2VlNTVmZDQtNTkzOC00
MWVlLTgyZGItMzIyM2FjZWY1YzIzMBMGA1UdJQQMMAoGCCsGAQUFBwMEMA4GA1Ud
DwEB/wQEAwIBBjAdBgNVHQ4EFgQUv7QWQaKnn9dNhQEKoVy+28XS5ZQwHwYDVR0j
BBgwFoAUzC6tiYyD40CjJWml6pJ90jc6x8YwDQYJKoZIhvcNAQELBQADggIBAEal
hi+SM2xU/uB4q/WNj4q1Q2bLHy+UKg6jy1nkJzvrXvmhytWznSVmK36cdZd70uqe
67V8yj7SMSmAL12rLpwLEASA0fmTBsXFcU8c4H+TEx1a5tnXHBw4/aUHiezs+z1F
QY4hyl+4CnYotjBq+M7nyD7oVUaFjdHpUCGY1E7pseHPTBBHAoBk2jYYzBgybFbr
eYjhvPUli8JJ5m2pmHLFMwM7ARQN1iTGvPeDmBBSgyeutqTWQZF2kUER5+iTxory
eB/DAiB580EX0GfOhGGUhWubf//NuipKGPgheowRSBJxY3PZZOOoppS6EuT4zLKc
2qtunoR4VnQE+ADsB9VZ69F/g44LGsfpLgUm0wqa5zNnTCp5tMwvsDFW2RKp5Pv8
0ENOHwPyP4dW8fAyLiz5y6dLcMx1cT3LO6LGVyN+wP/ZpLXuq4TbdB+c0RJ0PLlN
SzlaWbUKVhD4vVxkbBLADKoyz1E2Dnv6C0m7lSGOf4UZUud0ZCDMiiv/7KerooTM
3auEbMuk8enBR0Ohf5ic2Wtml3H8g6CSdpIbOcn+ZDMDo+N981LQXHemp3jVA7S5
fkdYMURr+AbRSjt9rKbNcVwVv0AoKspHlet3Rb5/ZTbP+G8LzjeL2rbwKgnvFEy3
TAXxK6f1TbvyJouA803II0MmivP02Yiia9PjlcruMIIHKTCCBRGgAwIBAgIUSiZM
VPUb/YkTS65p9RwySafplDwwDQYJKoZIhvcNAQELBQAwUjELMAkGA1UEBhMCQ0gx
FTATBgNVBAoTDFN3aXNzU2lnbiBBRzEsMCoGA1UEAwwjU3dpc3NTaWduIFJTQSBT
TUlNRSBNViBJQ0EgMjAyNCAtIDEwHhcNMjYwNDIwMDkzMDI5WhcNMjcwNDIwMDkz
MDI5WjBCMRwwGgYDVQQDDBN0dWxicmljaEBkYXRhbmV0LmRlMSIwIAYJKoZIhvcN
AQkBFhN0dWxicmljaEBkYXRhbmV0LmRlMIICIjANBgkqhkiG9w0BAQEFAAOCAg8A
MIICCgKCAgEAp0ncAuaVkSNvzkaeoSw34J9Db6e71QIkTbhkkU7WqTo4+pANhO73
9BFq6LCOTUXNWxrh53edHapA11hcNMkPIB4Qiw81MNZbDIfz3c2JEPRHzSQxN6jr
Utu85CgpiHsmIIa6O6q8vSQ8FaJf3ThZ3OrF7Hb6vNAdIdR9ccxSXxUrUPpip67P
5yLTLqNQ+rAEOOs2fsvZVs9QoEOXkN1xZRNWbGHYO7BTaocL38fLTI02HopS2s4O
svc2pv4ur0G/mULg2IWHPXqQcjeXoMJvZmX2gRr1KunC/Faq+bbIzbkoCgkyL7bq
dS1faqNCV9vSvZqdoBanFB5IfipIdhtx4zX6iPqjWUWxavGiORcOQP+x0FsPZFbI
2C6cqaQD8ZOpzYTgDLt8x8//TxpMvBwgrRvJQf+V7gNcZCUs4TOPvuoV0nH5SJ6N
7FcIx97t1c64dIL2TzV44zJ5wcrmRAX/A3V8w2upfTLM7sxpUM/ptJzJ+Toj6BvY
Ln4JqSNPPxjXsp3KpAa8uKg/77Bp3o7Bv/ToxI0PenFJO0cOjMP/7WBNWlyDZm6M
gBifZFxXSUx4kfNIv3sWxCtCTNp1Lga66rY9wQI0VK4yM75G17gMS+iBx4lzSVU3
se6NIC2kElij5kK/LNjfokboEnllmw9XJ3tJf5WcutnX8s7f2bdMN00CAwEAAaOC
AgUwggIBMIGyBggrBgEFBQcBAQSBpTCBojBMBggrBgEFBQcwAoZAaHR0cDovL2Fp
YS5zd2lzc3NpZ24uY2gvYWlyLTI2YTcxYzA5LTQ3ZWItNDU1YS05YjI4LTRiZDcy
ZGYwOTI4ZDBSBggrBgEFBQcwAYZGaHR0cDovL29jc3Auc3dpc3NzaWduLmNoL3Np
Z24vb2NzLWFhY2NjZWQ1LTY2ZTgtNDA2OS05YjFiLWZkMjlhYjczZWZlYzByBgNV
HSAEazBpMAkGB2eBDAEFAQIwCAYGBACPegEDMFIGCGCFdAFZAgELMEYwRAYIKwYB
BQUHAgEWOGh0dHBzOi8vcmVwb3NpdG9yeS5zd2lzc3NpZ24uY29tL1N3aXNzU2ln
bl9DUFNfU01JTUUucGRmMFEGA1UdHwRKMEgwRqBEoEKGQGh0dHA6Ly9jcmwuc3dp
c3NzaWduLmNoL2NkcC1lOTdmMDdjNC1lNjM0LTRjZWMtOGUyYS0wNGIyMGE3YTMw
YzUwEwYDVR0lBAwwCgYIKwYBBQUHAwQwDgYDVR0PAQH/BAQDAgWgMB4GA1UdEQQX
MBWBE3R1bGJyaWNoQGRhdGFuZXQuZGUwHQYDVR0OBBYEFLgKJtJUcVJB2BGMy06L
8GaYhBAEMB8GA1UdIwQYMBaAFL+0FkGip5/XTYUBCqFcvtvF0uWUMA0GCSqGSIb3
DQEBCwUAA4ICAQAjh7sAWnfDZU71euWMIfuSt+VUs0ZpFQMGz6QgR/cqK9r9Sx83
SQl3SZBqJqv4tKU+01QklACm/qc7Lq3hvAXW083r9ILiZSPJohCdxvtssNuUgDdk
Qur+6AQ4JTBYBCNjlIEYlOba5Tw6sDap5wCFoysgedgR/1e7w/+3fCOenFBhQXnh
htoDkXX0eu0oey3y+D6s3J0oR1vacZXls26StEUCxgb3UxwIawLPWsD/SDBg0X8E
7KKSy8FP9eWJZ4SSslkwvULoBAJ41FMrUHc4Gw0dEpg2BRTiUKBWk4GWZlSeC8bh
KcG0y0GLgwJXTiSWwKF51p5JQMyM5/hEXsURj0206klyaZuCMV7a4mGiWcNh60um
VVu9QQ7+nmPl3FVCL12dHwKaVLFmIirUb2j2vYSgfivnsP1FsXDgwA/MyVXPXRNX
emsVyZ+pyh4rSHAHKjfl3zhgJvMWaQVPW18qYFlFw6Fuw88wIxBgTe3tWPrd/MBY
s9uvYe9gSp4Ber4mBm78+ZkI4m3B+7NvUlfptNuRaAutA1Kb4FXZ03oT5BG2fnTM
0mwR/qKFQz+GSpJfb+jY5X7HY7Wm2lMty//c5CSSFBi7HZU44y7QkXVzZJyFSoH8
86IMpO0SULz0XOWNaKoQAVhbXZVUAI0ZCcFpMGoP+IlZRyXZ2gnLRwCryzGCA3ow
ggN2AgEBMGowUjELMAkGA1UEBhMCQ0gxFTATBgNVBAoTDFN3aXNzU2lnbiBBRzEs
MCoGA1UEAwwjU3dpc3NTaWduIFJTQSBTTUlNRSBNViBJQ0EgMjAyNCAtIDECFEom
TFT1G/2JE0uuafUcMkmn6ZQ8MAsGCWCGSAFlAwQCAaCB5DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjEwMjExNTMxNTlaMC8GCSqG
SIb3DQEJBDEiBCBtDEkJiNY2MkeQUBMf4FygtC3S7IsQ+l3JDp1tgnCjZzB5Bgkq
hkiG9w0BCQ8xbDBqMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUD
BAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAH
BgUrDgMCBzANBggqhkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAgBea1Kt/PRZ
Cyoqj2X4QZ8uLye8MaW/+mm9+r+DjPEbB/uJNtZpdUhPED9ZjwmuiVTpWulAE8K7
xph+cww/ZrC2uz6YjkD2PB3tUvNlKKW8+SOITb7zRngtw2T/63+3TD6Jf3L8UeQE
gP2gOr7WW4xOMaKXIuzAaaObU7xhXjHsM8qQ72rgfWFjRcknA12C1G2QhDeE0Ptu
g/pRn2c4Pj/2BczH55fPk4T82sxJ3q0bqtR8JmXlhwTsc//uBDmHbYKcFCkCDVTD
vMwXcXT81b5TBlykE9TpeDSuiRjy95l+A4+tl380YR1+Q70OqszUXh3aivsJAJdu
5zKK7BLgjktygADcpz5ndQUQcCjZLO/rShRxIc0vqh0L93L8+pCgiRJHvtIo4gn8
QeP8X1fYl3/zV/W2uB7mBFYQTZ1R0GUO88CWXIOW7ElRMSNzo/NgfAYKI0+Kgtam
xEh2QOQu9coCVTTZ50c0LcGF23JaUMWQeUilNKNdmpZl6/OLup+pmKMO+syrOcGv
F5N8HK5S+iAmEYFXpx/1IjGAPtcCXzT4Q/8I3R4Ba3vUevIX5Aj0EtWK4XO+e8L2
SmC17Ke0kP1zwn0L+6ZlO9Vx5m+7L5wQNX30oirztIgtTii1656njkLhrivjjOdo
FU7IFkZQs50MP3321oy1b4j9SSZKYqDDTQ==

------D192DF38FA612D8E67A6B6830097522F--
