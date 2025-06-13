Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1880C19D08F;
	Fri, 13 Jun 2025 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749851193; cv=fail; b=jTHX6loipgZ7uA3sUjej4vr2aibQOC8cvJCGuHTAMSICi4mRtolpBZ107fIKsF3O5M+siqeGiXca/lvCg0ORC+fYb1IiF147v61clfo6UJO12CNe4D7phPOoIrnH0comyzgJahMOLfjE+X+ktY1jwJY9DnUqK4LEMQZlwIVt1Ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749851193; c=relaxed/simple;
	bh=qquIElgbvyp0n5zjglcWF15UY7z4Yv8RZgm61Goh6dw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YKsVZCqRhU6JJmX64/r3b424mLDSfQdj7G0lhjufnaqtTMFx5139ssRuoaXTwvRh7OJyE84faj/+eksOwLTraY5IDOrIkETsrMkMKK7zu5uJVkL3VEV4toICmVvFMP6ao4jG86c4rTzBxj0UpVdWbMKwd84+O8Bx0bXVuAkUkJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=MIQPaxu4; arc=fail smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="MIQPaxu4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2444; q=dns/txt;
  s=iport01; t=1749851191; x=1751060791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qquIElgbvyp0n5zjglcWF15UY7z4Yv8RZgm61Goh6dw=;
  b=MIQPaxu4G4x+Bj/xSlemexB1RAKDxmzTh96Nf6LW5HtS/ji9pmGw1vNB
   mPLI/m5X6uBq5+FWQ1fdrzooK+tzr4FU1In0e0COtCNE74jQYu74FkU8g
   AN7WOxItE0u5tYULSXfBfegIpSKAnD4uAyLE1loHT+eLpX9fwHfdfR0Oz
   skFdJKann78kzLa9ykMlw6X8AO/NU31zc2cRZsx73fYeEJtLj0rdR/94/
   Y19zjfaNfUmdlP2aaY2X1N7Sqmdk8CZodOFs3pX4oLDhhfU3hLZ4he0+H
   hqLc9WFKjyz9WpOoXw9U7w+CjDw0Ba9t9CJahHRx+u8GjAYBwoFpfUM9A
   Q==;
X-CSE-ConnectionGUID: dhSMQ7tvTYiVn5EVzUaCSg==
X-CSE-MsgGUID: 0TA9LUivSF6BEpZvPfyjTQ==
X-IPAS-Result: =?us-ascii?q?A0AEAACom0xo/4r/Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVIHghVJhFSDTAOETV+GVYIknhaBJQNXD?=
 =?us-ascii?q?wEBAQ0CUQQBAYUHAhaLUAImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOGCIZaAQEBAQMSEQQNRRACAQgOCgICJgICAi8VEAIEAQ0FC?=
 =?us-ascii?q?BqFTwMBo2wBgUACiit6fzOBAeAlgRsuAYhQAYFtg38bhFwnG4INgRVCeYE+M?=
 =?us-ascii?q?T6ECjsVg0Q6gi8EgiREUo0WlA8JSXgcA1ksAVUTFwsHBV5CQwOBDyNLBS0dg?=
 =?us-ascii?q?g2FGR+Bc4FZAwMWEIIkgWAchGKESStPgyKBEgFsZUGDYRIMBnIPBk5AAwttP?=
 =?us-ascii?q?TcUGwUEOnsFmAKDbwGBDoECgT6WeUmvSQqEG6IJF4QEjQ2ZUJkEIqNBhSoCB?=
 =?us-ascii?q?AIEBQIQAQEGgWg8gVlwFYMiUhkPji0WuzV4PAIHCwEBAwmPc4F9AQE?=
IronPort-PHdr: A9a23:yybj8xKjL6+ydVIop9mcuVQyDhhOgF28FgcR7pxijKpBbeH6uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:teNVlK1wYDoRapPnA/bD5blwkn2cJEfYwER7XKvMYLTBsI5bpzMEn
 GRKDDzVOqzfa2unKIx3O4+2/R5T6sLXyIVhSwdo3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmG4E70aNANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXU5
 7sen+WFYAX4g2AtaTpOg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGAEENGLRH5vhLMGBw8
 6E1FiIwZzu4iLfjqF67YrEEasULNsLnOsYb/3pn1zycVa9gSpHYSKKM7thdtNsyrpkRRrCFO
 IxDNGcpNU+QC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OO8aYqNIofVGK25mG7Am
 kuX21n4HCo0avay0Qibyny9hNP2yHaTtIU6UefQGuRRqFmSwHEDTR4bT122pdGnhUOkHdFSM
 UoZ/mwpt6da3EiqSMTtGgazu3+soBERQZxTHvc85QXLzbDbizt1HUAeRTJHLdhjv8gsSHlyj
 xmCnsjiAnpkt7j9pW+hy4p4ZAiaYEA9BWQDfiQDCwAC5rHeTEsb30OnogpLeEJtsuDIJA==
IronPort-HdrOrdr: A9a23:ikcn6K1Xdq8yvVC5niPGFwqjBf1xeYIsimQD101hICG9Lfbo9P
 xGzc566farslcssSkb6K690cm7LU819fZOkO8s1MSZLXjbUQyTXc5fBOrZsnHd8kLFh5RgPM
 tbAsxD4ZjLfCdHZKXBkUeF+rQbsaS6GcmT7I+0oQYOPGRXguNbnntE422gYzRLrXx9dOEE/e
 2nl7J6TlSbCBMqR/X+LEMoG8LEoNrGno/nZxkpOz4LgTPlsRqYrJTBP1y9xBkxbxNjqI1OzY
 HCqWPEz5Tml8v+5g7X1mfV4ZgTssDm0MF/CMuFjdVQAinwiy6zDb4RG4GqjXQQmqWC+VwqmN
 7Dr1MLJMJo8U7ceWmzvF/ExxTg6jAz8HXvoGXowkcL4PaJBg7SOfAxwb6xQSGprHbIe+sMlp
 6j6ljp8qa/yymwxRgVqeK4Dy2C3XDE0UbK2dRj/EC3F7FuKYO4aeckjRlo+FBqJlOg1Kk3VO
 ZpF83S//BQbBeTaG3YpHBmxJi2Um00BQrueDlIhiW56UkeoJlC9TpR+OUP2nMbsJ4tQZhN4O
 rJdqxuibFVV8cTKaZwHv0IT8e7AnHEBUukChPeHX33UKUcf37doZ/+57s4oOmsZZwT1ZM33J
 DMSklRu2I+c1/nTceOwJpI+BbQR3jVZ0Wm9uhOo5xi/rHsTrviNiOODFgojsu7uv0aRtbWXv
 6iUagmdcML7VGebrqh8zeOL6W6c0NuIvH9kuxLLm6zng==
X-Talos-CUID: =?us-ascii?q?9a23=3AS/HXsWpBLveOtke8gldz/RLmUcwlSVjkk2vOH36?=
 =?us-ascii?q?5N2A0ZYOHdFa7w6wxxg=3D=3D?=
X-Talos-MUID: 9a23:kt8mugqn8KgxeikZf/Qez2leHZZM3qWwM25Tu7geide8Oz1yBw7I2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 13 Jun 2025 21:45:16 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPS id 67A6D180001D2;
	Fri, 13 Jun 2025 21:45:16 +0000 (GMT)
X-CSE-ConnectionGUID: bwakxhmeS7mgQiTM8Z5fPw==
X-CSE-MsgGUID: r/SGy7zmTnigDnX8JziNGA==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.16,234,1744070400"; 
   d="scan'208";a="49723777"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by alln-opgw-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 13 Jun 2025 21:45:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pjFUxox1tGWyMOt4bfcOqbu8z4Urc6rqbQqdwcjksjoFaP9ua4FE1CyKvNeqmJkNYZadvHX55cuiMJxQqqSGPFh7QjfwDoPeuTjLRibYP8azHhEbuf7VT7gP/rfDLDi35hLxZ5D3LkvkqRgcK7kJWRLSE96eQ6VG5zUUiVas2BGZ9Ihp02bSUZ9rBs1Pkz/BqwWmvTCJymekeRdO2vVa8G/IzzQlo3qNTJPkHFxjCrKiQsEnTuAi7oOBEFwA+YVqqOlVzmygIg2KBD1AhbjsvUvQHURpJaNlaqssMFWpDIjY05JYCdMgR7hsG3eQnIOJbkLYgIIquvkLox3LxahmEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qquIElgbvyp0n5zjglcWF15UY7z4Yv8RZgm61Goh6dw=;
 b=EIwMdtYkK0t/4a8qOEGJGBOFzgkAQ9BVcjHR+213SO+POSbjf0NeqIwV+FpJ36An6G3wa6tJCiBS6t1k1rbc4gGE2bNK+kLh7/SYnIXc0wyM3Za/E7eNasJCVmrSyUL/e7m0PUnw/RvZHUUV5yH46ey90M1eU7zuvyZpnSeruirZM+01eVX8m9BVjKx58uqVqeM1yVHEBUfOIMOyVpfYZYyYkK2Wt6M10HUedkB2092pnUjn2JIAP/btdaU0hRcvNgUHPljJRG5bqjBe+3J3AkF/TYTSrpNBMW2+tcN7xoHBLjrpQxnHnKvWEM8Ve3V7kPluhDjinqi5dGER8KuDoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SA1PR11MB8279.namprd11.prod.outlook.com (2603:10b6:806:25c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Fri, 13 Jun
 2025 21:45:13 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 21:45:13 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: John Meneghini <jmeneghi@redhat.com>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>, "Masa Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "revers@redhat.com" <revers@redhat.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>
Subject: RE: [PATCH v4 1/5] scsi: fnic: Set appropriate logging level for log
 message
Thread-Topic: [PATCH v4 1/5] scsi: fnic: Set appropriate logging level for log
 message
Thread-Index: AQHb2+fs8/fiHO/pKUeaxzCJfv+HgLQBjVoAgAATUBA=
Date: Fri, 13 Jun 2025 21:45:13 +0000
Message-ID:
 <SJ0PR11MB58960849B96B5BB6875F928AC377A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250612221805.4066-1-kartilak@cisco.com>
 <45bc529f-0949-4d3c-a9dd-e7a30eac22ea@redhat.com>
In-Reply-To: <45bc529f-0949-4d3c-a9dd-e7a30eac22ea@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SA1PR11MB8279:EE_
x-ms-office365-filtering-correlation-id: 06600719-792a-45fc-f907-08ddaac3942c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z1E2Ukdia2lINE1nOVRXL2h4UFpoWWFnM3k3R3JYUnJjT3JVanJHTWY0TUFt?=
 =?utf-8?B?WWQvcEo1OHBseE85U3p3T1BDQ3ZvSkZjdG41NDdLbVNLaDVkbXZGbjZ6UUtG?=
 =?utf-8?B?RkFXR2orWXVneGJGRGFiN011SFdBdWRhZDN6c1ZDTk93aUNvZ2JocTl4dXZ4?=
 =?utf-8?B?Y3ZxdklMRm1tOGVJNE11alc1ZEZhakQ1ekhwYXQya3A0NzRFZFR0OUNJazM4?=
 =?utf-8?B?UisyN1ZRVE01Y3I4N3pzbDFlYUhDSlI3N3hvdXlIZ3AyaGZNTHdWVEZ1cDNn?=
 =?utf-8?B?RVRyR1NpUFpqV2JvWlZiSUlaQTVxaWRKcFFrZG0vN0lxQVdmbWpwTDF1TzJO?=
 =?utf-8?B?VUlRRTJ1QVAreTYxN3V0cTRmY01KRGlvUkRwR1hwKzE3TzZkZTczbHgyZVRo?=
 =?utf-8?B?NGN3cU1OcGU4ZnI2R2ZmalIydEk1eUd0VUlnRHRqMWQ1RVVEYnA5aHlHdGg3?=
 =?utf-8?B?Y29rZkRNclU0bnEwL1luY25XSXQreXFONGJoSi9hK1dVR0FOVzFoT3RhT21z?=
 =?utf-8?B?Y2NqN2QvMEdLMEhFdUJPcDlnejI1UTFmaTFtaFZVenI3eXdRM0FHWCtrUDV5?=
 =?utf-8?B?dmpJUGRuZUVpNTgrU0o0Z1lNZ3JhaWpQbXlSZXh0Skt5OG0rc3N1NUxMaEVZ?=
 =?utf-8?B?UzJCY01kbDZQOURYT1JPbHhLTklFL2E4NE04TGFhSUJHS0dpWEIwUVBWb1BS?=
 =?utf-8?B?NVJ5ZmRwMkxUelVsQ2krZHZidW5LcGV3cXRIY3BBV2d3VkFicGkzNkNtajda?=
 =?utf-8?B?V1kwM1VERGtmYUNWeUVsNHdScGNNUWZMUnBHYThCbnhTdzgrVmQ5cEk3ZHB5?=
 =?utf-8?B?MTFZZjVIOFlkdFc4dEpPcElDUmZlVFN5bWFjVVNYRWNBTXRhSzlBOXE5ZXBV?=
 =?utf-8?B?cFRoMlNPSWYxZkhHc0luUGZaUWFHZzNqNHI2amw0RGJvbXJIeFNZSS9GSEVT?=
 =?utf-8?B?UG8zSWdSVDIydHRGR0x1d0FCVzZQa0RpWEl1clBBZjdEVVdSUjRXV09yTnNS?=
 =?utf-8?B?ei9SY2lmRDF3OWZkaHl2QVdCRzBZM3p3Ui96dVJtMkQvbXNGZ0lzNFpPSVdS?=
 =?utf-8?B?eERTaVV6aER6a0NZQ3JlMjJTTkRDNEhPVG1STXBCdUhiMDZHcGVnYk05bFZ4?=
 =?utf-8?B?U1VtSkJjU0VBQlZLZEdhcDIyZ3ZTTkl1Y0grOVJqaEJJYWJtbGNxVk41R3Ft?=
 =?utf-8?B?KzR2bWZFUDRzVkNSUE1nLzgzK091UTZTb3ZpMEtiY0lmcmFMRVlkcC9tNHMr?=
 =?utf-8?B?clRhQUxkWlQvaENFSjltYjVTTzErZldLSlRhQm1HWlZoMlhIVCt4ZnEyNEdq?=
 =?utf-8?B?N3RIODZWaFJKbExDenFEcUc0MGFGKzVvSlFMQ0JiOHRHZkdGS1QybUQyMmxm?=
 =?utf-8?B?bml2NUdMYWxnM2hlYlVzTUVtOXUybWNtMloyTE5hT0RNOTVHWlF5YXF6SDNt?=
 =?utf-8?B?Zlh1MWZCOTNmOUt5K2d0MkthV2xnQkRXb2FpTjFhOU9kNDBDUUZ3TGFtajRS?=
 =?utf-8?B?YjI5d0xEaDJrTFBVUFpPNk4wUnNSS0hwUnVaNlRwWUIvOFlRS0p3WkprRWMx?=
 =?utf-8?B?eWtHdEZUTkUvc21kWTZnd3QwdzhxS0drS0tHSTZkeG5MT3RjS0wvNUtmbkVa?=
 =?utf-8?B?RWJhRDc5SWtJVjZKbmp2MUtkQmpRVTJSMnkvY0owdjNEeWJyclVyMnRjakMx?=
 =?utf-8?B?dVRUbk5TNXhqOEZOSFNTN1l6VHhOSUM0dndWTFBHRDBrbkhXYmdGV0dBczRL?=
 =?utf-8?B?R2pHY0JaSVB0bm1lOW91QTg5bldsK3RLajluWS90YkRibFhDdjhsTC81b05X?=
 =?utf-8?B?M1kyVWV2MjIwRS9oMHRaSnQ3cjAyQnJyNXJkYytTWkZKNXF4SlAyT3JNSDVv?=
 =?utf-8?B?UzJjRE9mK0FHTllJbHA2UWoyblFxS1ZxMHgxeGphMmY1Mjd4S09XWElsUmhC?=
 =?utf-8?B?SzBwZm02MUFCaEc2cTFiUHFqUHZRYUV0S1BtdFhJdzBuQjl3aStLUk0xakxY?=
 =?utf-8?B?RFhiMlJnc0d3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WmdTZzcvcE1RWWdZNGJ2S050RXFDczhXeWRNTmZEdkpRZ2hyYmR5djYzY1hv?=
 =?utf-8?B?ZUNHZlcyNFBRek5uVlpZempsWG5PaUxncW9FVkgrcTQ4MTJSbkRwSzZIQ2pZ?=
 =?utf-8?B?dTdTWkVHb2srcWp5czdEd1pFaEhCV2pBUWdxUmZPOGJtSjJTdE9XVHozUkY4?=
 =?utf-8?B?MkJPQm4rdzRJTllTZFR6djFGdng1K3hUSk9OUTEzOCtVdG9uc2gwTHVSa2tx?=
 =?utf-8?B?L1gwS3d0TXhjaFBJZHBlS1h3bVY3YkV5aTJRTjdBSDRQT3BWNjNjSmRLeDV4?=
 =?utf-8?B?K2Zway9ET05xWlBkRzU0cnNyc2tVVWNqOEtnOURmSGprUlFzazJxMUN4TG54?=
 =?utf-8?B?cURFWHhSZ0lLb2J1RmFmeUhoM0o5RHQ5ZU5XMy9PYU1nZmFhK0lNRnhxMDJN?=
 =?utf-8?B?ekNNaklxZlEwN0xEcUZNLzNYQi90bkU5aWNzLzlTcTVCTEZUWjdHOW9EWGlh?=
 =?utf-8?B?ZHgxSjN5amZQYW05am9aSHkzbmxQd1lEY3E3WDkyemx4QVhlYk1VN1ZQanF4?=
 =?utf-8?B?eTczN09vTVFiWlhFbXp2VEpES3gxVHpZaVBXc2NodS9BeDd4YWlJMWdvc2Zh?=
 =?utf-8?B?ejFIL0hzZ0JUNUxpcjBvYUtTR3hUYVlESjJINEsxeTdOd3J2YnRadFE3K0dY?=
 =?utf-8?B?bGlRckl2NWIwSi9NanhwNUJkbDJjMUdiVVZCWDU3U2h2bFN3SGlIMVI3NWFE?=
 =?utf-8?B?SHhHc0FQWjdUTGJPL29wMUhKVGs2Zm1iQnBweEhsUDgzSzA1SDdJTTIyUnNp?=
 =?utf-8?B?Y0h2VjUrdnFtTjVjc1NxWmxralRNSitwKzdjamNjbkxqajEvUzdWa2tDbEhQ?=
 =?utf-8?B?UFk4UHpsaWxmOTIreVNNdmIzdGp6NlNtdERiTnUyWFFtb2xmTlJxeWRXYWVn?=
 =?utf-8?B?ZlFHRVNiTmVoRUdyczJJcVFMSk0vTmxDUGpUcnNzN2xBVFRpZ1VzMU45c1ZU?=
 =?utf-8?B?eXlOcCtrbVJFM200S1RxSCtLUnY5M0Jvc1BFSkU0dHRKVWlGZHozSDlNMkQz?=
 =?utf-8?B?RkxydmU5N2tNNmVuVkt0WlY2ZUNlY1dDZEkrWDZObk9WekZmN2s5eTRqaDNz?=
 =?utf-8?B?eVVCVkNPYTVMNngrOThJdzFSSDlwa0FsVk4zdHpFTTUyenUzVmF6ZHVMd3BG?=
 =?utf-8?B?NVU1MzkwTjkraDl0cGtQbDhuRHlGWDhRWHc4emJ1S1FPVEZBUnlmUlh5eGVz?=
 =?utf-8?B?WmU2aGt1WlFLUlpYTHBDZEdhYmZPNnBRZ1dlR2U1a0hXT3RPMXFkYXlMSmVo?=
 =?utf-8?B?TzcybHRtd1F1TDNORjBnUWUxcjhhVkFHYzk5M0tkWXdhcE1UZjUrcksvR0hP?=
 =?utf-8?B?bnRvZFdEQUJoM0RRTVAxbDg5bnRQWkFpUWtWeVZXYmFXRVhLTlFQTjkxOXpJ?=
 =?utf-8?B?SzczK3I5ZTFiaUloR0MraUF3R21jYTdWRmZwcEVQc081clVuTjIvQXpWNDZ3?=
 =?utf-8?B?aGlBMy9CSWxzVndUT2txRmhqVVFaUUZXMDZ1bzRzZkxLSStnVGdxQnh0V29a?=
 =?utf-8?B?bHhIT1psM0RNWWRTdEw2WmFOUktRN0lpQ3RoMk5hc2dkZ2I3M1JaYThRWXhp?=
 =?utf-8?B?WHpaT21ZMFIwODRoQmJwR1NZc2lBUjZwc09jbHNjVXJUL3NSODdYQjNNVWMw?=
 =?utf-8?B?aWprSXVoZC9hcDVGZ1FrOVUvNnQxR05MQUdhSFhzZTJzMGpvdnpsSC9oM3pZ?=
 =?utf-8?B?UGlYUWUySFZjM1FpV29jTUhueFZ6cUVuMWdWUnhKTkpoN0ozUkRZNkwzd3FJ?=
 =?utf-8?B?aXdhSk0yZUZ2cGV2M2R2OUFmMyt1ODZ5U3FzTE9wc0JkU2dSWmR6SHpZV2lG?=
 =?utf-8?B?TjAzeVpRbHZaNDRKdW1zNUdHYUkzb1ZLVlZxL1pmaDJBSDAyQUwwbHNMelBL?=
 =?utf-8?B?ZW1weHg0NG9aZG5GTEVqbWdBM2djV0JYem4yZnl6NlIxaW1jUjhRQklyQkNq?=
 =?utf-8?B?RHVMV3ljMDNNT1hSbkJ1UFE1S292ZnJBc2JkcEFoOHlnc3RxRVpiTkl4a2Zq?=
 =?utf-8?B?d0drL1FnMVFDcDI5aERVUXVvUy9FcXVFOXJQOUR1OC82NmlVZ0JIbGxTcG15?=
 =?utf-8?B?MU1helJaV2xpeU5XRXByQ2dzcDU0VlQrR3NEeHVDRTNldlJKVUc2MklyRjJh?=
 =?utf-8?Q?fgN9y/gqYn03nju3kruScVWYi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06600719-792a-45fc-f907-08ddaac3942c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 21:45:13.7361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q9yrrH1TuVnB178+WLXDWgRnOMEPGcfYI6lPnYDDSb+CxLJ3YsXSswXxjgljz5uze19cIlch0UvYQku6Ai2i5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8279
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: rcdn-l-core-01.cisco.com

T24gRnJpZGF5LCBKdW5lIDEzLCAyMDI1IDE6MzUgUE0sIEpvaG4gTWVuZWdoaW5pIDxqbWVuZWdo
aUByZWRoYXQuY29tPiB3cm90ZToNCj4NCj4gUGxlYXNlIG1vdmUgdGhpcyBwYXRjaCB0byB0aGUg
ZW5kIG9mIHRoZSBzZXJpZXMuDQo+DQo+IFRoZSBtb3N0IGltcG9ydGFudCBjaGFuZ2UgaGVyZSBp
czoNCj4NCj4gICBbUEFUQ0ggdjQgMi81XSBzY3NpOiBmbmljOiBGaXggY3Jhc2ggaW4gZm5pY193
cV9jbXBsX2hhbmRsZXIgd2hlbiBGRE1JIHRpbWVzIG91dA0KPg0KPiAgIFRoaXMgaXMgdGhlIG1h
am9yIGZpeCBhbmQgYW5kIGl0IHNob3VsZCBjb21lIGZpcnN0LiBBbGwgb2YgdGhlc2Ugb3RoZXIg
REVCVUcgUFJJTlRGcyBhcmUgbGVzcyBpbXBvcnRhbnQuDQo+DQo+ICAgVGhhbmtzLA0KPg0KPiAg
IC9Kb2huDQo+DQo+ICAgT24gNi8xMi8yNSA2OjE4IFBNLCBLYXJhbiBUaWxhayBLdW1hciB3cm90
ZToNCj4gICA+IFJlcGxhY2UgS0VSTl9JTkZPIHdpdGggS0VSTl9ERUJVRyBmb3IgYSBsb2cgbWVz
c2FnZS4NCj4gICA+DQo+ICAgPiBSZXZpZXdlZC1ieTogU2VzaWRoYXIgQmFkZGVsYSA8c2ViYWRk
ZWxAY2lzY28uY29tPg0KPiAgID4gUmV2aWV3ZWQtYnk6IEFydWxwcmFiaHUgUG9ubnVzYW15IDxh
cnVscG9ubkBjaXNjby5jb20+DQo+ICAgPiBSZXZpZXdlZC1ieTogR2lhbiBDYXJsbyBCb2ZmYSA8
Z2Nib2ZmYUBjaXNjby5jb20+DQo+ICAgPiBSZXZpZXdlZC1ieTogQXJ1biBFYXNpIDxhZWFzaUBj
aXNjby5jb20+DQo+ICAgPiBTaWduZWQtb2ZmLWJ5OiBLYXJhbiBUaWxhayBLdW1hciA8a2FydGls
YWtAY2lzY28uY29tPg0KPiAgID4gLS0tDQo+ICAgPiAgIGRyaXZlcnMvc2NzaS9mbmljL2ZuaWNf
c2NzaS5jIHwgMiArLQ0KPiAgID4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkNCj4gICA+DQo+ICAgPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2ZuaWMv
Zm5pY19zY3NpLmMgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYw0KPiAgID4gaW5kZXgg
NzEzM2IyNTRjYmU0Li43NWIyOWEwMThkMWYgMTAwNjQ0DQo+ICAgPiAtLS0gYS9kcml2ZXJzL3Nj
c2kvZm5pYy9mbmljX3Njc2kuYw0KPiAgID4gKysrIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19z
Y3NpLmMNCj4gICA+IEBAIC0xMDQ2LDcgKzEwNDYsNyBAQCBzdGF0aWMgdm9pZCBmbmljX2ZjcGlv
X2ljbW5kX2NtcGxfaGFuZGxlcihzdHJ1Y3QgZm5pYyAqZm5pYywgdW5zaWduZWQgaW50IGNxX2lu
ZA0KPiAgID4gICAgICAgICAgICAgICAgICAgaWYgKGljbW5kX2NtcGwtPnNjc2lfc3RhdHVzID09
IFNBTV9TVEFUX1RBU0tfU0VUX0ZVTEwpDQo+ICAgPiAgICAgICAgICAgICAgICAgICAgICAgICAg
IGF0b21pYzY0X2luYygmZm5pY19zdGF0cy0+bWlzY19zdGF0cy5xdWV1ZV9mdWxscyk7DQo+ICAg
Pg0KPiAgID4gLSAgICAgICAgIEZOSUNfU0NTSV9EQkcoS0VSTl9JTkZPLCBmbmljLT5ob3N0LCBm
bmljLT5mbmljX251bSwNCj4gICA+ICsgICAgICAgICBGTklDX1NDU0lfREJHKEtFUk5fREVCVUcs
IGZuaWMtPmhvc3QsIGZuaWMtPmZuaWNfbnVtLA0KPiAgID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICJ4ZmVyX2xlbjogJWxsdSIsIHhmZXJfbGVuKTsNCj4gICA+ICAgICAgICAg
ICAgICAgICAgIGJyZWFrOw0KPiAgID4NCj4NCj4NCg0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRz
LCBKb2huLg0KU3VyZS4gSSBjYW4gbW92ZSB0aGlzIHRvIHRoZSBlbmQgdGhlIHNlcmllcy4NCg0K
UmVnYXJkcywNCkthcmFuDQo=
