From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH V5 5/5] add xen pvscsi maintainer
Date: Tue, 26 Aug 2014 18:12:16 +0100
Message-ID: <53FCBFF0.7050307@citrix.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>	<1408354310-6362-6-git-send-email-jgross@suse.com>	<53FC962D.8070409@citrix.com> <53FC9855.1090908@suse.com> <1409071033.3812.13.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:26701 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaHZRMq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 13:12:46 -0400
In-Reply-To: <1409071033.3812.13.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Juergen Gross <jgross@suse.com>
Cc: linux-scsi@vger.kernel.org, nab@linux-iscsi.org, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>, JBeulich@suse.com

On 26/08/14 17:37, James Bottomley wrote:
> On Tue, 2014-08-26 at 16:23 +0200, Juergen Gross wrote:
>> On 08/26/2014 04:14 PM, David Vrabel wrote:
>>> On 18/08/14 10:31, jgross@suse.com wrote:
>>>> From: Juergen Gross <jgross@suse.com>
>>>>
>>>> Add myself as maintainer for the Xen pvSCSI stuff.
>>>>
>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>> ---
>>>>   MAINTAINERS | 8 ++++++++
>>>>   1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index aefa948..360f86f 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -10086,6 +10086,14 @@ S:	Supported
>>>>   F:	drivers/block/xen-blkback/*
>>>>   F:	drivers/block/xen*
>>>>
>>>> +XEN PVSCSI DRIVERS
>>>> +M:	Juergen Gross <jgross@suse.com>
>>>> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>>>
>>> You should add the appropriate scsi list here
>>> (linux-scsi@vger.kernel.org I presume?)
>>
>> Really? Xen PCI and Xen Block susbsystems don't have an according entry.
>> James, do you have an opinion here? I don't mind adding linux-scsi, but
>> I think the Xen list is the appropriate one for pvSCSI.
> 
> It depends how you want to handle this, but the patches have to come on
> to the SCSI list somehow.  You can have them directly posted by adding
> the list, or you can repost them yourselves.  It's a question of
> workflow.

I think these drivers have had (and will continue to have) the most
useful review from scsi people.  I think posting directly (hence
earlier) to linux-scsi will ensure the best quality.

This is the workflow used for the Xen network drivers and I think it
works well.

David
