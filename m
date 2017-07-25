From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction
 before starting the request) breaks mtx tape library control
Date: Tue, 25 Jul 2017 09:18:52 +0200
Message-ID: <20170725071852.GA3750@linux-x5ow.site>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
 <20170718073747.GD4875@linux-x5ow.site>
 <ufak235abug.fsf@epithumia.math.uh.edu>
 <20170719070335.GC4151@linux-x5ow.site>
 <ufazic0974h.fsf@epithumia.math.uh.edu>
 <20170719083654.GE4151@linux-x5ow.site>
 <20170721164343.GA4086@linux-x5ow.site>
 <ufa7ez18uhn.fsf@epithumia.math.uh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750757AbdGYHSz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 03:18:55 -0400
Content-Disposition: inline
In-Reply-To: <ufa7ez18uhn.fsf@epithumia.math.uh.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason L Tibbitts III <tibbs@math.uh.edu>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com

On Fri, Jul 21, 2017 at 02:23:16PM -0500, Jason L Tibbitts III wrote:
> I can also apply the debugging patch and try again if that would give
> you more useful information.

Yes please (on top of the snippet I've sent you last).

Thanks a lot,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
