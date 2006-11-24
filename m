From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Some doubts in Persistent Reservation
Date: Fri, 24 Nov 2006 09:02:20 -0600
Message-ID: <1164380540.2813.2.camel@mulgrave.il.steeleye.com>
References: <7519006.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:2442 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S934640AbWKXPCe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Nov 2006 10:02:34 -0500
In-Reply-To: <7519006.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djshetty <dhirajshetty.junk@mailnull.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-11-23 at 23:55 -0800, djshetty wrote:
>    1. Is persistent reservation applied on a target port or on a particular
> LUN connected to a target port. The SCOPE of persistent reservation says
> "Entire LOGICAL UNIT", whereas the registration is done for a target PORT.
> Hence the confusion.

For multi-ported devices it's per LUN per port (unless you specify all
target ports).

>    2. Is there any precise use of the PRGeneration key? I guessed it must be
> used for knowing whether any changes have been on the target (with regards
> to persistent reservation) since the previous command executed. 

That's the stated use in section 5.6.5.3 of SPC-3, yes.

James


