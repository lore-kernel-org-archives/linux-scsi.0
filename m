From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: Disable support for 256 byte/sector disks
Date: Wed, 13 May 2015 07:00:55 -0700
Message-ID: <1431525655.2363.13.camel@HansenPartnership.com>
References: <1431506949-11398-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41010 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933657AbbEMOBB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 10:01:01 -0400
In-Reply-To: <1431506949-11398-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mark Hounschell <dmarkh@cfl.rr.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, 2015-05-13 at 10:49 +0200, Hannes Reinecke wrote:
> 256 bytes per sector support has been broken since 2.6.X,
> and no-one stepped up to fix this.
> So disable support for it.

I assume this should have a 

From: Mark Hounschell <dmarkh@cfl.rr.com>

at the top?

James


