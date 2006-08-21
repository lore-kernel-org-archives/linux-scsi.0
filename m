From: Paul Nasrat <pnasrat@redhat.com>
Subject: Re: ybin on powerpc
Date: Mon, 21 Aug 2006 06:06:37 -0400
Message-ID: <1156154797.3057.9.camel@enki.eridu>
References: <20060819111919.a60dca49.akpm@osdl.org>
	 <1156024644.5803.73.camel@localhost.localdomain>
	 <20060819182818.bf3ff5bc.akpm@osdl.org>
	 <1156088355.3726.39.camel@mulgrave.il.steeleye.com>
	 <1156110857.5803.82.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55759 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751833AbWHUKGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 06:06:46 -0400
In-Reply-To: <1156110857.5803.82.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>, linux-scsi@vger.kernel.org

On Mon, 2006-08-21 at 07:54 +1000, Benjamin Herrenschmidt wrote:
> > Well ... OK, we shouldn't break things gratuitously.  However,
> > the /proc/scsi interface is deprecated and has been for a while now.
> > 

> > /sys/class/scsi_disk/<x:y:z:i>/device/type
> > 
> > interface which supplies the numeric field value precisely so people
> > shouldn't parse the translated strings.
> > 
> > So, it sounds like yaboot is also in need of modification.
> 
> CC'ed Paul Nasrat who is the current yaboot maintainer
> 
> (Paul, the problem is about a /proc/scsi change breaking ofpath. The
> change will probably be reverted, but still, ofpath should be changed to
> not rely on that crap anymore)

Thanks for the heads up.  I'll look into fixing up ofpath not to
use /proc/scsi.  I'm just in the process of moving countries, so I might
not get a chance to look at for a week or two.

Paul

