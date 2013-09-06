From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [PATCH 1/9] fnic: FC stat param seconds_since_last_reset not
 getting updated
Date: Fri, 6 Sep 2013 20:51:42 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B12AE6FF77@xmb-rcd-x08.cisco.com>
References: <1378488921.2063.21.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:51827 "EHLO
	rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3IFVCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 17:02:19 -0400
In-Reply-To: <1378488921.2063.21.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Content-ID: <5215ED683455224BB751F222FA2EB19D@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>

Hi James,

Yes for this patch Narsimhulu Musini is the author of this patch.

Thanks,
Hiral

On 9/6/13 10:35 AM, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Thu, 2013-08-29 at 10:57 -0700, Hiral Patel wrote:
>> Code to reset fc_host statistics.
>> echo 1 > /sys/class/fc_host/hostX/statistics/reset_statistics clears
>>fc_host stats,
>> the code also issues command to fnic firmware to clear vnic stats.
>> 
>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>> Signed-off-by: Hiral Patel <hiralpat@cisco.com>
>
>Explain this signoff order, please?  It looks from this like Narsimhulu
>Musini should be the author?
>
>James
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

