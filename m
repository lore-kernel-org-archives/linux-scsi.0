From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V5 5/5] add xen pvscsi maintainer
Date: Wed, 27 Aug 2014 05:50:41 +0200
Message-ID: <53FD5591.2060308@suse.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>	<1408354310-6362-6-git-send-email-jgross@suse.com>	<53FC962D.8070409@citrix.com> <53FC9855.1090908@suse.com> <1409071033.3812.13.camel@jarvis.lan> <53FCBFF0.7050307@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53FCBFF0.7050307@citrix.com>
Sender: target-devel-owner@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, nab@linux-iscsi.org, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

On 08/26/2014 07:12 PM, David Vrabel wrote:
> On 26/08/14 17:37, James Bottomley wrote:
>> On Tue, 2014-08-26 at 16:23 +0200, Juergen Gross wrote:
>>> On 08/26/2014 04:14 PM, David Vrabel wrote:
>>>> On 18/08/14 10:31, jgross@suse.com wrote:
>>>>> From: Juergen Gross <jgross@suse.com>
>>>>>
>>>>> Add myself as maintainer for the Xen pvSCSI stuff.
>>>>>
>>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>>> ---
>>>>>    MAINTAINERS | 8 ++++++++
>>>>>    1 file changed, 8 insertions(+)
>>>>>
>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>> index aefa948..360f86f 100644
>>>>> --- a/MAINTAINERS
>>>>> +++ b/MAINTAINERS
>>>>> @@ -10086,6 +10086,14 @@ S:	Supported
>>>>>    F:	drivers/block/xen-blkback/*
>>>>>    F:	drivers/block/xen*
>>>>>
>>>>> +XEN PVSCSI DRIVERS
>>>>> +M:	Juergen Gross <jgross@suse.com>
>>>>> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>>>>
>>>> You should add the appropriate scsi list here
>>>> (linux-scsi@vger.kernel.org I presume?)
>>>
>>> Really? Xen PCI and Xen Block susbsystems don't have an according entry.
>>> James, do you have an opinion here? I don't mind adding linux-scsi, but
>>> I think the Xen list is the appropriate one for pvSCSI.
>>
>> It depends how you want to handle this, but the patches have to come on
>> to the SCSI list somehow.  You can have them directly posted by adding
>> the list, or you can repost them yourselves.  It's a question of
>> workflow.
>
> I think these drivers have had (and will continue to have) the most
> useful review from scsi people.  I think posting directly (hence
> earlier) to linux-scsi will ensure the best quality.
>
> This is the workflow used for the Xen network drivers and I think it
> works well.

Okay, I'll add the scsi list.

Juergen
