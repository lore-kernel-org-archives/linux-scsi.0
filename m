From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] qla2xxx: don't include <generated/utsrelease.h>
Date: Wed, 21 Jun 2017 13:43:27 +0200
Message-ID: <20170621114327.GD6482@linux-x5ow.site>
References: <20170621114005.29800-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751149AbdFULn3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 07:43:29 -0400
Content-Disposition: inline
In-Reply-To: <20170621114005.29800-1-johannes@sipsolutions.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-scsi@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>

On Wed, Jun 21, 2017 at 01:40:05PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no need to use the static UTS_RELEASE string, since
> utsname()->release contains the same.
> 
> This avoids rebuilding this file for every change of the
> release string.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
