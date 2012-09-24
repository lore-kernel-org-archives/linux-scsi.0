From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2] st: remove st_mutex
Date: Mon, 24 Sep 2012 13:06:00 +0400
Message-ID: <1348477560.2467.23.camel@dabdike>
References: <504E6B7C.9010407@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35811 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab2IXJGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2012 05:06:05 -0400
In-Reply-To: <504E6B7C.9010407@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, Kai =?ISO-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, Hannes Reinecke <hare@suse.de>

On Mon, 2012-09-10 at 15:36 -0700, Lee Duncan wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> The st_mutex was created when the BKL was removed, and
> prevents simultaneous st_open calls. It is better to
> protect just the necessary data.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>

That should be Signed-off-by since you sent the patch to me.  Signoffs
have to follow the chain of transmission.  I've assumed this was just a
mistype.

James


