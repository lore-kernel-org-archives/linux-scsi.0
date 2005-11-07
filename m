From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH resend] Allow both megaraid drivers to be built
Date: Mon, 7 Nov 2005 11:36:11 +0000
Message-ID: <20051107113611.GA9169@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD30D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50852 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751328AbVKGLgO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 06:36:14 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD30D@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, Daniel Drake <dsd@gentoo.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@engenio.com>

On Mon, Nov 07, 2005 at 01:41:13AM -0500, Bagalkote, Sreenivas wrote:
> You mean, you want to allow both drivers to be built and loaded together,
> even though they have overlapping ids?!

We allow to build both, and allow to load both aswell, although the
latter is pretty useless as all devices will be claimed by one
driver already (except for the two ids only supported by the old
driver)
