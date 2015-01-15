From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm + blk-mq soft lockup complaint
Date: Thu, 15 Jan 2015 10:43:43 -0500
Message-ID: <20150115154343.GA11859@redhat.com>
References: <alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
 <20150112191138.GC21518@redhat.com>
 <20150112202113.GA23234@redhat.com>
 <54B50F9D.2040000@sandisk.com>
 <20150113141746.GA30411@redhat.com>
 <54B52B73.7040807@sandisk.com>
 <20150113162052.GA30837@redhat.com>
 <54B633DC.4090806@sandisk.com>
 <20150114185926.GB6012@redhat.com>
 <54B7764C.9000402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbbAOPoQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2015 10:44:16 -0500
Content-Disposition: inline
In-Reply-To: <54B7764C.9000402@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi@vger.kernel.org

On Thu, Jan 15 2015 at  3:11am -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 01/14/15 20:00, Mike Snitzer wrote:
> > IB aside, I haven't been following along close enough on scsi-mq
> > developments, but does a regular iscsi initiator have support for
> > scsi-mq?  I'd like to validate scsi-mq devices with the dm-mpath
> > changes.
> 
> Hello Mike,
> 
> scsi-mq support for the iSCSI initiator is being considered but has not
> yet been implemented. For more information, see also Sagi Grimberg,
> [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion, linux-scsi mailing
> list, January 7, 2015 (http://thread.gmane.org/gmane.linux.scsi/98199).

OK, thanks.

FYI, I just used your fio test against an mpath device that is using 4
virtio-scsi devices with blk-mq enabled and all worked fine.

How easily could you reproduce your SRP hang?  Did it happen every run
or did it take multiple runs to see it?
