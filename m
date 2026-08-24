Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A374399CF0;
	Mon, 24 Aug 2026 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787565319; cv=fail; b=fHdAYJaglt9ijVAUcvtZM1EJ/yL5f50UANuIBm2bOU31DMQtO0W8qIBpplSTK5BYg8h+g2JPsil8kVVGJIdxqZ60el14nAcNh/wighMxSvE60TMmXHIVi+QXdwqrkNXd9GlpC+45Ij3p6xHAsRofusaobTC3iyVU4pxaVrBb2i4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787565319; c=relaxed/simple;
	bh=fdOWHB8vrxKM6JuxE3U2drBw/mYQaT7Y0Jd+vtrlWBs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GbTnxlCwtSvWvDY9e//E5bZcVVcwtnWC4LVn12hIULSt6nkNyKB1NTdMm04E728xVc6jVRBW+Tl+t88lKPaerKF3AWuVBBh+BPD7b3naOKaQIqE23Rjuw8fvJaestRUYP/8YsP0oP+ibOhLjgUsxby3xB6UkGPousdtqKNIM6/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=GzZN8pwS; arc=fail smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="GzZN8pwS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2545; q=dns/txt;
  s=iport01; t=1787565317; x=1788774917;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n7MQeDJvCDm+GYlFUGrvw7eVD+/yMqbrqwHko/WAp+M=;
  b=GzZN8pwS0LMGOOZ9jdX+9GDrLCNqN69qhZX7F8T8XD1zedrJEjhOQFSa
   /cVrqmjDuF9Y9R64JW65xwlEvOt5F0JSF6M/fPiVd+IShzl+zzujvmkQa
   f9olntJy5Qw6a9YdU/NegdRuhLpWmknr5suWidMfENz1spOhCLWW8Qvmy
   7lMKHv9AnE/QaxVvAiazsMJr9+q6Wv84I9MSPn3a3bwTiUWVzkL84pjxQ
   TbCc+cLUvGfitD/UtzTiGIc4ugD/FLePNwC+DAWhnQFicIOQafKW+h6jy
   GFuFbqYdT0XF2KGaIJumT9uU8AP464jSSr11c2W529OEBfYeLZpbH/bTv
   w==;
X-CSE-ConnectionGUID: 9soy3mmlR5K++rWOOlOR4w==
X-CSE-MsgGUID: SOJ/OBUwQUijn7UQ8pjamQ==
X-IPAS-Result: =?us-ascii?q?A0AoBACqE4xq/48QJK1aHgEBCxIMZYEgC4FuU4IrSYgjA?=
 =?us-ascii?q?4UrhliCIQOeG4F+DwEBAQ0CUQQBAYUFAo1sAiY1CA4BAgQDAgMBAQEBAQEBA?=
 =?us-ascii?q?QEBAQsBAQUBAQECAQcFgQ4ThlyGWgEBAQEDJxM/EAIBCBgeEDElAgQBDQUIh?=
 =?us-ascii?q?W8DAQK4GgKKHHiBATOBAeA5FAGBOIheAYV4hHwnG4INgVeCaT6ECjuEE4IwB?=
 =?us-ascii?q?IIigQyBfZFdUngcA1ksAVUTFwsHBYEjQwMqLy0WDQ8TKQUtHYEjEg8dFxceW?=
 =?us-ascii?q?BsGBRIgKkFEIwM+gRlBAoF1PyMZNnyBCV6BKylkAQIQF0YuFYIHAoJagSdeA?=
 =?us-ascii?q?gFJQw4HRyILbT03FBkDBIE1BY5UH4JGAQFjKhyCJJQRgmkBsCIKhB6iEheEB?=
 =?us-ascii?q?JQXklGZCCOjaIUNAgQCBAUCEAEBBoFqAzeBWXAVgyJTGQ+OX89deT0CBwIHD?=
 =?us-ascii?q?gMLkWiBfgEB?=
IronPort-PHdr: A9a23:FrmjbhY888t3QjG850hkb5j/LTAchN3EVzX9orIuj7ZIN6O78IunY
 QrU5O5mixnCWoCIo/5Hiu+Dq6n7QiRA+peOtnkebYZBHwEIk8QYngEsQYaFBET3IeSsbnkSF
 8VZX1gj9Ha+WXU=
IronPort-Data: A9a23:MB0b565Thlh60WKsJzT3tgxRtFDGchMFZxGqfqrLsTDasY5as4F+v
 mcWWDzUOarcYmv0ed51a9+28ENUvsWGndNmHQJlrC5mZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH2dOC98RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wo/qUzBHf/g2QqajJOt/rawP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4ebJYf671yBGV0q
 N9bayoySTeHoNjq3+fuIgVsrpxLwMjDNYcbvDRkiDreF/tjGc6FSKTR7tge1zA17ixMNa+BP
 IxCN3w2MlKZP0Yn1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3FYIOLJozbGpQI9qqej
 lnh3SPeKCwFDeGeyzzaz0v8nu3GmBquDer+E5X9rJaGmma7wm0VFQ1TVlahp/S9olCxVsgZK
 EEO/Ccq668o+ySDStj7Qg39u3WfvzYCVNdKVe438geAzuzT+QnxO4QfZjdFbNpjsIo9QiYnk
 wfX2djoHjdo9raSTBpx64upkN97AgBMRUcqbi4fRgxD6N7myLzfRDqTJjq/OMZZVuHIJAw=
IronPort-HdrOrdr: A9a23:+2SxcKjGRrAJlc2qx7+y/WgMA3BQX9V23DAbv31ZSRFFG/FwyP
 re/8jzhCWVtN9OYhAdcIi7Sde9qBPnmaKc4eEqTNGftXrdyRqVxeZZnMTfKlzbamHDH4FmpN
 1dmsRFebnN5B1B/LnHCWqDYpgdKbu8gd2VbI7lph8HI3AJGsRdBkVCe3qm+yZNNXB77O8CZe
 GhD7181kKdkBosH6OGL0hAddLu4/fMk5XrawMHARkI1Cmi5AnD1JfKVzKj8lM7ST1g/ZcOmF
 KpryXJoomzufCyzRHRk1TU84lXn9XZzN5CDtyni8QeKDng4zzYJbiJXYfsgBkF5MWUrHo6mt
 jFpBkte+5p7WnKQ22zqRzxnyH9zTcH8RbZuBylqEqmhfa8aCMxCsJHi44cWADe8VAcsNZ117
 8O936FtqBQEQjLkE3Glpr1vlBR5w+JSEgZ4KkuZk9kIM0jgXhq3NUiFXZuYdM99eTBmdga+a
 dVfZrhDb1tACOnhjjizxpSKZqXLzQONybDZFQescqI1DUTtnV4w0wEgPE7pB47hcgAo10u3Z
 WZDkyu/4s+E/M+fOZzAvwMTtCwDXGISRXQMHiKKVCiD60fPWnRwqSHq4ndydvaMaDg9qFC0K
 jpQRddryo/akjuAcqB0NlC9Q3MWny0WXDoxttF75Z0t7XgTP6zWBfzBWwGgo+lubESE8fbU/
 G8NNZfBOLiN3LnHcJM0xflU5dfJHECWIkeu8o9WViJvsXXQ7ea/NDzYbLWPv7gADwkUmTwDj
 8KWyXyPtxJ6gSxVnrxkHHqKgXQk4zEjOVN+YThjpwuIdI2R/9xWyAu+CGE2v0=
X-Talos-CUID: 9a23:KFxEeG/7v6JBaJabYmOVvx8PHdF+d3jZ9irzYAyiNkFOTJqvFUDFrQ==
X-Talos-MUID: =?us-ascii?q?9a23=3AAMb0ig4fJuI4dweH6+MY3/4bxoxTxIbpL2owjqw?=
 =?us-ascii?q?7usuCahFJay+fhTGOF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-06.cisco.com ([173.36.16.143])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Aug 2026 09:54:07 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-06.cisco.com (Postfix) with ESMTPS id AC4B51800026B;
	Mon, 24 Aug 2026 09:54:07 +0000 (GMT)
X-CSE-ConnectionGUID: /hWWhG9GQSiSLKMBBcXDUw==
X-CSE-MsgGUID: aK/c0XBGTOmXjxM5Y5tv8Q==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.25,240,1779148800"; 
   d="scan'208";a="63697153"
Received: from mail-northcentralusazon11010029.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.29])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Aug 2026 09:54:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XLs8h8P7igc/7lk/CR2dWqCMV4JC5yNEdIfJ8x7t3c3DIaPddoJxzysfIOgjNY/cb+uFGqxigcw9SW73AG0RD/si/B25gmZ8h+Qiy+r1CAljN54RYbCC372lH8sHTI5cnzK5zXHntfMlmNTKYM+VgBr37eMkjxyVuzjyFPRRWN7AKuv181B0MQ3sm3RVsiRVPNmL+1we7sEK/IqcjTpgqcV18ONj+mj9l4c8Lj37PQrcuYbYtvcNVFLUpyo6pQdiFb0eb9P6C73+uXwssp17Keca+2xvhdv/npmTdNrYOtjMVOJxb0pUWiT9QTvUfXMgcM1VsBQVJa7svvoHGjhQkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7MQeDJvCDm+GYlFUGrvw7eVD+/yMqbrqwHko/WAp+M=;
 b=oBu07v51lv5oG1gvu/+oHDfzkX9nnUuQrM5m9c/MGD5r+pOZffjfVG1kXX3WIE8dOM9cf4S9sla99+8V7YNPzbRJT8LrYACiiHAg10+tERp8lxmiaAG5i4Z6cPGvMmdEZ9Dl9l0Ywa523ixKLDVvC0vmfM6UTHd/8I1mHNaLWw+OYoM/VcsXYSR/UJs+whKRcL0OTxWDvHmOMwpMAwDfYy1qV2IMjlC70Jw3OewzQcmNVatI+5heg8M79VKHmueOsWBOEdOsnbCts2tZbs+Dd2336/9Z7beX8gBWlqQXH6JaTL+cL8Oqdf/B6maIf0xz2cQKD38WQLKNPEa63Rw8vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by EAYPR11MB9946.namprd11.prod.outlook.com (2603:10b6:303:2da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 09:54:04 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 09:54:04 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Linmao Li <lilinmao@kylinos.cn>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Hannes
 Reinecke <hare@kernel.org>, Justin Tee <justin.tee@broadcom.com>, Naresh
 Gottumukkala <nareshgottumukkala83@gmail.com>, Paul Ely
	<paul.ely@broadcom.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>, "Arulprabhu
 Ponnusamy (arulponn)" <arulponn@cisco.com>
Subject: RE: [PATCH 1/2] scsi: fnic: initialize the NVMe local port info
 before registering
Thread-Topic: [PATCH 1/2] scsi: fnic: initialize the NVMe local port info
 before registering
Thread-Index: AQHdL8/tiO9knU7kREqpjtsF7UOa8LarGafggAABhbCAAeD8gA==
Date: Mon, 24 Aug 2026 09:54:04 +0000
Message-ID:
 <SJ0PR11MB5896ACCB95853799B658E896C3A02@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260819114242.3598034-1-lilinmao@kylinos.cn>
 <20260819114242.3598034-2-lilinmao@kylinos.cn>
 <SJ0PR11MB5896AC03937115745995EFDFC3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58963CA2B53ABA6D1E89A0B1C3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
In-Reply-To:
 <SJ0PR11MB58963CA2B53ABA6D1E89A0B1C3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|EAYPR11MB9946:EE_
x-ms-office365-filtering-correlation-id: 9e421eff-78a6-4522-6637-08df01c5a1b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|5023799004|11063799006|56012099006|38070700021|4143699003|10067099003;
x-microsoft-antispam-message-info:
 9mq2QadBMSHzXWce4dnRfoF2uJQzdMyATBeelJXas5Oy3ocUomiyJBhaK5S+VnkiVCYzMQJCJACZHGZ+s0xUHw/0kx08io/TmfRMPFMHXjNYFNels4o5nZCc/KEAkTsJk2uMFA7GDy4f/LA+XOo2hXUUolnbul92sq6dw9x6lzjoTBgljYLMyeLEF2PaHjxmDRFwc9S7ZcU2XGhEETZFv2HG9h4VNCkvTlQV+quWU3QTaLYnBItTV6b3kEOjn4HzV1OgU0ifZFtaC35E8O5+wXd+O5sNlArdwtat5KeKmNkyHzuWin9jtP/ZQKLcK331/Df0pnoRkT5eHB18FJpKYunlcqaoJ9IhP87lZVILhsUkKgkFZfW4+4hJHPECpQZ+g7ip9R9sE1RHr1Guh6uJWowq6+YSgeyOBmlIpHLJPqAYRIr4EkBJ0YbMTo2xcidzNjkGlb7F/Bu9YFXSxRC+hBWbx8OPB2TzV/ziTdf4Bg+86FmB8aYnis9AZAKMLgANlrgYo2HNdTwcf2RLpND/colf4S2LISp5pCTqlHctQaMYd9kFHTNDJAlhovP8Uzn1zBsT9SaQ3FFbxNBxhwKFAj4vwGSFmOoHpof0/YxDWPOYFi7w9fSXfYuaehALQhshgArWZXZIPQSSrsFUAZ4DFzvLS/bTqbZVRYDemfVM4fQtXdZcauGrhjKQ0hHfq1p5gSOYBk+mV0u05bBRrnRLgOEO1CCJGPiq8ClSwjyG0Pw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(5023799004)(11063799006)(56012099006)(38070700021)(4143699003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?nVrFmvzxvCh93DuVSW9DR7djpruAjZjp1a1SnE+9BA6Zehhk1RzDMPSi5SD0?=
 =?us-ascii?Q?Sx4BPsVbYzQm6AhgxfoZ5VXLK6zFzuS2+4rg8kpJJoXFnOUs8tLWrGA7SUyI?=
 =?us-ascii?Q?AaxgacVNRQMUDY52X6Wml47+XnMravNRq+DECsL3TB0CMxawF5GHv3HY4pBy?=
 =?us-ascii?Q?x/JNShJZzd/7h0EBlSJxAsEdFGDKF+I41bpvJV0SdnfR5uHggPCS7N4Y6d9s?=
 =?us-ascii?Q?qiJOcl0O62R0GaslJpYZBkjL0r2TVirPMychSIFdggagNzAuy+VaE0MHtaZO?=
 =?us-ascii?Q?xJhbYDzfmE/Zzs4h2Uhhyu6aKv/l4v2ELLqTwLznNMcNoKkXVUHGHM8iVyNj?=
 =?us-ascii?Q?BYDdAE3BUH47o47onzuXr4/b5Sf1z7TDpQGrNgAglMuiabSmgiOziW0u2N9Z?=
 =?us-ascii?Q?f4tDs1Bw+DwrDRQXL+YZh0XAzdQMbVHKPOJW9OTQQYo0jE5OfbUjA0NI/BNH?=
 =?us-ascii?Q?RoH+Yj6gGbWhXE4Cn46PpphmHEjf/uT5XrKcm7oPRUIkeO6cko+cQUU0sjVb?=
 =?us-ascii?Q?v/dM8xwaN3AWdeyY0j/IJzbBaxIYm8dbu7grFu+m7mg6hDcs6ibX4Krgg5ch?=
 =?us-ascii?Q?HoKUVqoIdKhl6zyIbHftrh6lBIK1ZO0TU2hUYU2RV2TJQWsA3q7jaHddkNGo?=
 =?us-ascii?Q?2uWlq1KOL9Oz5G7n42qEAqAG71FcyKlYL26SZ8gQabTq664NGHB8SebMulIb?=
 =?us-ascii?Q?93Z2a4K/rzRKMXHqLQADnwqocnX/LRXPdm5+KbH0HHKhSmkklPpx2B0GnZJu?=
 =?us-ascii?Q?vUxmA6BUOQ/AP03lT8Sh4JHWMzSs4M5zrrBOnKngZuhdow1TIipeYOwvvL3A?=
 =?us-ascii?Q?wdwzIkqa/4Vr43/ieNU6SAI7uBq66U7pBD1wqbxHDG0e9ZX7nqsFPUqDGXlM?=
 =?us-ascii?Q?hbI+9R8J7QgQJkTYMuupu74PNDo/m1dywJGw5p5rT4RexhtL9nxQp0O6m/ez?=
 =?us-ascii?Q?iq47F/zeh1b+TdxTPFMxnYOyGNNZ04ALUM8GmCWBOCvNWo123gztv/OucFt0?=
 =?us-ascii?Q?N7gCzhUY1ioHUalPdywGP7wYH1vNLS+GbXbs6QuviMEs0vpxP9xkXDsGWLYu?=
 =?us-ascii?Q?4VMjxMV92G30HUeKccKnJOYRka2Tg6VzcnRmdK1A6lposfs8wqeh6Z3UMuBM?=
 =?us-ascii?Q?iDTYNJN1E3WUBUuQxA6Jf9qM/mLa4VyOH+exmgDUQFoh0EXjWqoVHVfLSz/X?=
 =?us-ascii?Q?jTg76B6P6KNDM+mlRgYfHBqLnPgUQvrl2NruZfnMgXgbTJb8BJT03R++3yOe?=
 =?us-ascii?Q?cDsCIWEKWqB/RtmkJLj3GlWES1yJpQW1obXbpAHMa8d9//d0mAJtD1KnggYk?=
 =?us-ascii?Q?7NBSmrwcptNFTmEpMf+9pnxlGbpYPgShrsormn9vpW2XEdMtmxW87tOf0S6O?=
 =?us-ascii?Q?0QOzelJKc7QxndMAhuklwB/H1jFvPLCtJKZ8yCGda9K5Nb4XlHerkCkL3h4h?=
 =?us-ascii?Q?bA23ujk+fCU7ag56Hez/oAZsF9qqXzqptJq5XoyjoQxpR8Ui/Mua7KHoOgk/?=
 =?us-ascii?Q?epsQrai8iwbDmZCb9wuFsRX9XmNb4U+akCoC14F+0c3aMmmOCk2zk1yTvFV0?=
 =?us-ascii?Q?L4NBkM3gxI5t+lfVzcWP3qXH7pm5dQX5vbsMh/8yqKcu+8BY4k5g4mtqGhI6?=
 =?us-ascii?Q?4cGb1Nn8KL/amezUSwRRCoyYHbaA4qOLk8CMqyNPSdArVoiOAf5gIKD1Qgl9?=
 =?us-ascii?Q?2mpIfn/djWmV7uPMap0Q438iiXqzrWX4BzAonK/Hv2rT5f+I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	so3yz4W68fJDms4eZlKotHAzH5JoJiYZW5PZf2Ks3hy33E81/BakP/2KuQ3YK8UEhdEMtA/U7qXj2MwVS6PTqNpS1U6Y7GcHeuJBFJbLbQ8fRUKmLWhMrbnbo+JRrBlktX+z0wekc/EDa0ikwHiECcZBQJV/hSvmA6wFXx/vNDzjyMKr5Nyz1EBM0dVzoMIGOtI8CDWyHJTqzPULZwqalJTW8kL8ITQq0Hn2yyx51iyuCv3xDXHyqoOPDWPNiOT4Nsqb5IZB6/4XPkI5I0rmZ3bhQM4zPB67E4R/3GtcowuEtgvC4r3+dw2PPuKnqSvEiEUN1hM68cEcFElN+LSj6Q==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e421eff-78a6-4522-6637-08df01c5a1b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2026 09:54:04.2585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I3mxzBBhtNqMzjxZl/Qg8NhsXbLSmCHuJ78A2xpista7hLyBz/HSmUpvxX7mNocv/A6h4ATWX9976XW/Fxa1ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR11MB9946
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-5.cisco.com [173.37.147.253];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-06.cisco.com

On Sunday, August 23, 2026 10:41 AM, Karan Tilak Kumar (kartilak) wrote:
>
> On Sunday, August 23, 2026 10:35 AM, Karan Tilak Kumar (kartilak) wrote:
> >
> > On Wednesday, August 19, 2026 5:13 PM, Linmao Li <lilinmao@kylinos.cn> =
wrote:
> > >
> > > nvfnic_add_lport() declares struct nvme_fc_port_info on the stack and
> > > fills in four of its five members, leaving dev_loss_tmo holding whate=
ver
> > > the stack happened to contain before the call.  The structure is then
> > > handed to nvme_fc_register_localport().
> > >
> > > nvfnic_add_tport(), which registers the remote port a few lines furth=
er
> > > down, memsets its own struct nvme_fc_port_info first, so only the loc=
al
> > > port path passes uninitialized data across the transport interface.
> > >
> > > The NVMe/FC transport documents dev_loss_tmo as "Used only on a
> > > remoteport" and does not read it in nvme_fc_register_localport(), so
> > > there is no behavioural change today.  Initialize the structure anywa=
y:
> > > the driver must not depend on which members the transport happens to
> > > consume, and any member added to struct nvme_fc_port_info later would
> > > silently start out as stack garbage.
> > >
> > > Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> > > ---
> > > drivers/scsi/fnic/fnic_nvme.c | 2 +-
> > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_n=
vme.c
> > > index b237948dcafdc..00d9d5d439a38 100644
> > > --- a/drivers/scsi/fnic/fnic_nvme.c
> > > +++ b/drivers/scsi/fnic/fnic_nvme.c
> > > @@ -2216,7 +2216,7 @@ int nvfnic_add_tport(struct fnic *fnic, struct =
fnic_tport_s *tport,
> > >
> > > int nvfnic_add_lport(struct fnic *fnic)
> > > {
> > > -     struct nvme_fc_port_info pinfo;
> > > +     struct nvme_fc_port_info pinfo =3D {};
> > > struct fnic_iport_s *iport =3D &fnic->iport;
> > > int ret =3D 0;
> > >
> > > --
> > > 2.25.1
> > >
> > >
> >
> > Thanks for the change, Linmao.
> > It seems simple and straightforward.
> > I'll bundle it up with the other change in our internal testing and get=
 back to you.
> >
> > Regards,
> > Karan
> >
>
> Just realized that you've requested to drop patch 2/2.
> I'll do a build and load of this change and check that nothing's broken.
> I'll get back to you.
>
> Regards,
> Karan
>

Thanks for the change. It looks good.

Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
