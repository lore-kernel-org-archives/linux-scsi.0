From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm + blk-mq soft lockup complaint
Date: Thu, 15 Jan 2015 09:11:56 +0100
Message-ID: <54B7764C.9000402@sandisk.com>
References: <54B40E8A.6010005@kernel.dk>
 <alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
 <alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
 <20150112191138.GC21518@redhat.com> <20150112202113.GA23234@redhat.com>
 <54B50F9D.2040000@sandisk.com> <20150113141746.GA30411@redhat.com>
 <54B52B73.7040807@sandisk.com> <20150113162052.GA30837@redhat.com>
 <54B633DC.4090806@sandisk.com> <20150114185926.GB6012@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0086.outbound.protection.outlook.com ([157.56.110.86]:52608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752258AbbAOIMF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2015 03:12:05 -0500
In-Reply-To: <20150114185926.GB6012@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi@vger.kernel.org

On 01/14/15 20:00, Mike Snitzer wrote:
> IB aside, I haven't been following along close enough on scsi-mq
> developments, but does a regular iscsi initiator have support for
> scsi-mq?  I'd like to validate scsi-mq devices with the dm-mpath
> changes.

Hello Mike,

scsi-mq support for the iSCSI initiator is being considered but has not
yet been implemented. For more information, see also Sagi Grimberg,
[LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion, linux-scsi mailing
list, January 7, 2015 (http://thread.gmane.org/gmane.linux.scsi/98199).

Bart.

