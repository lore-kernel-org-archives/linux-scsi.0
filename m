From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
Date: Thu, 4 Oct 2007 13:00:16 +0200
Message-ID: <20071004110016.GD5711@kernel.dk>
References: <20071004084651L.fujita.tomonori@lab.ntt.co.jp> <20071004072834.GD5236@kernel.dk> <20071004104858.GF10852@stusta.de> <20071004195552G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:10882 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbXJDK6m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Oct 2007 06:58:42 -0400
Content-Disposition: inline
In-Reply-To: <20071004195552G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bunk@kernel.org, Sumant.Patro@lsi.com, James.Bottomley@SteelEye.com, bwindle@fint.org, linux-kernel@vger.kernel.org, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Thu, Oct 04 2007, FUJITA Tomonori wrote:
> On Thu, 4 Oct 2007 12:48:58 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Thu, Oct 04, 2007 at 09:28:34AM +0200, Jens Axboe wrote:
> > >...
> > > Tomo, this is the patch I added.
> > 
> > Please excuse my comment in case this was already clear:
> > 
> > You are aware that this bug is a regression in 2.6.23-rc and the patch 
> > should therefore go to Linus ASAP and not after the release of 2.6.23?
> 
> Oops, you are right. This should go via scsi-rc-fixes tree ASAP.

Irk, the scsi accessor stuff is already in, I forgot and thought it was
pending for 2.6.24. So rush the patch upstream please!

-- 
Jens Axboe

