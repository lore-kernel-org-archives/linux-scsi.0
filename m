From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Fix sleeping while holding a lock on host removal and
 on killing the DV thread
Date: Mon, 18 Oct 2004 16:46:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41742BAD.8000607@adaptec.com>
References: <416D8EBA.7060904@adaptec.com> <1098119447.1714.93.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64212 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267306AbUJRUqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 16:46:49 -0400
In-Reply-To: <1098119447.1714.93.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Wed, 2004-10-13 at 15:23, Luben Tuikov wrote:
> 
>>Fix sleeping while holding a lock on host removal and on
>>killing the DV thread.
> 
> 
> This is rejecting completely again ... looks like additional space
> beginning the non +/- patch lines.

Sorry James, I'll take a look again at my mailer.

> As a longer term project, since I'm losing count of the number of bugs
> that keep turning up in the aic DV, what would it take to move this over
> to the generic DV code?

Yes, this is definitely worth looking into.  I'll investigate this.

I'll resubmit the patch in an attachment and include
"aic7xxx" and "aic79xx" in the Subject line for better
sorting in BK.

Thanks,
	Luben

