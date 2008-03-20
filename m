From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 6280] new line of Xyratex RAID products and a patch to
	update for 2.4.x non-sequential LUN mapping
Date: Thu, 20 Mar 2008 08:51:55 -0500
Message-ID: <1206021115.3038.0.camel@localhost.localdomain>
References: <20080320073456.F366D108039@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48639 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbYCTNwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 09:52:01 -0400
In-Reply-To: <20080320073456.F366D108039@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-03-20 at 00:34 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=6280
> 
> 
> protasnb@gmail.com changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |protasnb@gmail.com
>          AssignedTo|scsi_drivers-other@kernel-  |linux-scsi@vger.kernel.org
>                    |bugs.osdl.org               |
> 
> 
> 
> 
> ------- Comment #2 from protasnb@gmail.com  2008-03-20 00:34 -------
> Petros,
> This bugzilla is about 2.6.XX. Do you think your patch makes sense for latest
> kernels, or this support is already implemented there?

Depends what SCSI level the array reports.  If > 2 then the REPORT_LUNS
scan will already have taken care of all of this.

James


