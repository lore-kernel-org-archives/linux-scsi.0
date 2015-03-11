From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH 8/9] snic:Add event tracing to capture IO events.
Date: Wed, 11 Mar 2015 08:40:22 +0000
Message-ID: <D124EECC.18937%nmusini@cisco.com>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com>
 <1423586616-18177-9-git-send-email-nmusini@cisco.com>
 <54F466FF.1050600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:28165 "EHLO
	rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbCKIkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2015 04:40:45 -0400
In-Reply-To: <54F466FF.1050600@suse.de>
Content-Language: en-US
Content-ID: <4FDB09E9B5DB4D4599EA712BDBD3D5BD@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Hannes,

   Thank you for reviewing the patch. Please find responses inline.


On 02/03/15 7:04 pm, "Hannes Reinecke" <hare@suse.de> wrote:

>On 02/10/2015 05:43 PM, Narsimhulu Musini wrote:
>> snic_trc.h contains global trace structure definitions for snic driv=
er
>>=20
>> snic_trc.c adds tracing functionality to capture various IO events.
>> It maintains global trace buffer to maintain recent history of IO
>>events.
>> It helps to understand the sequence of events prior to particular IO
>>event,
>> or hung, panic, etc,.
>>=20
>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>
>Hmm. There _is_ a tracing infrastructure in the kernel.
>Any particular reason why you insist on creating your own?
The tracing infrastructure in kernel is not enabled by default. And
requires manual intervention to enable it. Snic tracing is compact,
specific to driver and enabled by default to capture most recent events=
 in
IO path. Snic trace facility helps in investigating corner issues.
>
>Cheers,
>
>Hannes
>--=20
>Dr. Hannes Reinecke		               zSeries & Storage
>hare@suse.de			               +49 911 74053 688
>SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
>HRB 21284 (AG N=FCrnberg)
Thanks
Narsimhulu
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
