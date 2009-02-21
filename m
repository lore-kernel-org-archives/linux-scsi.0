From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sat, 21 Feb 2009 00:31:43 -0800
Message-ID: <86802c440902210031j698403cev2147e72a61e17194@mail.gmail.com>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	 <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>
	 <499B724A.2040408@kernel.org>
	 <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
	 <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>
	 <499B774C.5010705@kernel.org>
	 <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
	 <499B9129.50104@kernel.org> <499CD466.1060900@gmail.com>
	 <m1fxi82pq0.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:50227 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZBUIbo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2009 03:31:44 -0500
In-Reply-To: <m1fxi82pq0.fsf@fess.ebiederm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

On Fri, Feb 20, 2009 at 11:50 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Robert Hancock <hancockrwd@gmail.com> writes:
>>
>> Is there a reason why we can't just enable the HT MSI mapping for any bridge
>> device that has that PCI capability and is underneath an HT bridge?
>
> The code should be under CONFIG_X86 because the rules for enabling HT MSI mappings
> are different for other architectures.  But otherwise I can't think of a reason.

move to arch/x86/pci/fixup.c?

it seems some other arch do support HT ... powerpc, mips?

>
>> Essentially
>> the code for nv_msi_ht_cap_quirk could potentially be applied to all bridges as
>> it is currently for NVIDIA and ALi bridges..
>
> Sounds like it would save a fair amount of grief.

it seems there is some difference.
8132 is some kind of HT tunnel, and the bridge is acctually pci-x bridge.

mcp55 and ck804: is HT end device with several pcie bridges.

also 8131 has problem with HT MSI?

YH
