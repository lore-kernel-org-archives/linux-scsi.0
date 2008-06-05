From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Thu, 05 Jun 2008 16:51:00 -0500
Message-ID: <1212702660.4241.31.camel@localhost.localdomain>
References: <20080605212637.66A0C108047@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52563 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbYFEVvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 17:51:05 -0400
In-Reply-To: <20080605212637.66A0C108047@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-06-05 at 14:26 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=10861
> 
> 
> 
> 
> 
> ------- Comment #1 from rjw@sisk.pl  2008-06-05 14:26 -------
> Caused by:
> 
> commit b0ed43360fdca227048d88a08290365cb681c1a8
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Mar 18 14:32:28 2008 +0100
> 
>     [SCSI] add scsi_host and scsi_target to scsi_bus
> 
>     Signed-off-by: Hannes Reinecke <hare@suse.de>
>     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
 
This looks like another manifestation of the bus_uevent problem ... does
2.6.26-rc5 work OK?

James


