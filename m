From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Eliminate signals entirely from the mid-layer
Date: Fri, 10 Jan 2003 14:01:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030110220126.GB1143@beaverton.ibm.com>
References: <200301102119.h0ALJUf05888@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301102119.h0ALJUf05888@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> the attached patch removes SCSI's use of signals for killing the error handler 
> thread.  It also:
> 
> - changes the eh_notify semaphore to a completion
> - adds complete_and_exit() to the thread
> - uses a host structure flag to signal thread death instead of the signal
> 
> I'm currently travelling, so could someone test it out for me?  Thanks,

I will try to test it today or tomorrow. I am already setup for some
error handler fault tests for a qlogicisp error handling update.

-andmike
--
Michael Anderson
andmike@us.ibm.com

