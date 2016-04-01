From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/2] target: use new "dbroot" target attribute
Date: Fri, 01 Apr 2016 09:58:35 +0200
Message-ID: <394f77609c81d2274cee31a51318d89e@suse.de>
References: <cover.1459278305.git.lduncan@suse.com>
 <e2b3b2a176b28155e43365e30c58e5a00cfab673.1459278305.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758381AbcDAH6h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 03:58:37 -0400
In-Reply-To: <e2b3b2a176b28155e43365e30c58e5a00cfab673.1459278305.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@infradead.org, lkml@vger.kernel.org, hare@suse.com, linux-scsi-owner@vger.kernel.org

On 2016-03-31 20:05, Lee Duncan wrote:
> This commit updates the target core ALUA and PR
> modules to use the new "dbroot" attribute instead
> of assuming the target database is in "/var/target".

Same goes for this one,

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
as soon as it has a Signed-off-by line
