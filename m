From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [dm-devel] [RFC PATCH 3/4] dm mpath: move trigger_event member to
 the end of 'struct multipath'
Date: Fri, 01 Apr 2016 10:50:13 +0200
Message-ID: <7d99d3cb7e0394cb77751162c5c9d89d@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <1459454666-76428-4-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbcDAIuQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 04:50:16 -0400
In-Reply-To: <1459454666-76428-4-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, linux-block@vger.kernel.org, jmoyer@redhat.com, j-nomura@ce.jp.nec.com

On 2016-03-31 22:04, Mike Snitzer wrote:
> Allows the 'work_mutex' member to no longer cross a cacheline.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
