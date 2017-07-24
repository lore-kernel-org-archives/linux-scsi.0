From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] aic7xxx: fix firmware build with O=path
Date: Mon, 24 Jul 2017 14:14:13 -0700
Message-ID: <20170724141413.151dc05d@cakuba.netronome.com>
References: <20170719015834.19397-1-jakub.kicinski@netronome.com>
        <20170721115152.352ce0c9@cakuba.netronome.com>
        <5cf07bda-1bb8-4c71-58ad-d1af492b6c71@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:38521 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932727AbdGXVOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 17:14:21 -0400
Received: by mail-pg0-f50.google.com with SMTP id s4so61997808pgr.5
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 14:14:21 -0700 (PDT)
In-Reply-To: <5cf07bda-1bb8-4c71-58ad-d1af492b6c71@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Mon, 24 Jul 2017 09:00:41 +0200, Hannes Reinecke wrote:
> On 07/21/2017 08:51 PM, Jakub Kicinski wrote:
> > On Tue, 18 Jul 2017 18:58:34 -0700, Jakub Kicinski wrote:  
> >> Building firmware with O=path was apparently broken in aic7 for ever.
> >> Message of the previous commit to the Makefile (from 2008) mentions
> >> this unfortunate state of affairs already.  Fix this, mostly to make
> >> randconfig builds more reliable.
> >>
> >> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>  
> > 
> > Gentle ping :)  Hannes, are you still maintaining aic7xxx?
> >   
> Yes, I do.
> 
> Patch looks reasonable; Kconfig is still black magic to me, though :-)

To me as well, but is seems to work fine in my tests :)

> Reviewed-by: Hannes Reinecke <hare@suse.com>

Thanks!
