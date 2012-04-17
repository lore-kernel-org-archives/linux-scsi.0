From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problems with sr_get_events
Date: Tue, 17 Apr 2012 11:46:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204171145140.1364-100000@iolanthe.rowland.org>
References: <20120417153822.GD32402@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53021 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754536Ab2DQPq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2012 11:46:27 -0400
In-Reply-To: <20120417153822.GD32402@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 17 Apr 2012, Tejun Heo wrote:

> On Tue, Apr 17, 2012 at 11:33:27AM -0400, Alan Stern wrote:
> > > Hmmm... Maybe but we've been sending GET_EVENT without such provision
> > > for very long time now.  I feel reluctant to change something which
> > > seems to work in this area even if that something is technically
> > > wrong.  It's not like cheap USB devices tend to be technically correct
> > > anyway.
> > 
> > All right, then how do you feel about this patch?  It makes minimal
> > changes, to avoid the inefficiency of sending repeated commands that
> > can never work.
> 
> Hmmm... while I don't object to the patch per-se, I'm not sure what
> benefit it brings.  Do you have any specific case where this is
> necessary / beneficial?  What are we gaining by not issuing GET_EVENT?

We save a little bit of time.  It's not necessary; it's just a small 
optimization.

Alan Stern

