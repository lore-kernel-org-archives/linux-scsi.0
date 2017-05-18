From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH blktests 0/3] Add SCSI generic test group
Date: Thu, 18 May 2017 15:46:45 -0700
Message-ID: <20170518224645.GD26871@vader.DHCP.thefacebook.com>
References: <cover.1495109149.git.jthumshirn@suse.de>
 <20170518131928.GA26060@infradead.org>
 <94150f71-5bbb-2ee2-b7d4-d0f2f7124684@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33237 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755100AbdERWqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 18:46:48 -0400
Received: by mail-pg0-f53.google.com with SMTP id u187so29194836pgb.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 15:46:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <94150f71-5bbb-2ee2-b7d4-d0f2f7124684@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Thu, May 18, 2017 at 03:29:45PM +0200, Johannes Thumshirn wrote:
> On 05/18/2017 03:19 PM, Christoph Hellwig wrote:
> > All SG_IO test should also apply to block device nodes that support
> > the ioctl..
> > 
> 
> But these are not necessarily SG_IO tests, are they?
> 
> The test included is doesn't hit the SG_IO path in the sg driver, but
> the sg_read path.
> 
> Of cause we can make a generic sg_io tool but IMHO it's quite convenient
> to just throw in the reproducers we get.
> 
> And as it exercises the /dev/sg character device I decided to make a new
> group.
> 
> 	Johannes

Looking at this some more, it seems like the syzkaller reproducer always
bangs on /dev/sg0. How hard would it be to adapt it to run on the sg
device for every test device instead?
