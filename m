From: Jens Axboe <axboe@suse.de>
Subject: Re: max GiB written per boot
Date: Wed, 8 Oct 2003 08:44:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031008064438.GO1704@suse.de>
References: <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2> <1065474044.6835.44.camel@patehci2> <1065484077.2899.1.camel@patehci2> <20031007055714.GO972@suse.de> <20031007151225.0a65dcb7.rddunlap@osdl.org> <20031007225708.GK5662@linnie.riede.org> <20031007182714.0eb330c2.rddunlap@osdl.org> <20031007213443.56dd9b58.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:14513 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261328AbTJHGov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2003 02:44:51 -0400
Content-Disposition: inline
In-Reply-To: <20031007213443.56dd9b58.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: wrlk@riede.org, linux-scsi@vger.kernel.org

On Tue, Oct 07 2003, Randy.Dunlap wrote:
> On Tue, 7 Oct 2003 18:27:14 -0700 "Randy.Dunlap" <rddunlap@osdl.org> wrote:
> 
> | On Tue, 7 Oct 2003 18:57:08 -0400 Willem Riede <wrlk@riede.org> wrote:
> | 
> | | On 2003.10.07 18:12, Randy.Dunlap wrote:
> | | > On Tue, 7 Oct 2003 07:57:14 +0200 Jens Axboe <axboe@suse.de> wrote:
> | | > 
> | | > | 
> | | > | Yeah, ide-scsi is broken so you probably shouldn't be using it.
> | | > 
> | | > Is there any sense in trying to repair it?
> | | > I could spend some time on it...
> | | 
> | | Yes, there is IMHO. The Onstream tape driver (osst) depends on ide-scsi
> | | for controlling the IDE version of the drive (DI-30). 
> | | 
> | | Fixing ide-scsi is not trivial, though. I've spent some time on it
> | | on and off and have not been all that successful. The biggest problem
> | | I have is the error recovery -- making ide subsystem error handling
> | | happen when the scsi error handler needs it...
> | 
> | Alan said (a few months back) that he was fixing ide-scsi in 2.4.x-ac
> | and that it should be forward-ported to 2.6.x, so that is where I
> | would begin...  I haven't checked it for progress yet.
> 
> but this hasn't really happened (2.4.x-ac ide-scsi) afaict.

2.4 and 2.6 also uses different error handling for ide-scsi, so it would
probably not have helped you a lot.

-- 
Jens Axboe

