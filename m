From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 15/16] qla2xxx: Add bulk send for atio & ctio
 completion paths.
Date: Tue, 5 Jan 2016 22:07:10 -0800
Message-ID: <20160106060710.GA17359@infradead.org>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
 <1450382231-4259-16-git-send-email-himanshu.madhani@qlogic.com>
 <1450682033.25674.44.camel@haakon3.risingtidesystems.com>
 <D2AFECA4.1BF9A%quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D2AFECA4.1BF9A%quinn.tran@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Quinn ,

On Mon, Jan 04, 2016 at 06:27:58PM +0000, Quinn Tran wrote:
> >in kernel/workqueue.c to be used beyond qla2xxx, or:
> 
> QT> For every work element, the pool->lock is grabbed.  Unless the lock
> can be grab 1 time and the rest of the work elements piggy back on it then
> it?s worth it to have a new kernel service.

Can you remove these 'QT>' markers?  They really mess up display in
most common mailers and make every first line of your text look like
you quoted it from the previous mail.

This made your two mails almost unreadable for me.
