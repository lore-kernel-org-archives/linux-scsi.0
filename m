From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11898] mke2fs hang on AIC79 device.
Date: Thu, 06 Nov 2008 08:57:38 -0600
Message-ID: <1225983458.4703.66.camel@localhost.localdomain>
References: <20081106021956.75C2911D10A@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42713 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbYKFO5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 09:57:45 -0500
In-Reply-To: <20081106021956.75C2911D10A@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-11-05 at 18:19 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> ------- Comment #25 from yanmin_zhang@linux.intel.com  2008-11-05 18:19 -------
> Created an attachment (id=18697)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=18697&action=view)
> Here is the patch to fix it against 2.6.28-rc3.
> 
> I tested the patch on my 2 machines and it does fix the issue.

The problem is that it doesn't fix the theoretical tight loop, so
someone else will run into the issue under more trying circumstances.

The only reason a patch which conditionally NULLs starved_head works
over one that does it absolutely should be that there's some other loop
that requires it being set to effect a break out.

James


