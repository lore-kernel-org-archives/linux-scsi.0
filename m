From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 08:57:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210141557.g9EFvLw02517@localhost.localdomain>
References: <andersen@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA07640
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2002 08:57:25 -0700
In-Reply-To: Message from Erik Andersen <andersen@codepoet.org>
   of "Sun, 13 Oct 2002 23:40:35 MDT." <20021014054035.GA10686@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: andersen@codepoet.org
Cc: linux-scsi@vger.kernel.org

andersen@codepoet.org said:
> Anyone have any objections to such a patch?  For 2.4.x?  Comments?

The patch looks fine per se.

However, I thought that the whole spirit of hotplug was that this type of 
problem should be solved in user space to which SCSI currently exposes a 
perfectly adequate interface.

Needing kernel hooks in a different subsystem to solve a hotplug problem looks 
slightly wrong to me.  Usually when this type of thing comes up its because 
we're missing a hotplug event (or a hotplug event doesn't carry the right 
information).  Could you elaborate more on the actual problem you're trying to 
solve?

James


