From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] [SCSI] st.c: Improve sense output
Date: Tue, 7 Nov 2006 21:42:01 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0611072140310.4373@kai.makisara.local>
References: <587723.63610.qm@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kolumbus.fi ([193.229.0.46]:36290 "EHLO mail.kolumbus.fi")
	by vger.kernel.org with ESMTP id S1752463AbWKGTlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 14:41:37 -0500
In-Reply-To: <587723.63610.qm@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 4 Nov 2006, Luben Tuikov wrote:

> >From this:
> st0: Error with sense data: <6>st: Current: sense key: Illegal Request
>     Additional sense: Invalid field in cdb
> 
> To this:
> st0: Current: sense key: Illegal Request
>     Additional sense: Invalid field in cdb
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/scsi/st.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> March 24, 2006!
> 
This is already in the official kernel.

-- 
Kai
