From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [PATCH 9/9] fnic: FIP configuration mismatch between switch and
 adapter crashes driver
Date: Mon, 10 Dec 2012 09:45:24 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B1288D0AF7@xmb-rcd-x08.cisco.com>
References: <1355132307.2464.14.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:61562 "EHLO
	rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2LJJ5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Dec 2012 04:57:51 -0500
In-Reply-To: <1355132307.2464.14.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Content-ID: <93A2F50F518B99459CBDC3F883D7B295@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Sorry This one is just same as [9/10], only difference is subject. By
mistake I emailed it with others.

Ignore this patch from the set.

Thanks,
Hiral

On 12/10/12 1:38 AM, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Mon, 2012-12-10 at 01:21 -0800, Hiral Patel wrote:
>> If switch configured in FIP and kirkwood lake configured in non-fip
>>mode,
>> panics while queueing FIP frame in non-existing fip_frame_queue. Added
>>config
>> check before queueing FIP frame in misconfiguration case to avoid
>>kernel panic.
>
>Where exactly does this go?  You've already got a 9/10 patch which is
>different.
>
>James
>
>

