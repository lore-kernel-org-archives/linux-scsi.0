From: James.Smart@Emulex.Com
Subject: RE: [PATCH] [Update] suspending I/Os to a device
Date: Sat, 4 Sep 2004 06:50:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02D943@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60608 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S269875AbUIDKu6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Sep 2004 06:50:58 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, andmike@us.ibm.com

Excellent.  We're also struggling as our management interfaces need an sdev_target to hang about a dozen other attributes on. In fact - the fc_transport attributes today, replicated per lun, are actually sdev_target attributes.

-- james s

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Friday, September 03, 2004 7:24 PM
> To: Smart, James
> Cc: SCSI Mailing List; hch@infradead.org; MikeAnderson
> Subject: Re: [PATCH] [Update] suspending I/Os to a device
> 
> 
> On Fri, 2004-09-03 at 16:31, James.Smart@Emulex.Com wrote:
> > Here's the patch updated based on Christoph's comments.
> 
> I'd still like to see the timer itself housed inside the transport
> class.  Although, it needs to hang off something attached to the
> sdev_target.  Let me see if I can cook up something that 
> would do this.
> 
> James
> 
> 
> 
