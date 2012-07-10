From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 3/3] drivers/scsi/ufs: fix incorrect return value
 about SUCCESS and FAILED
Date: Tue, 10 Jul 2012 15:42:20 +0100
Message-ID: <1341931340.3021.70.camel@dabdike.int.hansenpartnership.com>
References: <1341929364-9122-1-git-send-email-svenkatr@ti.com>
	 <1341929364-9122-4-git-send-email-svenkatr@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48509 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970Ab2GJOmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jul 2012 10:42:25 -0400
In-Reply-To: <1341929364-9122-4-git-send-email-svenkatr@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Venkatraman S <svenkatr@ti.com>
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Namjae Jeon <linkinjeon@gmail.com>

On Tue, 2012-07-10 at 19:39 +0530, Venkatraman S wrote:
> From: Namjae Jeon <linkinjeon@gmail.com>
> 
> Currently the UFS host driver has returned incorrect values for SUCCESS
> and FAILED.  Fix it to return the correct value to the upper layer.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Acked-by: Santosh Y <santoshsy@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The signoff chain here doesn't make sense.  It needs to be signed off by
you, not by Andrew since you're the one sending the patches.  Signoffs
follow the way the patch is transmitted, so it needs author (it has)
followed by maintainer ack (it has) followed by signoff of the person
sending the patch to the list (that's you) which is missing.

James


