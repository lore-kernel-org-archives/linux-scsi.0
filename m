From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 4/7 cleanup/consolidate code in scsi_request_fn
Date: Wed, 26 Mar 2003 09:13:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030326091346.A2940@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <3E80CB02.8010909@splentec.com> <20030325165822.A1383@beaverton.ibm.com> <3E81DE4D.7060407@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E81DE4D.7060407@splentec.com>; from luben@splentec.com on Wed, Mar 26, 2003 at 12:07:25PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Mar 26, 2003 at 12:07:25PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > I don't care much one way or the other, but I don't like ok2queue.

> > Anyway, the following are fine with me:
> > 	scsi_dev_ready, scsi_host_ready
> > 	scsi_sdev_ready, scsi_shost_ready
> > 
> 
> The problem here is _again_ the implicitness of your definitions.
> ``ready'' is not better than ``check''.  Why?
> 
> result = X_ready(arg) --> whatever result, the question is
> ``ready (or not) _for__what_????''

OK -

	scsi_sdev_queue_ready 
	scsi_shost_queue_ready
or
	scsi_dev_queue_ready
	scsi_host_queue_ready

-- Patrick Mansfield
