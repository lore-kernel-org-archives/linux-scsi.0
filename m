From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: How to resurrect offlined SCSI devices?
Date: Wed, 26 May 2004 12:48:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD4E8A@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28064 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265676AbUEZQtJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 12:49:09 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The LLD Hardware RAID drivers, on the other hand, have exacting
knowledge as to why a device was taken offline.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Wednesday, May 26, 2004 11:11 AM
To: Martin Peschke3
Cc: SCSI Mailing List
Subject: Re: How to resurrect offlined SCSI devices?

On Wed, 2004-05-26 at 10:04, Martin Peschke3 wrote:
> How does the user know that it is safe?
> What if they just try to bring it online? What is happening in the
worst
> case?
> My point is that users probably set the appropriate sys-attribute
> in a "trial and error" fashion, if they think they have got a problem,
> while an lldd might even know better.

The LLD rarely knows why a device was set offline.  The user at least
has the logs to look through.  Use of the state interface is caveat
emptor anyway.

The way it would work in the scenario you outline: some event indicating
that the device is available is to trigger a hotplug which may take the
action to set the device running again.

Setting devices back on line after a failure is a policy decision that
should not be taken by the LLD.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
