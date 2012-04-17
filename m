From: Tejun Heo <tj@kernel.org>
Subject: Re: Problems with sr_get_events
Date: Tue, 17 Apr 2012 08:38:22 -0700
Message-ID: <20120417153822.GD32402@google.com>
References: <20120416225512.GH12421@google.com>
 <Pine.LNX.4.44L0.1204171128580.1364-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46766 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2DQPi2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2012 11:38:28 -0400
Received: by dake40 with SMTP id e40so8544709dak.11
        for <linux-scsi@vger.kernel.org>; Tue, 17 Apr 2012 08:38:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204171128580.1364-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Apr 17, 2012 at 11:33:27AM -0400, Alan Stern wrote:
> > Hmmm... Maybe but we've been sending GET_EVENT without such provision
> > for very long time now.  I feel reluctant to change something which
> > seems to work in this area even if that something is technically
> > wrong.  It's not like cheap USB devices tend to be technically correct
> > anyway.
> 
> All right, then how do you feel about this patch?  It makes minimal
> changes, to avoid the inefficiency of sending repeated commands that
> can never work.

Hmmm... while I don't object to the patch per-se, I'm not sure what
benefit it brings.  Do you have any specific case where this is
necessary / beneficial?  What are we gaining by not issuing GET_EVENT?

Thanks.

-- 
tejun
