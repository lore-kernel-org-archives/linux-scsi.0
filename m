From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Date: Wed, 1 Jul 2009 16:58:43 +0100
Message-ID: <20090701155843.GE13837@shadowen.org>
References: <1245756306-29023-1-git-send-email-apw@canonical.com> <1245756306-29023-2-git-send-email-apw@canonical.com> <1245771089.4149.88.camel@mulgrave.site> <20090623160408.GA22716@smurf.noris.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:44576 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZGAP6n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2009 11:58:43 -0400
Content-Disposition: inline
In-Reply-To: <20090623160408.GA22716@smurf.noris.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 06:04:08PM +0200, Matthias Urlichs wrote:
> Hi,
> 
> James Bottomley:
> > Firstly, Matthias, can you see if on an unmodified aacraid, this fixes
> > the problem for you:
> > 
> > echo 63 > /sys/block/<disk>/queue/max_sectors_kb
> > 
> Thank you, I'll do that tonight.

How did this one work out for you?  I don't think I saw a reply either
way?

-apw
