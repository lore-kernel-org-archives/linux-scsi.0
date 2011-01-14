From: Hannes Reinecke <hare@suse.de>
Subject: Re: training mpath to discern between SCSI errors
Date: Fri, 14 Jan 2011 08:45:04 +0100
Message-ID: <4D2FFF00.8020702@suse.de>
References: <4C7B984E.4070802@suse.de> <4C7B9F14.9080900@mvista.com> <4C7BA670.2060303@suse.de> <4C7BC5B4.3010707@suse.de> <4CBC00B3.7090603@ce.jp.nec.com> <4CBC35AE.9050002@suse.de> <20101119031149.GA28455@us.ibm.com> <20101130225956.GA8882@redhat.com> <4D0B31B5.101@suse.de> <20101217140605.GA740@redhat.com> <20110114010948.GA21818@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110114010948.GA21818@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, vst@vlnb.net, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, James.Bottomley@suse.de, Sergei Shtylyov <sshtylyov@mvista.com>, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, jack@suse.cz, rwheeler@redhat.com, swhiteho@redhat.com, chris.mason@oracle.com, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/14/2011 02:09 AM, Mike Snitzer wrote:
> On Fri, Dec 17 2010 at  9:06am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
>=20
>> On Fri, Dec 17 2010 at  4:47am -0500,
>> Hannes Reinecke <hare@suse.de> wrote:
>>
>>> On 11/30/2010 11:59 PM, Mike Snitzer wrote:
>>>> Hannes,
>>>>
>>>> Any chance you've had time to fold your proposed logging changes i=
n and
>>>> rebase this patch?  Could you post that updated patch?
>>>>
>>> yes, will be following shortly.
>>>
>>>> I'd like to help see this patch through to inclussion when 2.6.38 =
merge
>>>> window opens.  I can help with further review, testing and develop=
ment.
>>>>
>>> Ok, thanks.
>>
>> I took some steps at furthering your work.  Here is the cover letter=
 to
>> the patches I resently sent to dm-devel:
>> https://www.redhat.com/archives/dm-devel/2010-December/msg00090.html
>>
>> And here are the patches:
>> https://patchwork.kernel.org/patch/384612/
>> https://patchwork.kernel.org/patch/384602/
>> https://patchwork.kernel.org/patch/390882/
>>
>> Please feel free to change these how ever you see fit but your feedb=
ack
>> is really appreciated.
>=20
> Hannes,
>=20
> Any update?  I'd really like to see this work get upstream ASAP.  I'm
> doubtful that is possible for 2.6.38 given the merge window is likely=
 to
> close shortly.
>=20
Sorry for the late answer; the above patches somehow got lost in my
various mail folders :-(

But yes, the patchset looks okay.
=46eel free to add my Acked-by: to last two.

> Regardless, if we could get consensus on this work now and then stage=
 it
> with James that would be great.
>=20
Indeed. Will you resend it to linux-scsi or shall I do it?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
