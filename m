From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4 v2] block: Fixes for bdi handling
Date: Thu, 9 Mar 2017 09:41:01 -0700
Message-ID: <7177cebf-8a9b-10d4-e991-5e43f4303ffc@kernel.dk>
References: <20170309101624.25901-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:36907 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753918AbdCIQly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2017 11:41:54 -0500
Received: by mail-it0-f50.google.com with SMTP id g138so70128786itb.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2017 08:41:04 -0800 (PST)
In-Reply-To: <20170309101624.25901-1-jack@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org

On 03/09/2017 03:16 AM, Jan Kara wrote:
> Hi!
> 
> this is a second revision of the series fixing the most urgent bugs that were
> introduced by commit 165a5e22fafb "block: Move bdi_unregister() to
> del_gendisk()" and by 0dba1314d4f8 "scsi, block: fix duplicate bdi name
> registration crashes".  In fact before these commits we had a different set of
> problems in the code but they were less visible :).

It was rather urgent to get those fixes in, so I already sent them off. Not a
huge deal, but it would be nice to add the atomic init fix as a separate patch
later on.

-- 
Jens Axboe
