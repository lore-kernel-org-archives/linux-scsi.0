From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] scsi: Convert everyone to scsi_sglist and scsi_sg_count
Date: Fri, 4 Jan 2008 14:28:40 +1100
Message-ID: <200801041428.41292.rusty@rustcorp.com.au>
References: <200801031800.02537.rusty@rustcorp.com.au> <200801031950.12090.rusty@rustcorp.com.au> <477CAA35.3020900@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:53294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYADD2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 22:28:43 -0500
In-Reply-To: <477CAA35.3020900@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

On Thursday 03 January 2008 20:26:13 Boaz Harrosh wrote:
> On Thu, Jan 03 2008 at 10:50 +0200, Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > This patch simply converts direct uses of ->use_sg and ->request_buffer
> > to use the wrapper macros.  This removes the assumption that the sg list
> > is overloaded on request_buffer, and that there's an explicit use_sg
> > field.
>
> All of these drivers are properly converted in current scsi-misc +
> scsi-pending. If you are really serious about changing scsi-layer you
> better work ontop of scsi git trees.

Hi Boaz,

    Well, I wouldn't say I'm serious about SCSI 8) but I am delighted to see 
this being done.  Have grabbed scsi-pending from git.kernel.org, thanks for 
the hint.

> Also you can inspect -mm tree it has the scsi_data_buffer patches that does
> 4/5 what you want.

   Remember, these scsi patches are a side-effect of trying to get my own 
sg-using code sane.  So this is exactly what I *don't* want: another "works 
for scsi" solution :(

I'll see where we can go from here...
Thanks,
Rusty.
