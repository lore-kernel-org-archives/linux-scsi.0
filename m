From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 5/10] convert st to use scsi_execute_async
Date: Mon, 14 Nov 2005 16:15:42 +0100
Message-ID: <20051114151541.GQ3699@suse.de>
References: <1131444404.23111.66.camel@max> <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local> <43763E94.40406@cs.wisc.edu> <43764861.6030408@cs.wisc.edu> <Pine.LNX.4.63.0511130938570.15153@kai.makisara.local> <437772EA.7080100@redhat.com> <437842DA.80800@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:25138 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751147AbVKNPOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Nov 2005 10:14:48 -0500
Content-Disposition: inline
In-Reply-To: <437842DA.80800@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Doug Ledford <dledford@redhat.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Mon, Nov 14 2005, Douglas Gilbert wrote:
> It might indeed be a bad idea, but there is the odd SCSI
> command that is defined that way. I wonder if any cd/dvd
> drive implements the GET EVENT STATUS NOTIFICATION command
> in asynchronous notification mode (see MMC-4)?

I don't think so, at least I've never heard of it actually being
implemented. The async notification requires TCQ support in the cd/dvd
device, I've never seen that either.

-- 
Jens Axboe

