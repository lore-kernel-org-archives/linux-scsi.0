From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 02/13] scsi: don't turn on REQ_SPECIAL on sgtable allocation failure.
Date: Fri, 1 Apr 2005 14:14:42 +0900
Message-ID: <20050401051442.GC11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.C0E52845@htj.dyndns.org> <1112291625.5619.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.195]:9464 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262626AbVDAFOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 00:14:48 -0500
Received: by wproxy.gmail.com with SMTP id 68so860603wri
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 21:14:48 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1112291625.5619.21.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

 Hello, James.

On Thu, Mar 31, 2005 at 11:53:45AM -0600, James Bottomley wrote:
> On Thu, 2005-03-31 at 18:08 +0900, Tejun Heo wrote:
> > 	Don't turn on REQ_SPECIAL on sgtable allocation failure.  This
> > 	was the last place where REQ_SPECIAL is turned on for normal
> > 	requests.
> 
> If you do this, you'll leak a command every time the sgtable allocation
> fails.

 AFAICT, not really.  We don't allocate another scsi_cmnd for normal
requests if req->special != NULL.

 Thanks.

-- 
tejun

