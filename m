From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/19] Document which queue type a function is intended
        for
Date: Thu, 24 Aug 2017 11:05:35 +0200
Message-ID: <20170824090535.GF19886@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-7-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48613 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751348AbdHXJFg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 05:05:36 -0400
Content-Disposition: inline
In-Reply-To: <20170823214009.15015-7-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On Wed, Aug 23, 2017 at 02:39:56PM -0700, Bart Van Assche wrote:
> Document which queue type a function is intended for if this is not
> easy to derive from the function name.

How about adding mq and legacy to the function names instead?
