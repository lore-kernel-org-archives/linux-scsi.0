From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 12:57:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717105718.GG833@suse.de>
References: <20030716124549.GX833@suse.de> <1058360162.1850.15.camel@mulgrave> <20030716132036.GB833@suse.de> <1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de> <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de> <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de> <3F167F98.60006@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:62625 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S271406AbTGQKm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 06:42:27 -0400
Content-Disposition: inline
In-Reply-To: <3F167F98.60006@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, markh@osdl.org, cliffw@osdl.org, linux-scsi@vger.kernel.org

On Thu, Jul 17 2003, Nick Piggin wrote:
> If the requeue were seperate to the add, it would simply be a call
> to as_completed_request in as-iosched.c.

Out of laziness, or what? Just the accounting, not the actual completion
bits.

-- 
Jens Axboe

