From: Willem Riede <wrlk@riede.org>
Subject: Re: max GiB written per boot
Date: Tue, 7 Oct 2003 18:57:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007225708.GK5662@linnie.riede.org>
References: <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2> <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2> <1065474044.6835.44.camel@patehci2> <1065484077.2899.1.camel@patehci2> <20031007055714.GO972@suse.de> <20031007151225.0a65dcb7.rddunlap@osdl.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:29411 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262929AbTJGWva (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 18:51:30 -0400
Content-Disposition: inline
In-Reply-To: <20031007151225.0a65dcb7.rddunlap@osdl.org> (from rddunlap@osdl.org on Tue, Oct 07, 2003 at 18:12:25 -0400)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.10.07 18:12, Randy.Dunlap wrote:
> On Tue, 7 Oct 2003 07:57:14 +0200 Jens Axboe <axboe@suse.de> wrote:
> 
> | 
> | Yeah, ide-scsi is broken so you probably shouldn't be using it.
> 
> Is there any sense in trying to repair it?
> I could spend some time on it...

Yes, there is IMHO. The Onstream tape driver (osst) depends on ide-scsi
for controlling the IDE version of the drive (DI-30). 

Fixing ide-scsi is not trivial, though. I've spent some time on it
on and off and have not been all that successful. The biggest problem
I have is the error recovery -- making ide subsystem error handling
happen when the scsi error handler needs it...

Regards, Willem Riede.
