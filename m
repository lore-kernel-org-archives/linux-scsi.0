From: Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Tue, 26 Oct 2004 12:05:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16765.45289.684525.732044@cargo.ozlabs.ibm.com>
References: <16765.34908.93713.977225@cargo.ozlabs.ibm.com>
	<200410252355.i9PNtlSp025091@falcon10.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:936 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S262117AbUJZEY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 00:24:56 -0400
In-Reply-To: <200410252355.i9PNtlSp025091@falcon10.austin.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@austin.ibm.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org

Doug Maxey writes:

> Oh yes, I am aware.  Just happen to be working on PPC64.  Have been
> writing drivers for this base for several years.  It's the olde LE

For Linux or some other OS?

> device vs BE host.  The transfers are done as a 16 bit quantity, PIO.
> And yes, I understand, "we have always done it this way".  Works well
> when you only have to deal with single arch.

No, we haven't always done it this way on PPC. :)  Various different
ways have been tried over the years and this is the only way that
doesn't suck.

> Possibly I am not making point very well, that one is preserving the
> correct byte order and let the structures reflect to native location.

I can't parse that sentence unambiguously...

> Strings get swapped, 16, 32, and 64 bit fields likewise.  I just missed the 
> LE order that is is being preserved for *some* few fields only.

Strings shouldn't get swapped, or at least, strings should only need
to be swapped on a BE platform if they also need to be swapped on an
LE platform.

> There is not a single reference to byte field in the ATA spec for
> IDENTIFY DEVICE.  It just happens that some of the fields are 8 bits long. Or 
> 32 or 64.

And your point is...  ?

Paul.
