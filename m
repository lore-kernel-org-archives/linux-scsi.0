From: Jens Axboe <axboe@suse.de>
Subject: Re: CDROMREADAUDIO ioctl EINVAL error with 2.6.1; it works with 2.4.21
Date: Tue, 3 Feb 2004 10:08:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040203090834.GY11683@suse.de>
References: <4019A35E.5050000@pianodisc.com> <20040130111105.GM11683@suse.de> <401EA077.3080309@pianodisc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:52649 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265955AbUBCJIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2004 04:08:38 -0500
Content-Disposition: inline
In-Reply-To: <401EA077.3080309@pianodisc.com>
List-Id: linux-scsi@vger.kernel.org
To: Steve deRosier <derosier@pianodisc.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 02 2004, Steve deRosier wrote:
> Jens,
> 
> Thanks.  I tried it out and it does indeed fix the problem.  Unfortunately 
> it mucks up my timing calculations for my MIDI and audio output, but that's 
> now a bug for me.  Thanks for the speedy help.

Yeah I know, that's why I am changing it to CD_FRAMES limit instead.
Just takes a little while for things to catch up (sent it to Andrew
right after your first mail, so it will probably be in next -mm then in
Linus a week or so later).

-- 
Jens Axboe

