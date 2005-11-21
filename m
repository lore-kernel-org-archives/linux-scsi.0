From: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH 1/1] megaraid_legacy: removed PCI ID overlap from the
 driv	er
Date: Mon, 21 Nov 2005 12:58:14 +0000
Message-ID: <4381C466.5020304@gentoo.org>
References: <0E3FA95632D6D047BA649F95DAB60E5703662C41@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta09-winn.ispmail.ntl.com ([81.103.221.49]:55247 "EHLO
	mta09-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S932290AbVKUM6S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 07:58:18 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703662C41@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>

Ju, Seokmann wrote:
> Hi,
> 
> This patch fixes 
> 	- PCI ID overlap issue 
> 	- node name changed to 'megaraid_legacy'
> I hope this patch addresses concerns brought by Daniel Drake.
> The patch created against James's linux/kernel/git/jejb/scsi-misc-2.6.git/
> tree.
> Please review it and any comments would be appreciated.

Both these patches look good to me.

Thanks for following this up.

Daniel
