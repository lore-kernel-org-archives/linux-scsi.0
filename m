From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 2/5] aacraid: Fix default FIB size
Date: Wed, 30 Nov 2005 14:38:06 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E148@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:44953 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751520AbVK3TiH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:38:07 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] sez:
> > If the adapter has not instructed us otherwise that it can handle a
> > 'large' FIB, then it can handle at most a 2KB FIB.
> this should probably go into 2.6.15

I was willing to accept that most of these patches are for the next
'cycle', but feel that the bios_ptable be rushed in as a bug fix as we
have had reports there.

-- Mark
