From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 05/13] scsi: remove a timer race from scsi_queue_insert() and cleanup timer
Date: Fri, 1 Apr 2005 14:15:53 +0900
Message-ID: <20050401051553.GE11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.4025028A@htj.dyndns.org> <20050331101353.GC13842@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.199]:5126 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262634AbVDAFQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 00:16:01 -0500
Received: by wproxy.gmail.com with SMTP id 68so795913wra
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 21:15:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20050331101353.GC13842@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, Chritoph.

On Thu, Mar 31, 2005 at 11:13:53AM +0100, Christoph Hellwig wrote:
> >  		/* Queue the command and wait for it to complete */
> >  		/* Abuse eh_timeout in the scsi_cmnd struct for our purposes */
> >  		init_timer(&cmd->eh_timeout);
> > +		cmd->eh_timeout.function = NULL;
> 
> I'd rather not see aic7xxx poke even deeper into this internal code.
> Can you please switch it to use a timer of it's own first?

 Yes, I'll.

 Thanks.

-- 
tejun

