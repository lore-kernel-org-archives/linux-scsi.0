From: david@lang.hm
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 04:27:28 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>
References: <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
 <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20090218122137.GJ16841@parisc-linux.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 18 Feb 2009, Matthew Wilcox wrote:

> On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
>>
>> Impact: workaround BIOS that doesn't enable that bit
>>
>> David reported that LSI sas doesn't work with MSI.
>> it turns out that BIOS doesn't enable HT MSI
>> 8132 does support HT MSI.
>> add quirk to enable it
>>
>> Reported-by: David Lang <david@lang.hm>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
>
> Jesse, I think this should go into Linus' tree sooner rather than later.

please forward to -stable as well. this is a regression since the card 
works with older kernels.

David Lang
