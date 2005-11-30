From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/5] aacraid: simplify non-dasd support
Date: Wed, 30 Nov 2005 14:29:10 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E138@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:37782 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751515AbVK3T3M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:29:12 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:
> NACK on the write filter.  If we can agree on it beeing 
> useful (and I must
> admit I tend to the contrary opinion) it should be done in 
> higher layers.

Our customers won't stand still if we do not write (and read) protect
the raid components. So you propose the introduction of an
sdev->io_protect flag?

> Also why do we need the !sdev->no_uld_attach && !sdev->channel checks?

This is additional insurance, the fact that channel 0 is the array
channel. We do not want the no_uld_attach to be part of the array
channel.

-- Mark Salyzyn
