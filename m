From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: sd: workaround invalid OPTIMAL TRANSFER LENGTH
Date: Wed, 24 Apr 2013 21:44:55 -0400
Message-ID: <20130425014455.GA28078@redhat.com>
References: <20130403202124.GB2197@redhat.com>
 <yq1bo93v230.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab3DYBo6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 21:44:58 -0400
Content-Disposition: inline
In-Reply-To: <yq1bo93v230.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 24 2013 at  9:19pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> Following up on our discussion at LSF/MM last week...
> 
> Mike> Workaround disk firmware that improperly sets OPTIMAL TRANSFER
> Mike> LENGTH to 0xFFFFFFFF (aka UINT_MAX or 4294967295U) by assuming
> Mike> this _optional_ BLOCK LIMITS VPD field was not specified (0).
> 
> My only real objection is that UINT_MAX appears to be completely
> coincidental. What if the next drive specifies UINT_MAX-1 or $RANDOM?
> 
> Lacking a decent heuristic I'd rather just blacklist the offending drive
> using the skip_vpd_pages knob we already have in place.

OK, sounds fine to me, thanks.
