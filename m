From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 9/9] osd_protocol.h: Add missing #include
Date: Mon, 16 Nov 2009 14:01:34 -0600
Message-ID: <1258401694.2517.245.camel@mulgrave.site>
References: <4B019BEC.3080909@panasas.com>
	 <1258397365-356-1-git-send-email-bharrosh@panasas.com>
	 <20091116185741.GH8113@deprecation.cyrius.com>
	 <4B01A174.8000005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbZKPUBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2009 15:01:43 -0500
In-Reply-To: <4B01A174.8000005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On Mon, 2009-11-16 at 21:01 +0200, Boaz Harrosh wrote:
> On 11/16/2009 08:57 PM, Martin Michlmayr wrote:
> > * Boaz Harrosh <bharrosh@panasas.com> [2009-11-16 20:49]:
> >> From: Martin Michlmayr <tbm@cyrius.com>
> >>
> >> include/scsi/osd_protocol.h uses ALIGN() without an #include
> >> <linux/kernel.h>, leading to:
> >> | include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'
> > 
> > Note that this patch also has to go into 2.6.32, where OSD currently
> > builds to build (at least on ARM).
> 
> OK in that case we need to CC: stable@kernel.org, inside the patch
> 
> James could you add it to the patch? Should I re-post?

I can add it.

James


