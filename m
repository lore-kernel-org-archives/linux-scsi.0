From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] add card types to 2.6.2 aacraid driver
Date: Wed, 4 Feb 2004 15:32:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F254C6E@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17610 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264455AbUBDUcF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 15:32:05 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Sa.c, rx.c and rkt.c all support a specific form of drawbridge. Rkt.c is
the same as rx.c except for differing hardware offsets.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Wednesday, February 04, 2004 2:31 PM
To: Mark Haverkamp
Cc: James Bottomley; linux-scsi; Salyzyn, Mark
Subject: Re: [PATCH] add card types to 2.6.2 aacraid driver

On Wed, Feb 04, 2004 at 11:15:28AM -0800, Mark Haverkamp wrote:
> + * Module Name:
> + *  rkt.c
> + *
> + * Abstract: Hardware miniport for Drawbridge specific hardware
functions.
> + *
> + */

rx.c already claims it supports 'Drawbridge'

