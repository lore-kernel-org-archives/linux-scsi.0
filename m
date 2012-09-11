From: Dan Williams <djbw@fb.com>
Subject: Re: 4 isci patches from isci-for-3.6 tag?
Date: Tue, 11 Sep 2012 11:43:28 -0700
Message-ID: <CAA9_cmeBP26iyFR_4wJiFg+vaqv8xUm3ngq09Ur_=izCHyPOJg@mail.gmail.com>
References: <D9FFE20C522965449E182ACE73889AEB19007E46@IRSMSX102.ger.corp.intel.com>
	<1347367288.2951.27.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51645 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab2IKSnf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Sep 2012 14:43:35 -0400
Received: by lagy9 with SMTP id y9so543261lag.19
        for <linux-scsi@vger.kernel.org>; Tue, 11 Sep 2012 11:43:34 -0700 (PDT)
In-Reply-To: <1347367288.2951.27.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>

On Tue, Sep 11, 2012 at 5:41 AM, James Bottomley
<jbottomley@parallels.com> wrote:
> On Tue, 2012-09-11 at 12:29 +0000, Dorau, Lukasz wrote:
>> Hi James
>>
>> What are you going to do with the following four ISCI patches from isci-for-3.6 tag?:
>>
>> 6734092e66011def7875bd67beef889d0fee1cc9    isci: add a couple __iomem annotations
>> 67787c330762eb884bf8c169fe942263d55ec162    isci: make function declaration match implementation
>> a90037560588e51b3e98b49537799137cbfda17d  isci: fix COMSAS negation timout workaround for WD SAS drives
>> 6d70a74ffd616073a68ae0974d98819bfa8e6da6   isci: fix isci_pci_probe() generates warning on efi failure path
>> (by: Dan Carpenter, Dave Maurer and Dan Williams)
>>
>> We hope they will get to the upstream kernel soon...
>
> They were tagged for -next and managed to miss the merge window because
> it closed early.

Just a one-off growing pain of the new process:

http://marc.info/?l=linux-scsi&m=134327946218188&w=2

> I can't really do anything with them since they're
> part of a signed pull, unless someone takes the tree apart and redoes
> them as individual patches.
>
> None of them looks like -rc candidates, though because they don't seem
> to have user visible bugs.

They merge fine with latest upstream, do they need to be rebased as patches?

--
Dan
