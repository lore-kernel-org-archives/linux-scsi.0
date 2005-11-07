From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: [PATCH resend] Allow both megaraid drivers to be built
Date: Mon, 7 Nov 2005 09:09:53 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD311@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:6029 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932488AbVKGOKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 09:10:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Daniel Drake <dsd@gentoo.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@engenio.com>

>On Mon, 2005-11-07 at 01:41 -0500, Bagalkote, Sreenivas wrote:
>> You mean, you want to allow both drivers to be built and 
>loaded together,
>> even though they have overlapping ids?!
>
>You're not thinking like a distribution.  They want to build one kernel
>for almost every configuration.  There are a few things (SMP, bigmem
>etc) that they're willing to build extra kernels for, but not, I think,
>for old vs new megaraid.  Thus they have to patch this up to build the
>two modules.  By and large, the overlapping ID business is 
>sorted out by
>the installer, although having disjoint IDs is good since the installer
>doesn't have to make a choice.
>
>Can you get this sorted out before 2.6.15, please (so if I believe
>Linus, that's about five weeks)?
>
>Thanks,
>
>James

Yes. I understood now. Thanks for explaining. We will get this in before
2.6.15. Hopefully much sooner.

Regards,
Sreenivas
