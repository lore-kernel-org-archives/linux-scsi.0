From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_dh_alua: Enable STPG for unavailable ports
Date: Wed, 19 Sep 2012 13:36:46 -0400
Message-ID: <20120919173645.GA17612@redhat.com>
References: <50374499.5010808@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab2ISRhA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Sep 2012 13:37:00 -0400
Content-Disposition: inline
In-Reply-To: <50374499.5010808@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Babu Moger <babu.moger@netapp.com>

On Fri, Aug 24 2012 at  5:08am -0400,
Bart Van Assche <bvanassche@acm.org> wrote:

> A quote from SPC-4: "While in the unavailable primary target port
> asymmetric access state, the device server shall support those of
> the following commands that it supports while in the active/optimized
> state: [ ... ] d) SET TARGET PORT GROUPS; [ ... ]". Hence enable
> sending STPG to a target port group that is in the unavailable state.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Babu Moger <babu.moger@netapp.com>
> Cc: <stable@vger.kernel.org>

Looks good to me.

Acked-by: Mike Snitzer <snitzer@redhat.com>
