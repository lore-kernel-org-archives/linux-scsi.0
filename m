From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Fwd: 2TB USB hard drive for backing up
Date: Tue, 22 Jan 2013 11:58:06 +0000
Message-ID: <1358855886.2387.35.camel@dabdike.int.hansenpartnership.com>
References: <jmunm9$90r$2@speranza.aioe.org>
	 <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com>
	 <1358852735.2387.34.camel@dabdike.int.hansenpartnership.com>
	 <2472909.UxI1EnLDV4@linux-5eaq.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51636 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723Ab3AVL6N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2013 06:58:13 -0500
In-Reply-To: <2472909.UxI1EnLDV4@linux-5eaq.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Ellwood Blues <elwood.blue@gmail.com>, linux-efi@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Tue, 2013-01-22 at 12:49 +0100, Oliver Neukum wrote:
> On Tuesday 22 January 2013 11:05:35 James Bottomley wrote:
> > > May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0: [sdf]
> > > 1565565872 512-byte logical blocks: (801 GB/746 GiB)
> > 
> > This looks like a wrap around of your actual size.  This appears to
> > indicate the device isn't replying correctly to READ CAPACITY.  The
> > conventional return from READ CAPACITY should be -1 which would trigger
> > us to retry with READ CAPACITY(16).
> 
> What can we do? The answer the device is giving is quite ordinary.
> Do we need another quirk and an associated flag?

Well, firstly we have to verify the theory, but if it pans out,
probably ... this time a force RC16 flag.  Unless there's any other way
to tell that we have this problem?

James


