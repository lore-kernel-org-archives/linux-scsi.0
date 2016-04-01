From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [dm-devel] [RFC PATCH 2/4] dm mpath: use atomic_t for counting
 members of 'struct multipath'
Date: Fri, 01 Apr 2016 10:48:54 +0200
Message-ID: <b5f43b9cf4e518f962f3a15c8b0ed926@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <1459454666-76428-3-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbcDAIs4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 04:48:56 -0400
In-Reply-To: <1459454666-76428-3-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, linux-block@vger.kernel.org, jmoyer@redhat.com, j-nomura@ce.jp.nec.com

On 2016-03-31 22:04, Mike Snitzer wrote:
> The use of atomic_t for nr_valid_paths, pg_init_in_progress and
> pg_init_count will allow relaxing the use of the m->lock spinlock.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
