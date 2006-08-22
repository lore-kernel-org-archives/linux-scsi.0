From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Need help with another aic94xx sequencer problem
Date: Tue, 22 Aug 2006 17:44:16 -0500
Message-ID: <1156286656.21487.0.camel@mulgrave.il.steeleye.com>
References: <1156278519.19615.31.camel@mulgrave.il.steeleye.com>
	 <20060822205315.GA16638@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:45263 "EHLO
	accolon.hansenpartnership.com") by vger.kernel.org with ESMTP
	id S1750770AbWHVWoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 18:44:20 -0400
In-Reply-To: <20060822205315.GA16638@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-08-22 at 13:53 -0700, Mike Anderson wrote:
> Does this help any? While Alexis and I where working on a expander timeout
> issue the abort was never working for us. I compared the adp abort and the
> aic94xx abort code and made these changes. This appears to make the abort
> work for us now. A few lines of the changes are not related to the abort.
> YMMV, a better solution would be to know the exact format of the abort.

Actually, no.  I still seem to get the same problem (at least it BUGs in
the same place ... I haven't dug down to see if I'm getting the same
return value).

James


