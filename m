From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 10:22:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014172232.GA3538@beaverton.ibm.com>
References: <andersen@codepoet.org> <20021014054035.GA10686@codepoet.org> <200210141557.g9EFvLw02517@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210141557.g9EFvLw02517@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: andersen@codepoet.org, linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> Needing kernel hooks in a different subsystem to solve a hotplug problem looks 
> slightly wrong to me.  Usually when this type of thing comes up its because 
> we're missing a hotplug event (or a hotplug event doesn't carry the right 
> information).  Could you elaborate more on the actual problem you're trying to 
> solve?
> 
> James

I believe one thing that we are missing is an event when a scsi_host is
added. Even in 2.5 we are not receiving a hotplug event for the addition
of a scsi_host, because of the way we init are LL drivers. This will be fixed
soon.

-andmike
--
Michael Anderson
andmike@us.ibm.com

