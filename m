From: Jens Axboe <axboe@suse.de>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 13:12:40 +0200
Message-ID: <20060729111240.GG13095@suse.de>
References: <20060729045249.GA23398@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:42767 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1422754AbWG2LNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 07:13:53 -0400
Content-Disposition: inline
In-Reply-To: <20060729045249.GA23398@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org, torvalds@osdl.org

On Sat, Jul 29 2006, Dave Jones wrote:
> AFAICT, this has been broken since the code to sanitise scsi commands
> was added circa 2.6.8 or so.
> 
> It seems cdrecord tries to send some vendor specific commands to Plextor
> drives, and fails miserably as can be seen here..
> https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=124267
> 
> I'm not that familiar with this code, but would adding exceptions
> on a per-vendor basis in sg_allow_access() be the way forward here?
> 
> If not, what is the right answer ?

I'd greatly prefer just ripping the entire command access table out, it
was a mistake to begin with and still just a horrible solution.

In fact, I think we should decide soon what to do about it. At the
storage summit, there was general consensus on just killing it as well.

-- 
Jens Axboe

