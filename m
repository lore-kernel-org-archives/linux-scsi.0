From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ipr: RESEND: fix PCI permanent error handler
Date: Mon, 20 Apr 2009 20:30:01 +0000
Message-ID: <1240259401.3315.63.camel@mulgrave.int.hansenpartnership.com>
References: <1240246790.7458.112.camel@zeppelin.austin.ibm.com>
	 <1240258429.3315.60.camel@mulgrave.int.hansenpartnership.com>
	 <49ECD89D.3000005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37504 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353AbZDTUaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 16:30:03 -0400
In-Reply-To: <49ECD89D.3000005@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2009-04-20 at 15:18 -0500, Brian King wrote:
> Kleber found the problem, debugged it, and provided a fix to me.
> I provided him with an alternate patch to fix it. I'm assuming this
> should have been handled by me submitting with my signoff alone and
> adding a reported-by tag for Kleber. Sorry for the confusion. Shall
> I resend as I just described?

No, I always thought it was

From: Kleber

Acked-by: you
Signed-off-by: Kleber


I just became confused when the most recent update came through.

James


