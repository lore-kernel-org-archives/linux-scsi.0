From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH 7/9] snic:Add sysfs entries to list stats and trace data
Date: Wed, 11 Mar 2015 08:39:53 +0000
Message-ID: <D124EE9C.1892B%nmusini@cisco.com>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com>
 <1423586616-18177-8-git-send-email-nmusini@cisco.com>
 <54F466AB.7000604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:10941 "EHLO
	rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbbCKIjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2015 04:39:55 -0400
In-Reply-To: <54F466AB.7000604@suse.de>
Content-Language: en-US
Content-ID: <D642323FF7EE124188C8464825945768@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Hannes,=20

  Thank you for reviewing the patch.

Thanks
Narsimhulu

On 02/03/15 7:03 pm, "Hannes Reinecke" <hare@suse.de> wrote:

>On 02/10/2015 05:43 PM, Narsimhulu Musini wrote:
>> snic_stats.h contains stats structre definitions for various events
>> in snic driver.
>>=20
>> snic_debugfs.c contains setup and cleanup of sysfs entries for listi=
ng
>>stats,
>> resetting stats, enabling/disabling trace, and listing trace data.
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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
