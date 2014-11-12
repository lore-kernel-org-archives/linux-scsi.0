From: Ewan Milne <emilne@redhat.com>
Subject: Re: [RFC] Discard update for 3.19
Date: Wed, 12 Nov 2014 13:40:15 -0500
Message-ID: <1415817615.16672.49.camel@localhost.localdomain>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	 <20141110141906.GA20891@infradead.org>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaKLSkp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2014 13:40:45 -0500
In-Reply-To: <20141110141906.GA20891@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de

On Mon, 2014-11-10 at 06:19 -0800, Christoph Hellwig wrote:
> Looks like there is no real dependency between these patches, so we
> might take on each through the libata, scsi and block trees.
> 
> Can I get another review for the sd patch, please?
> 

The changes in [PATCH 2/3] sd: Disable discard_zeroes_data for UNMAP
look fine to me.  I was wondering, though, if the changes to add the
"devices_handle_discard_safely" module parameter to the MD raid drivers
are really needed if this is fixed.  (It's great to be able to disable
the use of discard if desired, but how is an administrator actually
supposed to know if the devices they have *really* work properly?)
Maybe the default value of this parameter should be changed, or the
parameter should be changed to have an inverse sense, i.e. "disable
use of discard"...

-Ewan


