From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_dh_alua: add missing transitioning state support
Date: Thu, 23 Sep 2010 14:53:46 -0400
Message-ID: <20100923185346.GA12218@redhat.com>
References: <4C7B7B9E.3020002@suse.de>
 <20100831151129.GA18855@redhat.com>
 <20100920153539.GA28284@redhat.com>
 <4C98180F.1020707@cs.wisc.edu>
 <20100921193320.GA5110@redhat.com>
 <4C992026.5080402@cs.wisc.edu>
 <4C99D6B3.3090003@suse.de>
 <20100922122901.GA10218@redhat.com>
 <4C9AFEA7.50706@suse.de>
 <20100923134438.GA17966@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab0IWSxy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 14:53:54 -0400
Content-Disposition: inline
In-Reply-To: <20100923134438.GA17966@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Thu, Sep 23 2010 at  9:44am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> > From db02ba3c33a4a1dbfcdc4de1b73e378f7b3d8925 Mon Sep 17 00:00:00 2001
> > From: Hannes Reinecke <hare@suse.de>
> > Date: Wed, 22 Sep 2010 12:09:07 +0200
> > Subject: [PATCH] scsi_dh_alua: Handle all states correctly
> > 
> > For ALUA we should be handling all states, independent of whether
> > is explicit or implicit. For 'Transitioning' we should be retry
> > for a certain amount of time; after that we're setting the port
> > to 'Standby' and return SCSI_DH_RETRY to signal upper layers
> > a retry is in order here.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> Acked-by: Mike Snitzer <snitzer@redhat.com>

BTW, we're missing the include for the msleep() introduced in this
patch:

#include <linux/delay.h>

James, any chance you'd add that?

Or should Hannes send a revised patch?

Mike
