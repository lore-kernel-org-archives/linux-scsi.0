From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] [PATCH] [SCSI] libiscsi: fix iscsi pool error path
Date: Mon, 30 Mar 2009 12:43:15 -0700
Message-ID: <20090330194315.GD18394@sequoia.sous-sol.org>
References: <200903291119.42080.jdelvare@suse.de> <20090330184458.GB11116@hera.kernel.org> <200903302134.30706.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:33856 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754455AbZC3US3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2009 16:18:29 -0400
Content-Disposition: inline
In-Reply-To: <200903302134.30706.jdelvare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

* Jean Delvare (jdelvare@suse.de) wrote:
> Making the freeing of q->queue dependent on q->pool being set looks
> really weird (although it is correct at the moment. But this seems
> to be fixable in a much simpler way:

Fine by me.  I condsidered that and for some reason I thought it was odd
to do it that way ;-)  The pool is the ->buffer used in the fifo, but...

Acked-by: Chris Wright <chrisw@sous-sol.org>
