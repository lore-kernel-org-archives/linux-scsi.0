From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 13:29:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717112909.GL833@suse.de>
References: <20030716170456.GK833@suse.de> <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de> <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de> <3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de> <3F1683F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de> <3F168846.90902@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:47786 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S271426AbTGQLOQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 07:14:16 -0400
Content-Disposition: inline
In-Reply-To: <3F168846.90902@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: markh@osdl.org, Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, cliffw@osdl.org, linux-scsi@vger.kernel.org

On Thu, Jul 17 2003, Nick Piggin wrote:
> 
> 
> Jens Axboe wrote:
> 
> >On Thu, Jul 17 2003, Nick Piggin wrote:
> >
> 
> snip
> 
> >>
> >>Jens, this is exactly right. Would you be OK with this? Everyone else?
> >>
> >
> >I'm happy with it.
> >
> 
> OK, Mark, please try the following patch in combination with Jens'
> previous. Untested due to not being able to exercise the requeue
> path, so it might blow up.

Looks good Nick! You can discard my comments from the previous mail.

-- 
Jens Axboe

