From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] aic7xxx: fix firmware build with O=path
Date: Tue, 18 Jul 2017 18:35:36 -0700
Message-ID: <20170718183536.35e00175@cakuba.netronome.com>
References: <20170629041716.26865-1-jakub.kicinski@netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34721 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbdGSBfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2017 21:35:39 -0400
Received: by mail-pg0-f51.google.com with SMTP id 123so21960621pgj.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2017 18:35:39 -0700 (PDT)
In-Reply-To: <20170629041716.26865-1-jakub.kicinski@netronome.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, oss-drivers@netronome.com

On Wed, 28 Jun 2017 21:17:16 -0700, Jakub Kicinski wrote:
> Building firmware with O=path was apparently broken in aic7 for ever.
> Message of the previous commit to the Makefile (from 2008) mentions
> this unfortunate state of affairs already.  Fix this, mostly to make
> randconfig builds more reliable.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

I just noticed this patch got marked as "Deferred, archived" in
patchwork.  I'm not entirely sure by whom and why?  Could someone
explain what is the issue?  I would really appreciate if we could 
merge this patch and have this driver not break builds randomly...
