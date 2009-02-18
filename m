From: david@lang.hm
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 10:18:20 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902181014330.26625@asgard.lang.hm>
References: <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
 <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org> <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>
 <20090218100448.7f7c5b86.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20090218100448.7f7c5b86.akpm@linux-foundation.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 18 Feb 2009, Andrew Morton wrote:

> Subject: Re: [PATCH] pci: enable MSI on 8132
> 
> On Wed, 18 Feb 2009 04:27:28 -0800 (PST) david@lang.hm wrote:
>
>> On Wed, 18 Feb 2009, Matthew Wilcox wrote:
>>
>>> On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
>>>>
>>>> Impact: workaround BIOS that doesn't enable that bit
>>>>
>>>> David reported that LSI sas doesn't work with MSI.
>>>> it turns out that BIOS doesn't enable HT MSI
>>>> 8132 does support HT MSI.
>>>> add quirk to enable it
>>>>
>>>> Reported-by: David Lang <david@lang.hm>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
>>>
>>> Jesse, I think this should go into Linus' tree sooner rather than later.
>>
>> please forward to -stable as well. this is a regression since the card
>> works with older kernels.
>>
>
> Which kernel version introduced the regression?

I'm not sure. I know that 2.6.24 Debian EThch-and-a-half worked, 2.6.27+ 
failed. how critical is it to narrow down exactly where the problem crept 
in?

Yinghai Lu, Matthew Wilcox,
   can either of you identify where the problem would have appeared?

> Do we not need mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch as
> well, to fix this regression?

I don't know. the current -git kernel fails, but with these two patches 
works. I haven't tried backporting these patches (if there are any changes 
at all needed I probably won't be able to do it)

David Lang

> I sent mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch to the
> maintainers a week ago and it was ignored, along with everything else.
> If this happens again I shall merge it under my own cognisance, along
> with everything else.
>
>
