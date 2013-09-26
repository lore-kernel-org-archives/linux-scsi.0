From: Tejun Heo <tj@kernel.org>
Subject: Re: Race condition between "read CFQ stats" and "block device
 shutdown"
Date: Thu, 26 Sep 2013 10:20:44 -0400
Message-ID: <20130926142044.GC3482@htj.dyndns.org>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
 <5226D661.7070301@suse.de>
 <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com>
 <20130904160723.GC26609@mtj.dyndns.org>
 <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com>
 <20130926135443.GC2480@htj.dyndns.org>
 <5244423A.2050107@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58761 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3IZOUr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2013 10:20:47 -0400
Content-Disposition: inline
In-Reply-To: <5244423A.2050107@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

Hey, Hannes.

On Thu, Sep 26, 2013 at 04:18:34PM +0200, Hannes Reinecke wrote:
> However, none of the modern devices should be using this lock
> switching, so I would just ignore it.
> EG SCSI most definitely doesn't use it.

The kernel is crashing from it, so I don't think ignoring is an
acceptable strategy here.

Thanks.

-- 
tejun
