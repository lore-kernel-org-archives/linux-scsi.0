From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12759] scsi: aic7xxx hang since v2.6.28-rc1 ...
Date: Sat, 14 Mar 2009 17:51:04 -0500
Message-ID: <1237071064.3907.76.camel@localhost.localdomain>
References: <20090314211820.D47F9108047@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47707 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbZCNWvI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 18:51:08 -0400
In-Reply-To: <20090314211820.D47F9108047@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Sat, 2009-03-14 at 14:18 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12759
> 
> 
> rjw@sisk.pl changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>              Status|NEW                         |CLOSED
>          Resolution|                            |CODE_FIX
> 
> 
> 
> 
> ------- Comment #1 from rjw@sisk.pl  2009-03-14 14:18 -------
> The problem seems to have been fixed, closing.

Actually, I don't think the problem is gone, it's just gone into hiding
again.  What seems to happen is that as we alter code in scsi_lib.c,
particularly along the completion paths, it reappears and then
disappears again.  It looks like some obscure timing related bug,
possibly in the aic7xxx driver, or possibly in the mid-layer 

I've rebuilt my main SCSI test box to be aic7xxx based to see if we can
somehow find it again and debug it.

So, I'd like this bug left open against SCSI please, but you can
probably remove it as a current regression (I think it's probably been
hiding for a very long time).

James


