From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: [PATCH] Format Unit can take many hours
Date: Tue, 11 May 2004 11:28:22 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040511162822.C46BFDBDB@gherkin.frus.com>
References: <Pine.GSO.4.33.0405110952380.14297-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org-S264826AbUEKQb0@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0405110952380.14297-100000@sweetums.bluetronic.net>
 "from Ricky Beam at May 11, 2004 10:01:55 am"
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Ricky Beam wrote:
> On Tue, 11 May 2004, Kurt Garloff wrote:
> >the timeout for FORMAT_UNIT should be much longer; I've seen 8hrs
> >already (75Gig). I've increased the timeout from 2hrs to 12hrs.
> 
> If you execute a FORMAT_UNIT properly, the timeout is irrelevant.  Set the
> IMMED bit so the command returns as soon as the drive begins processing it.
> Send TEST_UNIT_READY to check the progress.  I'll have to consult the
> spec, but I think support for Immed is required.

Moreover, it simply "feels" wrong to define a constant for something
that isn't...  The quick fix of increasing the timeout doesn't address
the underlying issue of how long a format should take, and as Ricky
implies, that's probably more the concern of the application rather
than the driver.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
