From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Tue, 14 Jan 2014 09:31:08 -0500
Message-ID: <20140114143108.GB12131@htj.dyndns.org>
References: <20140108005607.GB29556@linux.intel.com>
 <20140111191315.GC3257@mtj.dyndns.org>
 <20140113195544.GA13900@linux.intel.com>
 <20140113203007.GA3480@mtj.dyndns.org>
 <20140113233026.GA3200@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:63609 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaANObM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2014 09:31:12 -0500
Content-Disposition: inline
In-Reply-To: <20140113233026.GA3200@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Todd E Brandt <todd.e.brandt@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, rjw@rjwysocki.net

Hello, Todd.

On Mon, Jan 13, 2014 at 03:30:26PM -0800, Todd E Brandt wrote:
> Ahh, sorry, yea I think async should work for the entire resume pathway. Would
> you be willing to accept this ata patch separately from the scsi one? It
> wouldn't provide any performance benefit on its own, but would pave the way
> for performance benefit by removing the ATA resume lag time (Which would then
> put the ball in the scsi layer's court to finish the optimization). I've 
> tested both patches separately and both work without issue. Also, this patch
> appears to be a pre-requisite to both mine and Phillip Susi's solution, so 
> it would really hope move things along regardless of which direction is
> ultimately chosen in the SCSI layer.

Let's do it together.  It's not like this involves huge number of
patches which would be helped by staging things.

Thanks.

-- 
tejun
