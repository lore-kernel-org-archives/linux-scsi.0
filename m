From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/6] lpfc 8.3.21: Update lpfc to revision 8.3.21
Date: Wed, 16 Feb 2011 12:04:19 -0600
Message-ID: <1297879459.3014.200.camel@mulgrave.site>
References: <1297877936.1492.19.camel@wookie>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41229 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab1BPSEY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 13:04:24 -0500
In-Reply-To: <1297877936.1492.19.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2011-02-16 at 12:38 -0500, James Smart wrote:
> This patch set updates the lpfc driver to revision 8.3.21
> 
> The patches for 8.3.21. contain:
> 
> - Critical Errors and Bug Fixes
> - RRQ Implementation fixes.
> - FC Discovery changes.
> - Initialization and user interface changes.
> - Debugfs additions.
> - Change lpfc driver version to 8.3.21.
> 
> The bugfixes were cut against scsi-misc-2.6

So I'll apply them agains the scsi-misc tree for the next merge window,
but would a cc: stable@kernel.org tag be appropriate?  As in will they
apply on their own to the stable tree once upstream?

James


