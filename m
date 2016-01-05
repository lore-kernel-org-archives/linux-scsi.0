From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on
 ppc64 host
Date: Tue, 5 Jan 2016 19:57:35 +0800
Message-ID: <20160105115735.GA21068@eguan.usersys.redhat.com>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34139 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbcAEL6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2016 06:58:41 -0500
Received: by mail-pf0-f172.google.com with SMTP id e65so166470256pfe.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2016 03:58:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151211115340.GB19209@eguan.usersys.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

On Fri, Dec 11, 2015 at 07:53:40PM +0800, Eryu Guan wrote:
> Hi,
> 
> I saw this kernel BUG_ON on 4.4-rc4 kernel, and this can be reproduced
> easily on ppc64 host by:
> 
> modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=256
> 
> And I bisected to this commit
> 
> 	commit ca369d51b3e1649be4a72addd6d6a168cfb3f537
> 	Author: Martin K. Petersen <martin.petersen@oracle.com>
> 	Date:   Fri Nov 13 16:46:48 2015 -0500
> 
> 	    block/sd: Fix device-imposed transfer length limits
> 
> I confirmed by reverting this commit on top of 4.4-rc4 kernel and test
> passed.

Hi,

Any updates on this? It's still reproducible with 4.4-rc8 kernel, and
still blocks some of my tests :)

Thanks,
Eryu
