From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: cdrecord: Cannot allocate memory. Cannot get SCSI I/O buffer.
Date: Fri, 13 Jan 2006 10:40:41 +0100
Message-ID: <m34q48qxd2.fsf@merlin.emma.line.org>
References: <200601121322.17458.T.Maguin@web.de>
	<200601121352.16717.T.Maguin@web.de>
	<m31wzdv4zi.fsf@merlin.emma.line.org>
	<200601130923.45539.T.Maguin@web.de> <20060113090257.GQ3945@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:49806 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1161515AbWAMJkr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 04:40:47 -0500
In-Reply-To: <20060113090257.GQ3945@suse.de> (Jens Axboe's message of "Fri, 13
	Jan 2006 10:02:57 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Thomas Maguin <T.Maguin@web.de>, linux-scsi@vger.kernel.org

Jens Axboe <axboe@suse.de> writes:

> On Fri, Jan 13 2006, Thomas Maguin wrote:
>> This patch is working with alpha04 on my mashine:
>> http://de.geocities.com/linux_piewie/download/alpha04.txt
>
> So any particular reason you think this is a kernel bug??

Perhaps because <http://de.geocities.com/linux_piewie/download/Readme.txt>

contains this text:

"3. solution for the root problem, not existent for kernel >= 2.6.14-rc2"

OTOH, if 2.6.14 and 2.6.15 are fixed, why would a kernel developer take
interest? 2.6.X isn't "stable" after all... as fiercely discussed on
linux-kernel@ a few weeks ago.

-- 
Matthias Andree
