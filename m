From: Jeremy Cline <jeremy@jcline.org>
Subject: Re: [PATCH] scsi: sd: Use warn for logs about no caching info
Date: Thu, 11 Jan 2018 20:22:48 +0000
Message-ID: <01000160e6e3a905-df1c1554-dde2-41c1-8095-eb58a4ba3a75-000000@email.amazonses.com>
References: <010001607ad7197e-2f933a99-5ecd-4245-acd8-acfe3e3bdf9a-000000@email.amazonses.com>
 <yq1shbmxoxm.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a8-57.smtp-out.amazonses.com ([54.240.8.57]:47814 "EHLO
        a8-57.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933043AbeAKUWt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jan 2018 15:22:49 -0500
Content-Disposition: inline
In-Reply-To: <yq1shbmxoxm.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jan 03, 2018 at 10:50:29PM -0500, Martin K. Petersen wrote:
> 
> Hi Jeremy,
> 
> > When no caching mode information can be found for a disk, use the
> > warning log level rather than error. It is common for this to occur
> > with cheap USB sticks.
> 
> Just because something is common occurrence doesn't mean it's not an
> error. What's the rationale behind demoting this to a warning?

That's true, that's not a particularly compelling reason. My rationale
is that in this case when it can't find the cache info it drops back to
sane defaults and works fine. It's certainly something to note, but
I wouldn't describe it as an "error condition".

Regards,
Jeremy
