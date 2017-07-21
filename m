From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] aic7xxx: fix firmware build with O=path
Date: Fri, 21 Jul 2017 11:51:52 -0700
Message-ID: <20170721115152.352ce0c9@cakuba.netronome.com>
References: <20170719015834.19397-1-jakub.kicinski@netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34438 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdGUSvz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2017 14:51:55 -0400
Received: by mail-pf0-f180.google.com with SMTP id q85so27055883pfq.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2017 11:51:55 -0700 (PDT)
In-Reply-To: <20170719015834.19397-1-jakub.kicinski@netronome.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Tue, 18 Jul 2017 18:58:34 -0700, Jakub Kicinski wrote:
> Building firmware with O=path was apparently broken in aic7 for ever.
> Message of the previous commit to the Makefile (from 2008) mentions
> this unfortunate state of affairs already.  Fix this, mostly to make
> randconfig builds more reliable.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Gentle ping :)  Hannes, are you still maintaining aic7xxx?
