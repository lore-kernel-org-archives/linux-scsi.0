From: Jens Axboe <axboe@suse.de>
Subject: Re: CDROMSUBCHNL. . .
Date: Mon, 27 Sep 2004 18:40:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040927164023.GA30109@suse.de>
References: <007101c4a445$7f150840$0201010a@ankkennedy> <20040927061916.GE2288@suse.de> <001c01c4a4ac$493a8a80$0201010a@ankkennedy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:47051 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266775AbUI0Qkc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 12:40:32 -0400
Content-Disposition: inline
In-Reply-To: <001c01c4a4ac$493a8a80$0201010a@ankkennedy>
List-Id: linux-scsi@vger.kernel.org
To: Andy Kennedy <akennedy@wpid-am.com>
Cc: linux-scsi@vger.kernel.org


(don't top post)

On Mon, Sep 27 2004, Andy Kennedy wrote:
> Thank you so much for your prompt responce.  Could you please tell me
> where I can find this call in the code now, or more specifically how I
> can poll my CDROM for its current state?

The code is in drivers/cdrom/cdrom.c

-- 
Jens Axboe

