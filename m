From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH]indistinguishable devices with broken and unbroken firmware
Date: Wed, 7 Feb 2007 16:16:55 +0100
Message-ID: <200702071616.55419.oneukum@suse.de>
References: <200702071522.39529.oneukum@suse.de> <20070207150555.GA7054@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161356AbXBGPRA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 10:17:00 -0500
In-Reply-To: <20070207150555.GA7054@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

Am Mittwoch, 7. Februar 2007 16:05 schrieb Christoph Hellwig:
> On Wed, Feb 07, 2007 at 03:22:39PM +0100, Oliver Neukum wrote:
> > Hi,
> > 
> > there's a USB mass storage device which exists in two version. One
> > reports the correct size and the other does not. Apart from that they
> > are identical and cannot be told apart. Here's a heuristic based on the
> > empirical finding that drives have even sizes. I know it's ugly, but it fixes
> > an ugly bug.
> 
> Do we really need a second flag?  Alternatively fix_capacity could be
> changed to mean fix size if odd.

Until we learn about devices which really do have an odd number of sectors.
And then we'll have a problem. I'd like to avoid heuristics when we know
for sure.

	Regards
		Oliver
