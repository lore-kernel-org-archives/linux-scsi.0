From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/9] scsi_dh: move device matching to the core code
Date: Thu, 30 Apr 2015 14:32:56 -0400
Message-ID: <20150430183256.GF30542@redhat.com>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
 <1430415151-30948-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbbD3SfG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 14:35:06 -0400
Content-Disposition: inline
In-Reply-To: <1430415151-30948-7-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, Apr 30 2015 at  1:32pm -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Add a single list of devices that need non-ALUA device handlers to the core
> scsi_dh code so that we can autoload the modules for them at probe time.
> 
> While this is a little ugly in terms of architecture it actually
> significantly simplifies the code in addition to the new autoloading
> functionality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
