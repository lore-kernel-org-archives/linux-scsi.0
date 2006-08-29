From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi_transport_sas: remove local_attached flag
Date: Tue, 29 Aug 2006 10:35:11 -0500
Message-ID: <1156865712.3458.20.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D702E282F@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:65450 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965029AbWH2PfT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 11:35:19 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D702E282F@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-08-29 at 09:24 -0600, Moore, Eric wrote:
> If the tools are fine with you. Then nothing needs to be done.  I
> could 
> add support in fusion for sending internal smp passthru, or we can
> export 
> a smp portal for you.  The smp portal should still be in the future
> plans 
> for the bsg driver.

I think the object should be to have all the SAS cards display the same
thing, so support for internal SMP passthrough looks to be the way to
implement this.  Also, if the SAS transport class does this, then we can
hook that up to BSG instead of having to have the drivers do it
individually.

I understood there was some architectural objection to doing SMP
passthrough from the LSI architects ... does that still exist?

James


