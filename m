From: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH resend] Allow both megaraid drivers to be built
Date: Mon, 07 Nov 2005 14:14:54 +0000
Message-ID: <436F615E.5090505@gentoo.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD30B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta08-winn.ispmail.ntl.com ([81.103.221.48]:25696 "EHLO
	mta08-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S964823AbVKGOO5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 09:14:57 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD30B@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@engenio.com>

Bagalkote, Sreenivas wrote:
> I also see that both
> drivers register_chrdev() with "megadev" string. There is going to be some
> impact on a stack of applications. I am not sure how Daniel's patch solved
> this.


I didn't spot this - thanks for pointing it out. I guess our only real option 
is to rename one of them. Which one should it be? Which software uses this device?

Daniel
