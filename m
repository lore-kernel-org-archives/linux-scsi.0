From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 7/7] libiscsi: fix iscsi pool error path
Date: Thu, 2 Apr 2009 10:26:44 -0700
Message-ID: <20090402172644.GH18394@sequoia.sous-sol.org>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu> <12386094922477-git-send-email-michaelc@cs.wisc.edu> <12386094933319-git-send-email-michaelc@cs.wisc.edu> <200904021602.55587.jdelvare@suse.de> <49D4D68A.8080606@cs.wisc.edu> <20090402152715.GF18394@sequoia.sous-sol.org> <49D4E23C.2010201@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:39865 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934595AbZDBR07 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 13:26:59 -0400
Content-Disposition: inline
In-Reply-To: <49D4E23C.2010201@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Chris Wright <chrisw@sous-sol.org>, Jean Delvare <jdelvare@suse.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>

* Mike Christie (michaelc@cs.wisc.edu) wrote:
> Ah, ok, I can agree with passing up errors in general. I did the  
> attached patch to propogate the error code upwards. It does not really  
> make much difference now. The iscsi pool init caller just checks for  
> error or no error and does not even print out the error. It will not  
> make tracing errors easier or more difficult. To be useful, we would  
> have to propgate the error higher to userspace so the user can see it. I  
> do not think I have time to get that in the current feature window, so  
> that would have to wait unless you have patches I can test now.

Yup, I think it's just fine as is.

> libiscsi: propogate errors from kfifo_init to iscsi_pool_init callers
> 
> Don't convert kfifo_init's error code to -ENOMEM when passing the
> error to the iscsi_pool_init caller.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Acked-by: Chris Wright <chrisw@sous-sol.org>

