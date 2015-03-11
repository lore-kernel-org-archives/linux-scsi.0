From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH 3/9] snic:Add meta request,  handling of meta requests.
Date: Wed, 11 Mar 2015 08:35:37 +0000
Message-ID: <D124E545.1878E%nmusini@cisco.com>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com>
 <1423586616-18177-4-git-send-email-nmusini@cisco.com>
 <54F45E1B.90803@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:42415 "EHLO
	rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbbCKIpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2015 04:45:06 -0400
In-Reply-To: <54F45E1B.90803@suse.de>
Content-Language: en-US
Content-ID: <1A6F60BEA15ADE49AE3B1D014428BED0@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Hannes,

  Thank you for reviewing the patch.

On 02/03/15 6:26 pm, "Hannes Reinecke" <hare@suse.de> wrote:

>On 02/10/2015 05:43 PM, Narsimhulu Musini wrote:
>> snic_io.h contains meta request structure definition
>> meta request contains high level information about firmware requests=
=2E
>> such as request information, size, SGLs.
>>=20
>> snic_io.c contains interfaces to handle meta request, firmware
>>acknowledgment,
>> and high level generic queueing interface.
>>=20
>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>
>Reviewed-by: Hannes Reinecke <hare@suse.de>
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
