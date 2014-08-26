From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V5 5/5] add xen pvscsi maintainer
Date: Tue, 26 Aug 2014 16:23:17 +0200
Message-ID: <53FC9855.1090908@suse.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>	<1408354310-6362-6-git-send-email-jgross@suse.com> <53FC962D.8070409@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758341AbaHZOXV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2014 10:23:21 -0400
In-Reply-To: <53FC962D.8070409@citrix.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, JBeulich@suse.com, nab@linux-iscsi.org

On 08/26/2014 04:14 PM, David Vrabel wrote:
> On 18/08/14 10:31, jgross@suse.com wrote:
>> From: Juergen Gross <jgross@suse.com>
>>
>> Add myself as maintainer for the Xen pvSCSI stuff.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   MAINTAINERS | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index aefa948..360f86f 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -10086,6 +10086,14 @@ S:	Supported
>>   F:	drivers/block/xen-blkback/*
>>   F:	drivers/block/xen*
>>
>> +XEN PVSCSI DRIVERS
>> +M:	Juergen Gross <jgross@suse.com>
>> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>
> You should add the appropriate scsi list here
> (linux-scsi@vger.kernel.org I presume?)

Really? Xen PCI and Xen Block susbsystems don't have an according entry.
James, do you have an opinion here? I don't mind adding linux-scsi, but
I think the Xen list is the appropriate one for pvSCSI.

>> +S:	Supported
>> +F:	drivers/scsi/xen-scsifront.c
>> +F:	drivers/xen/xen-scsiback.c
>> +F:	include/xen/interface/io/vscsiif.h
>> +


Juergen
