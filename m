From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: [PATCH] SCSI: update Kconfig help text to indicate SCSI core's widespread usage
Date: Fri, 14 Sep 2007 16:21:02 -0400
Message-ID: <20070914202102.GE5386@csclub.uwaterloo.ca>
References: <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <20070914185434.GD5386@csclub.uwaterloo.ca> <tkrat.e1d898d6a272d681@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46294 "EHLO
	caffeine.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbXINUVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 16:21:04 -0400
Content-Disposition: inline
In-Reply-To: <tkrat.e1d898d6a272d681@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 10:14:16PM +0200, Stefan Richter wrote:
> -	  If you want to use a SCSI or FireWire CD-ROM under Linux,
> +	  If you want to use a SCSI, SATA, USB or FireWire CD-ROM or DVD-ROM,
>  	  say Y and read the SCSI-HOWTO and the CDROM-HOWTO at
>  	  <http://www.tldp.org/docs.html#howto>. Also make sure to say
>  	  Y or M to "ISO 9660 CD-ROM file system support" later.

How about that one for libata driven PATA CDROM drives?  Could replace
SATA with libata, or something similar.

--
Len Sorensen
