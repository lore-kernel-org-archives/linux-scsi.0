From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 14:42:40 -0500 (EST)
Message-ID: <20080304.144240.71085240.k-ueda@ct.jp.nec.com>
References: <1204634238.5997.5.camel@homer.simson.net>
	<20080304123939.GM6704@kernel.dk>
	<fqk15l$lgq$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <fqk15l$lgq$1@ger.gmane.org>
Sender: linux-ide-owner@vger.kernel.org
To: w41ter@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Tue, 04 Mar 2008 09:34:56 -0800, walt wrote:
> Jens Axboe wrote:
> > On Tue, Mar 04 2008, Mike Galbraith wrote:
> >> On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
> >>
> >>> Looks excellent to me, has a variant of this been tested as OK by the
> >>> users reporting the regression?
> >> K3b burning seems to be a nogo here.  This is git pulled this morning
> >> though, so it's a somewhat different tree than previously tested fwtw.
> >
> > can you please try git as of this morning without any patches applied,
> > and then pull
> >
> > git://git.kernel.dk/linux-2.6-block.git for-linus
> >
> > into that and see if that works?
> 
> Unfortunately this doesn't fix a problem I've discussed off-list with
> Kiyoshi Ueda, who suggested that I should follow this thread and try
> any patches posted here.
 
I think there was misunderstanding between us.
On off-list, I meant:
  o Your original problem was CD burning, and it looked same problem
    being discussed on this thread, according to this message:

> cdrecord: Warning: controller returns zero sized CD capabilities page.
> cdrecord: Warning: controller returns wrong page 0 for CD capabilities page (2A). 

    So I suggested you to watch this thread and try patches of this
    thread for CD burning problem.

  o The problem of ide_cd_check_ireason looked different from
    CD burning one.
    So I suggested you to report it as a different problem.

Thanks,
Kiyoshi Ueda
