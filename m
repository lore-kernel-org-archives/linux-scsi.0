From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 9010] SCSI device is not offlined properly and tries to
	cache data from previous device
Date: Wed, 19 Mar 2008 15:24:11 -0500
Message-ID: <1205958251.11527.44.camel@localhost.localdomain>
References: <20080319084344.0FDE310806C@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33845 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932957AbYCSUYP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 16:24:15 -0400
In-Reply-To: <20080319084344.0FDE310806C@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-03-19 at 01:43 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9010
> 
> 
> protasnb@gmail.com changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |linux-scsi@vger.kernel.org
> 
> 
> 
> 
> ------- Comment #24 from protasnb@gmail.com  2008-03-19 01:43 -------
> Since bug analysis shows this is scsi layer problem - copying to SCSI devel

That's rather a long bug report; what I can't seem to find is a
description of what the problem actually is.  If I had to guess I'd say
that unplugging and replugging a different SATA drive in the same slot
doesn't properly get the parameters of the new device; is that it?

James


