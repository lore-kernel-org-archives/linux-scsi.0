From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] aic7xxx: fix firmware build with O=path
Date: Mon, 3 Jul 2017 17:29:40 -0700
Message-ID: <20170703172940.01c8e1c4@cakuba.netronome.com>
References: <20170629041716.26865-1-jakub.kicinski@netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:33610 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdGDA3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2017 20:29:43 -0400
Received: by mail-pg0-f43.google.com with SMTP id k14so25924037pgr.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Jul 2017 17:29:43 -0700 (PDT)
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

Did anyone have a chance to look at this one?  It would be nice if it
could make its way into 4.13 :)
