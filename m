From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: max GiB written per boot
Date: Tue, 7 Oct 2003 18:27:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007182714.0eb330c2.rddunlap@osdl.org>
References: <1064847281.24854.2.camel@patehci2>
	<1064850600.25057.7.camel@patehci2>
	<20030929164654.GS15415@suse.de>
	<1064855570.3184.3.camel@patehci2>
	<1064865746.4262.63.camel@patehci2>
	<1065460336.10804.1.camel@patehci2>
	<1065474044.6835.44.camel@patehci2>
	<1065484077.2899.1.camel@patehci2>
	<20031007055714.GO972@suse.de>
	<20031007151225.0a65dcb7.rddunlap@osdl.org>
	<20031007225708.GK5662@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:7386 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261263AbTJHBfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 21:35:53 -0400
In-Reply-To: <20031007225708.GK5662@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org

On Tue, 7 Oct 2003 18:57:08 -0400 Willem Riede <wrlk@riede.org> wrote:

| On 2003.10.07 18:12, Randy.Dunlap wrote:
| > On Tue, 7 Oct 2003 07:57:14 +0200 Jens Axboe <axboe@suse.de> wrote:
| > 
| > | 
| > | Yeah, ide-scsi is broken so you probably shouldn't be using it.
| > 
| > Is there any sense in trying to repair it?
| > I could spend some time on it...
| 
| Yes, there is IMHO. The Onstream tape driver (osst) depends on ide-scsi
| for controlling the IDE version of the drive (DI-30). 
| 
| Fixing ide-scsi is not trivial, though. I've spent some time on it
| on and off and have not been all that successful. The biggest problem
| I have is the error recovery -- making ide subsystem error handling
| happen when the scsi error handler needs it...

Alan said (a few months back) that he was fixing ide-scsi in 2.4.x-ac
and that it should be forward-ported to 2.6.x, so that is where I
would begin...  I haven't checked it for progress yet.

--
~Randy
