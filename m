From: Hannes Reinecke <hare@suse.de>
Subject: Re: SSP frame iu defines
Date: Mon, 12 Oct 2015 16:46:19 +0200
Message-ID: <561BC7BB.9040109@suse.de>
References: <56167B0D.5040303@huawei.com> <5172892.J8LUuCdX1I@wuerfel> <56168208.2020404@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbJLOqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 10:46:23 -0400
In-Reply-To: <56168208.2020404@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Arnd Bergmann <arnd@arndb.de>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, zhangfei <zhangfei.gao@linaro.org>, john.garry2@mail.dcu.ie, "xuwei (O)" <xuwei5@hisilicon.com>

On 10/08/2015 04:47 PM, John Garry wrote:
> On 08/10/2015 15:22, Arnd Bergmann wrote:
>> On Thursday 08 October 2015 15:17:49 John Garry wrote:
>>> Hi,
>>>
>>> For a new driver I am preparing for a SAS controller, I need
>>> defintions
>>> for the SSP command and TMF iu structures. Currently these are
>>> defined
>>> in the following:
>>> ssp_command_iu, ssp_task_iu: drivers/scsi/aic94xx_sas.h
>>> ssp_cmd_iu, ssp_task_iu: drivers/scsi/isci/sas.h
>>>
>>> I plan to move them to include/scsi/sas.h . Any objections?
>>
>> Hi John,
>>
>> I think a question like this is better asked by sending a patch,
>> to make it easier to see what the resulting change is.
>>
>>     Arnd
>>
>>
> OK, can I put this together.
> I feel that the code may get messy due to byte-ordering difference
> in isci versions.
>=20
Then define a standard version, and use the appropriate conversion
macros in the driver itself.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
