From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Thu, 19 Jul 2007 08:25:16 +0900
Message-ID: <20070719082516W.fujita.tomonori@lab.ntt.co.jp>
References: <469C10F6.3050008@googlemail.com>
	<20070717100921W.fujita.tomonori@lab.ntt.co.jp>
	<469C1E2A.8010508@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44816 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762406AbXGRXZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 19:25:53 -0400
In-Reply-To: <469C1E2A.8010508@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nix.or.die@googlemail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org

From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Tue, 17 Jul 2007 03:40:58 +0200

> FUJITA Tomonori wrote:
> > From: Gabriel C <nix.or.die@googlemail.com>
> > Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
> > Date: Tue, 17 Jul 2007 02:44:38 +0200
> >
> >   
> >> Gabriel C wrote:
> >>     
> >>> Hello,
> >>>
> >>> sdparm and hdparm are broken for me on git (
> >>> abce891a10559343d8ac9f79b46d78afdba63a40 )
> >>>
> >>>
> >>> ~$ sudo hdparm  /dev/sdc
> >>>
> >>> /dev/sdc:
> >>>  BLKROGET failed: Inappropriate ioctl for device
> >>>  BLKRAGET failed: Inappropriate ioctl for device
> >>>  BLKGETSIZE failed: Inappropriate ioctl for device
> >>>
> >>>
> >>> ~$ sudo sdparm  --all /dev/sdc
> >>> unable to access /dev/sdc, ATA disk?
> >>>
> >>>   
> >>>       
> >> Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.

I've not tested this yet (need to find sata drives in my workplace),
but James Bottomley told me that both works for him with bsg enabled.
It might worth trying the latest git tree.
