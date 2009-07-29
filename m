From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: question about drivers/scsi/aic7xxx/aic79xx_pci.c
Date: Wed, 29 Jul 2009 17:27:00 +0000
Message-ID: <1248888420.3900.82.camel@mulgrave.site>
References: <Pine.LNX.4.64.0907291907190.22045@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57528 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbZG2R1D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 13:27:03 -0400
In-Reply-To: <Pine.LNX.4.64.0907291907190.22045@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

On Wed, 2009-07-29 at 19:09 +0200, Julia Lawall wrote:
> In the file drivers/scsi/aic7xxx/aic79xx_pci.c, the function 
> ahd_aic790X_setup contains the code:
> 
>                 ahd->features |= AHD_RTI|AHD_NEW_IOCELL_OPTS
>                               |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_DELIVERY
>                               |  AHD_BUSFREEREV_BUG;
>                 ahd->bugs |= AHD_LQOOVERRUN_BUG|AHD_EARLY_REQ_BUG;
> 
> Should AHD_BUSFREEREV_BUG be moved from ahd->features to ahd->bugs?

In theory, yes.  In practice, it's harmless in features since the value
is above any feature flag.  The question is whether the B rev boards
actually might work better (or worse) with this, since they've been
operating without it for decades ... do we have any to test?

James


