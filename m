From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/5] sd: Implement support for WRITE SAME
Date: Mon, 20 Feb 2012 13:28:39 -0500
Message-ID: <20120220182839.GA30034@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <1327969892-5090-6-git-send-email-martin.petersen@oracle.com>
 <20120220161645.GA29207@redhat.com>
 <yq17gzh5rv0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab2BTS2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 13:28:45 -0500
Content-Disposition: inline
In-Reply-To: <yq17gzh5rv0.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

On Mon, Feb 20 2012 at 12:36pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Just a small nit, this should be scsi_setup_write_same_cmnd given
> Mike> we already have: scsi_setup_{discard,flush}_cmnd
> 
> This was deliberate. It's the two other functions that are
> misnamed. They clearly belong in the sd_ name space.

OK, sure, might make the most sense to have an earlier patch in the
series rename the others.
