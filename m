From: "David S. Miller" <davem@davemloft.net>
Subject: Re: iomapping a big endian area
Date: Sat, 2 Apr 2005 20:08:58 -0800
Message-ID: <20050402200858.37347bec.davem@davemloft.net>
References: <1112475134.5786.29.camel@mulgrave>
	<20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk>
	<20050402183805.20a0cf49.davem@davemloft.net>
	<20050403031000.GC24234@parcelfarce.linux.theplanet.co.uk>
	<1112499639.5786.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-174.sfo1.dsl.speakeasy.net ([216.27.180.174]:12933
	"EHLO cheetah.davemloft.net") by vger.kernel.org with ESMTP
	id S261454AbVDCEJ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2005 23:09:28 -0500
In-Reply-To: <1112499639.5786.34.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 02 Apr 2005 21:40:39 -0600
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> After all, the driver must know the card is BE, so the routines that
> make use of the feature are easily coded into the card, so there's no
> real need to add it to the iomem cookie.

Yes, I don't believe it needs to be in the cookie either.

> Did anyone have a preference for the API?  I was thinking
> ioread32_native, but ioread32be is fine too.

I think doing foo{be,le}{8,16,32}() would be consistent with
our byteorder.h interface names.
