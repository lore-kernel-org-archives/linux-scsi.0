From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Fri, 21 Apr 2006 11:22:12 +0900
Message-ID: <20060421022212.GG25726@htj.dyndns.org>
References: <20060419184916.22608.qmail@web31809.mail.mud.yahoo.com> <4446ECCF.7080000@gmail.com> <20060420130113.GA10415@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.177]:26340 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750743AbWDUCWD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 22:22:03 -0400
Received: by pproxy.gmail.com with SMTP id i49so373689pye
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2006 19:22:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20060420130113.GA10415@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: ltuikov@yahoo.com, Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 20, 2006 at 02:01:13PM +0100, Christoph Hellwig wrote:
> On Thu, Apr 20, 2006 at 11:07:11AM +0900, Tejun Heo wrote:
> > James and Jeff, any opinion on this matter?
> 
> I think you hack looks okayish.  But I want to see the whole libata
> ->eh_strategy_handler first.

Thanks, Christoph.

I'll CC you on the next post of libata EH patches.

-- 
tejun
