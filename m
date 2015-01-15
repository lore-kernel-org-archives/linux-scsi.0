From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm + blk-mq soft lockup complaint
Date: Thu, 15 Jan 2015 16:55:11 +0100
Message-ID: <54B7E2DF.5060409@sandisk.com>
References: <alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
 <20150112191138.GC21518@redhat.com> <20150112202113.GA23234@redhat.com>
 <54B50F9D.2040000@sandisk.com> <20150113141746.GA30411@redhat.com>
 <54B52B73.7040807@sandisk.com> <20150113162052.GA30837@redhat.com>
 <54B633DC.4090806@sandisk.com> <20150114185926.GB6012@redhat.com>
 <54B7764C.9000402@sandisk.com> <20150115154343.GA11859@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0068.outbound.protection.outlook.com ([157.56.110.68]:35712
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754649AbbAOPzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2015 10:55:20 -0500
In-Reply-To: <20150115154343.GA11859@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi@vger.kernel.org

On 01/15/15 16:44, Mike Snitzer wrote:
> How easily could you reproduce your SRP hang?  Did it happen every run
> or did it take multiple runs to see it?

Hello Mike,

This complaint was easy to trigger. It took less than one minute before
the soft lockup complaint appeared. The system did not hang after that
complaint appeared. Maybe this complaint means that a cond_resched()
call was missing from a loop ?

Bart.
