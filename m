From: Jens Axboe <axboe@suse.de>
Subject: Re: ANNOUNCE dc395x update [2.03]
Date: Tue, 13 May 2003 11:46:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030513094640.GT17033@suse.de>
References: <20030423072737.GA5529@twibble.org> <20030513090535.GA5528@twibble.org> <20030513094356.GA7624@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:13487 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263389AbTEMJeB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 05:34:01 -0400
Content-Disposition: inline
In-Reply-To: <20030513094356.GA7624@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: dc395x@twibble.org, linux-scsi@vger.kernel.org

On Tue, May 13 2003, Jamie Lenehan wrote:
> On Tue, May 13, 2003 at 07:05:35PM +1000, Jamie Lenehan wrote:
> > Hi,
> > a new version against 2.5.69 is now up at:
> > 
> >    http://twibble.org/dist/dc395x/
> 
> I've also put up each of the changes as individual patches in the
> dc395x-2.5.69-2.03-split subdirectory:
> 
>  00-irq-crash-fix.patch
>  01-debug-cleanup.patch
>  02-module-cleanup.patch
>  03-kerneldoc-update.patch
>  04-macro-abuse-cleanup.patch
>  05-static-scope-cleanup.patch
>  06-version-2.03.patch
> 
> Is there anyone reading here who would be able to take these changes
> (and hopefully future changes) and push them on to Linus?

That's a bit much to expect, if you're not even sure they apply to
bk-current :)

-- 
Jens Axboe

