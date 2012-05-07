From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/3] Make scsi_free_queue() abort pending requests
Date: Sun, 06 May 2012 20:15:17 -0500
Message-ID: <4FA72225.2010901@cs.wisc.edu>
References: <4FA3EF10.3040104@acm.org> <4FA3F0B1.9040207@acm.org> <4FA43B21.2060906@cs.wisc.edu> <4FA43CC3.6040507@cs.wisc.edu> <4FA4C3BE.1080505@acm.org> <4FA71AE6.4060305@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42012 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab2EGBPj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 May 2012 21:15:39 -0400
In-Reply-To: <4FA71AE6.4060305@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 05/06/2012 07:44 PM, Mike Christie wrote:
> blk_put_request -> elv_completed_request. For BLOCK PC and other
> requests there is the rq.count tracking.

The rq.count stuff should also make sure we have a queue before the
prep/request fn code is run and for requeues from what I can tell.
