From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 4/7 cleanup/consolidate code in scsi_request_fn
Date: Wed, 26 Mar 2003 12:07:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E81DE4D.7060407@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <3E80CB02.8010909@splentec.com> <20030325165822.A1383@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> I don't care much one way or the other, but I don't like ok2queue.
> 
> I was using sdev to distinguish the name from struct dev and functions
> related to struct dev. We already have the confusing names scsi_device_get
> and scsi_get_device - one for a "get" of a scsi_device one to get a
> struct dev given a scsi_host. And then the shost naming matches sdev.
> 
> Anyway, the following are fine with me:
> 	scsi_dev_ready, scsi_host_ready
> 	scsi_sdev_ready, scsi_shost_ready
> 

The problem here is _again_ the implicitness of your definitions.
``ready'' is not better than ``check''.  Why?

result = X_ready(arg) --> whatever result, the question is
``ready (or not) _for__what_????''

-- 
Luben


