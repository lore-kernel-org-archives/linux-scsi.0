From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 18:01:27 -0800
Message-ID: <499B6BF7.9090300@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZBRCCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 21:02:12 -0500
In-Reply-To: <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

david@lang.hm wrote:
> On Tue, 17 Feb 2009, Yinghai Lu wrote:
> 
>> david@lang.hm wrote:
>>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>>
>>>> Subject: Re: mpt fusion broken sometime since 2.6.24
>>>>
>>>> On Tue, Feb 17, 2009 at 3:07 PM,  <david@lang.hm> wrote:
>>>>> On Tue, 17 Feb 2009, Matthew Wilcox wrote:
>>>>>
>>>>>> On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
>>>>>>>
>>>>>>> I got a picture of the failed boot at
>>>>>>> http://linux.lang.hm/linux/IMG00052.jpg
>>>>>>
>>>>>> The PCI-MSI line is probably indicative.  Can you try booting with:
>>>>>>
>>>>>> mptbase.mpt_msi_enable_sas=0
>>>>>>
>>>>>> and also send us an lspci -v so we can update the blacklist?
>>>>>
>>>>> is that disabling SAS for this system? if so, that's the wrong thing
>>>>> to do
>>>>> (the drives are SAS)
>>>>>
>>>> it only disable MSI with that mptsas.
>>>> and mptsas will use ioapic routing.
>>>>
>>>> can you post whole bootlog?
>>>
>>> unfortunantly it's booting from CD and the only drives in the system are
>>> the ones that are not being accessed.
>>
>> i mean with kernel before 2.6.24..
> 
> Ok, attached.
> 

so your lsi 1068 is under 8132... need to double check if that chip really support MSI.

YH
