From: maple@center.hqhost.net
Subject: Re: test9, aic79xx raise errors
Date: Sun, 16 Nov 2003 21:52:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031116195228.GA7310@valinor.localnet>
References: <20031116141128.GA6557@valinor.localnet> <495655408.1069009113@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ua-online.net ([213.179.225.6]:26375 "EHLO center.hqhost.net")
	by vger.kernel.org with ESMTP id S262575AbTKPTxq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2003 14:53:46 -0500
Content-Disposition: inline
In-Reply-To: <495655408.1069009113@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 16, 2003 at 11:58:33AM -0700, Justin T. Gibbs wrote:
> > Hello!
> > 
> > after upgrading kernel on machine to 2.6.0-test9 aic79xx driver 
> > stops working.
> 
> Can you regenerate your report after rebuilding the 2.6.0-test9 kernel
> with the driver source from here?
> 
> http://people.FreeBSD.org/~gibbs/linux/SRC/

it seems now ok, 20 minutes under cat /dev/md3 & cat /dev/sd{a,b} & find
/ not show prevous problem. I guess this code is still not in
mainline? I've tried before latest -bk21 snapshot and error was same.
interestingly, errors appeared only when reads was from two drives
simultaneosly (cat /dev/md3, not cat /dev/sda; cat /dev/sdb)
Anyway, thanks for your great job ;)

        SY, Vladimir
