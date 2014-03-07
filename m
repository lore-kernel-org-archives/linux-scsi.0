From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH 1/2] megaraid_sas: fix a small problem when reading
 state value from hw
Date: Fri, 7 Mar 2014 05:54:50 +0000
Message-ID: <7938f23faeb84e0ea84e0ec51f2641fb@DM2PR07MB400.namprd07.prod.outlook.com>
References: <FED98228974DC94193B53324998C8A7C3033DA72@G01JPEXMBKW04>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn14138.inbound.protection.outlook.com ([207.46.163.138]:34484
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750830AbaCGFyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 00:54:54 -0500
In-Reply-To: <FED98228974DC94193B53324998C8A7C3033DA72@G01JPEXMBKW04>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Minemoto, Shintaro" <fj3207hq@aa.jp.fujitsu.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "thenzl@redhat.com" <thenzl@redhat.com>
Cc: "aradford@gmail.com" <aradford@gmail.com>, "Tokunaga, Keiichirou" <tokunaga.keiich@jp.fujitsu.com>, "Ishii, Hideyuki" <ishii.hideyuki@jp.fujitsu.com>



>-----Original Message-----
>From: Minemoto, Shintaro [mailto:fj3207hq@aa.jp.fujitsu.com]
>Sent: Wednesday, March 05, 2014 12:06 PM
>To: linux-scsi@vger.kernel.org; thenzl@redhat.com
>Cc: Saxena, Sumit; aradford@gmail.com; Tokunaga, Keiichirou; Ishii, Hideyuki;
>Minemoto, Shintaro
>Subject: Re: [PATCH 1/2] megaraid_sas: fix a small problem when reading
>state value from hw
>
>Hi Tomas,
>
>> When the driver reads state values from the hw it might happen that
>> different values are read in subsequent reads and this can cause
>> problems, this may lead to a timeout in this function and a non working
>adapter.
>
>I reviewed your patch and it looks good to me.
>
>Reviewed-by: Shintaro Minemoto <fj3207hq@aa.jp.fujitsu.com>

Patch looks good to me.
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

Sumit 
>
># I'm not in scsi-linux mailing list.  Please cc me when you reply.
>
>Thanks,
>Shintaro Minemoto
>

