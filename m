From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [dm-devel] [RFC PATCH 1/4] dm mpath: switch to using bitops for
 state flags
Date: Fri, 01 Apr 2016 10:46:18 +0200
Message-ID: <7099b111d3547c4f21749ee9c5f225a3@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <1459454666-76428-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbcDAIqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 04:46:19 -0400
In-Reply-To: <1459454666-76428-2-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, linux-block@vger.kernel.org, jmoyer@redhat.com, j-nomura@ce.jp.nec.com

On 2016-03-31 22:04, Mike Snitzer wrote:
> Mechanical change that doesn't make any real effort to reduce the use 
> of
> m->lock; that will come later (once atomics are used for counters, 
> etc).
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
