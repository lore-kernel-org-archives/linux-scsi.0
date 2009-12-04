From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/1] lpfc: lpfc no longer discovers lun 255
Date: Fri, 04 Dec 2009 11:58:38 -0600
Message-ID: <1259949518.8360.90.camel@mulgrave.site>
References: <4B1932FA.7080407@sgi.com> <4B1949E3.8040400@emulex.com>
	 <4B194D1D.3060309@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbZLDR6j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2009 12:58:39 -0500
In-Reply-To: <4B194D1D.3060309@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, Ed Lin <ed.lin@promise.com>

On Fri, 2009-12-04 at 11:55 -0600, Michael Reed wrote:
> Yeah.  I'm working on a patch for qla1280.c also.  Probably others
> have been hit.  It would have been nice if the patch author had
> fixed all the drivers instead of introducing this change and waiting
> for people to discover their last lun is now missing.

Actually, lets just revert this:

commit 71c309995bff5b5e84253931888b6e8163ee1df0
Author: Ed Lin <ed.lin@promise.com>
Date:   Fri Oct 9 15:23:27 2009 -0700

    [SCSI] fix inconsistent usage of max_lun

Which is causing all the problems.  Perhaps we need to update the
documentation instead?

James


