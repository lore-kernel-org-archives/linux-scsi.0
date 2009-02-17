From: david@lang.hm
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 15:20:59 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
 <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:44538 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbZBQXVI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 18:21:08 -0500
In-Reply-To: <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

On Tue, 17 Feb 2009, Yinghai Lu wrote:

> Subject: Re: mpt fusion broken sometime since 2.6.24
> 
> On Tue, Feb 17, 2009 at 3:07 PM,  <david@lang.hm> wrote:
>> On Tue, 17 Feb 2009, Matthew Wilcox wrote:
>>
>>> On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
>>>>
>>>> I got a picture of the failed boot at
>>>> http://linux.lang.hm/linux/IMG00052.jpg
>>>
>>> The PCI-MSI line is probably indicative.  Can you try booting with:
>>>
>>> mptbase.mpt_msi_enable_sas=0
>>>
>>> and also send us an lspci -v so we can update the blacklist?
>>
>> is that disabling SAS for this system? if so, that's the wrong thing to do
>> (the drives are SAS)
>>
> it only disable MSI with that mptsas.
> and mptsas will use ioapic routing.
>
> can you post whole bootlog?

unfortunantly it's booting from CD and the only drives in the system are 
the ones that are not being accessed.

David Lang
