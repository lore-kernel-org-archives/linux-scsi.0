From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] scsi_normalize_sense()
Date: Tue, 24 Aug 2004 16:42:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824164253.A30010@infradead.org>
References: <41258F6A.6030606@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:1545 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268041AbUHXPm6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 11:42:58 -0400
Content-Disposition: inline
In-Reply-To: <41258F6A.6030606@torque.net>; from dougg@torque.net on Fri, Aug 20, 2004 at 03:43:06PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 20, 2004 at 03:43:06PM +1000, Douglas Gilbert wrote:
> Looking around the linux SCSI subsystem the handling
> of data in the sense buffer is haphazard. Most places
> ignore "deferred" errors (e.g. medium error reported
> later when write caching is on) and will break horribly
> if they every see the newer "descriptor" format.
> 
> Descriptor format sense data is much cleaner (amongst
> other reason are that it doesn't have to carry around 20
> years of baggage). See SPC-3 revision 20a section 4.5
> at http://www.t10.org for more information.
> 
> The sense format a SCSI device will use is controlled
> by the D_SENSE bit in the control mode page.
> 
> Here is some code which I am proposing to put into
> scsi_lib.c to facilitate cleaner handling. I have been
> testing it out in sg3_utils-1.08 (beta) for the last
> week.  Comments??

This looks good to me.  Before submission for the kernel side
please massage it into the canonical kernel style, though.

