From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 4/7 cleanup/consolidate code in scsi_request_fn
Date: Wed, 26 Mar 2003 12:25:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E81E26F.6020709@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <3E80CB02.8010909@splentec.com> <20030325165822.A1383@beaverton.ibm.com> <3E81DE4D.7060407@splentec.com> <20030326091346.A2940@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> OK -
> 
> 	scsi_sdev_queue_ready 
> 	scsi_shost_queue_ready
> or

**********************************
*                                *
*> 	scsi_dev_queue_ready     *
*> 	scsi_host_queue_ready    *
*>                               *
**********************************

-- 
Luben
P.S. Even though ``queue ready?'' doesn't quite mean
the same thing as ``can queue?''.  If I were you, I'd
use scsi_{dev,host}_canqueue(), or
scsi_{dev,host}_can_queue(), despite the unfortunate
choice of ``can_queue'' back in the days.






