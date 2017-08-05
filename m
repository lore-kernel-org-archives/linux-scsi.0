From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression 4.13-rc1] Resume does not work on Lenovo X60t
Date: Sat, 5 Aug 2017 02:30:14 -0700
Message-ID: <20170805093014.GA6511@infradead.org>
References: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37003 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdHEJaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Aug 2017 05:30:16 -0400
Content-Disposition: inline
In-Reply-To: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 03, 2017 at 07:42:15PM +0200, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> Since the merge windows opened for Linux 4.13, I am unable to resume from
> ACPI S3 suspend on a Lenovo X60t. The graphics comes back, but I am unable
> to enter anything, and the system seems to be hung. Magic SysRq keys still
> work though, but powering the system of doesn’t work. The power button also
> does not work.
> 
> Please find the stack trace with Linux 4.13-rc3 captured over the serial
> console below.

Is this really -rc3?  rc3 has a commit to disable block runtime pm
for blk-mq, which is now the default for scsi.  So with -rc1 we've
seen similar reports, but rc3 would be odd and suggest we have further
problems.
