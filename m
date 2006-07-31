From: Jens Axboe <axboe@suse.de>
Subject: Re: cd burning with plextor drives.
Date: Mon, 31 Jul 2006 11:33:58 +0200
Message-ID: <20060731093358.GO14748@suse.de>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de> <Pine.LNX.4.64.0607290953220.4168@g5.osdl.org> <20060729172205.GG16946@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:50276 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932076AbWGaJdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 05:33:46 -0400
Content-Disposition: inline
In-Reply-To: <20060729172205.GG16946@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org

On Sat, Jul 29 2006, Dave Jones wrote:
>  >  - only root can ever be allowed to generate commands that the kernel has 
>  >    no clue what they are doing. NO WAY can we allow a user to generate 
>  >    postentially hardware-changing special commands just because he can 
>  >    access the CD-ROM (ie how would the kernel know that it's not a command 
>  >    that says "rewrite the firmware with something that always reads goatse 
>  >    off the disk"?)
> 
> I had visions of extending verify_command() to be of the form..
> 
> 	if (devicevendor==PLEXTOR) {
> 		safe_for_write(ENABLE_BURN_PROOF);
> 		safe_for_write(ENABLE_FROBNICATOR);
> 	}
> 	etc..

God Dave, that's horrible and completely unmaintanable! The main problem
with the device table right now is that it's completely kernel
controlled, thus burdening everybody with this policy. Lets get it fixed
instead of adding more warts to it.

-- 
Jens Axboe

