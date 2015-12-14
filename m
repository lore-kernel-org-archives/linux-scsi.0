From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no
 management
Date: Mon, 14 Dec 2015 16:29:25 +0100
Message-ID: <566EE055.9050708@suse.de>
References: <cover.1444241058.git.lduncan@suse.com>
 <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
 <1444830904.2220.28.camel@HansenPartnership.com> <561EA018.7020700@suse.com>
 <1444848835.2220.50.camel@HansenPartnership.com> <5644BEE1.3010208@suse.com>
 <yq1ziyhy38c.fsf@sermon.lab.mkp.net> <5649C79E.9070603@suse.de>
 <564A4EDC.8060805@suse.com> <yq1d1v8tdr3.fsf@sermon.lab.mkp.net>
 <5669F31C.2010409@suse.com> <1449847911.4067.200.camel@localhost.localdomain>
 <566DC3F0.6050206@suse.com> <1450105632.4091.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbbLNP32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 10:29:28 -0500
In-Reply-To: <1450105632.4091.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: emilne@redhat.com, Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>

On 12/14/2015 04:07 PM, Ewan Milne wrote:
> On Sun, 2015-12-13 at 11:16 -0800, Lee Duncan wrote:
>> On 12/11/2015 07:31 AM, Ewan Milne wrote:
>>> On Thu, 2015-12-10 at 13:48 -0800, Lee Duncan wrote:
>>>> On 11/17/2015 03:20 PM, Martin K. Petersen wrote:
>>>>>>>>>> "Lee" =3D=3D Lee Duncan <lduncan@suse.com> writes:
>>>>>
>>>>> Lee> Martin: I will be glad to update the patch, creating a modpr=
obe
>>>>> Lee> parameter as suggested, if you find this acceptable.
>>>>>
>>>>> For development use a module parameter would be fine. But I am co=
ncerned
>>>>> about our support folks that rely on the incrementing host number=
 when
>>>>> analyzing customer log files.
>>>>>
>>>>> Ewan: How do you folks feel about this change?
>>>>>
>>>>
>>>> Ewan?
>>>
>>>
>>> Personally, I think having host numbers that increase essentially
>>> without limit (I think I've seen this with iSCSI sessions) are a
>>> problem, the numbers start to lose meaning for people when they
>>> are not easily recognizable.  Yes, it can help when you're analyzin=
g
>>> a log file, but it seems to me that you would want to track the
>>> host state throughout anyway, so you could just follow the number
>>> as it changes.
>>>
>>> If we change the behavior, we have to change documentation, and
>>> our support people will get calls.  But that's not a reason not
>>> to do it.
>>>
>>> -Ewan
>>>
>>
>> Ewan:
>>
>> Thank you for your reply. I agree with you, which is why I generated
>> this patch.
>>
>> If we *do* make this change, do you think it would be useful to have=
 a
>> module option to revert to the old numbering behavior? I actually th=
ink
>> it would be more confusing to support two behaviors than it would be=
 to
>> bite the bullet (so to speak) and make the change.
>>
>
> I'm not opposed to having the module option if others (Martin?) feel
> they need it, but generally I think it's better to keep things as sim=
ple
> as possible.  So, unless there are strong objections, I would say no.
>
Agreeing with Ewan here.

Martin, I guess it's up to you to tell us whether you absolutely=20
need a module parameter ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
