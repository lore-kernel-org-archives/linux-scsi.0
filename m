From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] aic7xxx: deinline large or slow functions
Date: Sun, 27 Apr 2008 08:41:31 -0500
Message-ID: <1209303692.3801.2.camel@localhost.localdomain>
References: <200804250432.16943.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44682 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052AbYD0Nlg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2008 09:41:36 -0400
In-Reply-To: <200804250432.16943.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri, 2008-04-25 at 04:32 +0200, Denys Vlasenko wrote:
> Hi Hannes,
> 
> I reworked my patches as you requested.
> 
> The first one (in this mail) was ACKed by you, so it's just a resend.
> 
> Following pathes were not ACKed and are modified.
> Please take a look.
> 
> 
> 
> Deinlines and moves big functions from .h to .c files.
> Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.

The first three won't apply.  It looks like they're splits of this
existing one (at least quilt thinks they're all reverse applyable).  If
there's anything I missed, just re-send against scsi-misc because the
patch stack is a bit deep and convoluted here in aic7xxx.

commit be0d67680d524981dd65c661efe3c9cbd52a684f
Author: Denys Vlasenko <vda.linux@googlemail.com>
Date:   Sun Mar 23 04:41:22 2008 +0100

    [SCSI] aic7xxx, aic79xx: deinline functions
    
    Deinlines and moves big functions from .h to .c files.
    Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.
    
    Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

James



