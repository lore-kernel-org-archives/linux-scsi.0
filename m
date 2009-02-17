From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 15:20:28 -0800
Message-ID: <86802c440902171520r4eb9c94ev416a54c540cf60c1@mail.gmail.com>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	 <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>
	 <20090217230050.GG16841@parisc-linux.org>
	 <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
	 <20090217231101.GH16841@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:54779 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZBQXU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 18:20:29 -0500
In-Reply-To: <20090217231101.GH16841@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

On Tue, Feb 17, 2009 at 3:11 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Feb 17, 2009 at 03:07:26PM -0800, david@lang.hm wrote:
>> >mptbase.mpt_msi_enable_sas=0
>>
>> is that disabling SAS for this system? if so, that's the wrong thing to do
>> (the drives are SAS)
>
> no, it's disabling msi for sas controllers.
>
> nb, I said this patch (e382968ba618e016ff7922dff9a6140c2f9108c8) was
> the wrong way to go about getting MSI working.

yes. that patch really does disable the mptsas with MSI.

http://lkml.org/lkml/2009/2/6/375
it should get into 2.6.29...

YH
