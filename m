From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Tue, 17 Jul 2007 10:09:21 +0900
Message-ID: <20070717100921W.fujita.tomonori@lab.ntt.co.jp>
References: <469BD9C8.4000808@googlemail.com>
	<469C10F6.3050008@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:40328 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbXGQBJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 21:09:38 -0400
In-Reply-To: <469C10F6.3050008@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nix.or.die@googlemail.com
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org

From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Tue, 17 Jul 2007 02:44:38 +0200

> Gabriel C wrote:
> > Hello,
> >
> > sdparm and hdparm are broken for me on git (
> > abce891a10559343d8ac9f79b46d78afdba63a40 )
> >
> >
> > ~$ sudo hdparm  /dev/sdc
> >
> > /dev/sdc:
> >  BLKROGET failed: Inappropriate ioctl for device
> >  BLKRAGET failed: Inappropriate ioctl for device
> >  BLKGETSIZE failed: Inappropriate ioctl for device
> >
> >
> > ~$ sudo sdparm  --all /dev/sdc
> > unable to access /dev/sdc, ATA disk?
> >
> >   
> 
> Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.

Can you check the major number of your /dev/sdc? I've seen that
/dev/sd* is linked to bsg devices somehow.


> Maybe a bit off topic but it depends on EXPERIMENTAL so why the the menu
> is not telling this ? and why the default is 'y' for it ?
> 
> IMO everything depends on EXPERIMENTAL should
> 
> 1) Tell it is EXPERIMENTAL ( visible to the user in menu ) " Foo New
> stuff ( EXPERIMENTAL ) "
> 2) Should not default to 'y' , is up to the users/admins to set
> EXPERIMENTAL things to Y/M , isn't it ?
> 
> 
> ( PS: there are even defconfigs with EXPERIMENTAL things set to y but
> this is really off topic )

I'll fix it, thanks.
