From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/5] scsi_debug: Implement support for DIF Type 2
Date: Thu, 27 Aug 2009 14:30:13 +0000
Message-ID: <1251383413.6426.22.camel@mulgrave.site>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	 <1251267481-24135-6-git-send-email-martin.petersen@oracle.com>
	 <4A952D54.5010102@panasas.com> <yq1ab1l91zy.fsf@sermon.lab.mkp.net>
	 <4A965366.7080409@panasas.com> <1251380478.6426.11.camel@mulgrave.site>
	 <4A96962A.8050208@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbZH0OaP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 10:30:15 -0400
In-Reply-To: <4A96962A.8050208@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Thu, 2009-08-27 at 17:20 +0300, Boaz Harrosh wrote:
> On 08/27/2009 04:41 PM, James Bottomley wrote:
> > 
> > The general rule is not to confuse coding styles, so the correct way to
> > add stuff is to use the existing conventions in the file.  You can
> > optionally convert the entire style if necessary.  However, for these
> > get_cpu_be macros, there's no real benefit other than saving typing, so
> > a global conversion effort simply isn't worth it.
> > 
> 
> This is not right. The get_cpu_be macros are ten fold faster and smaller
> on all the platforms we ever use. I'm talking about 16-96 to 1 for a 64 bit
> operation.

Assembly comparisons didn't bear this out the last time I looked; what
changed?

> Not to mention the heart attack it gives me every time. Is that index go down
> or up? the shifts go bigger or smaller? even just for that I would wrap them,
> triple check, and never use anything else. But the stronger fact of the matter
> is that I don't think there is a single used ARCH that does shifts anymore.

OK, but for those of us who read the standards, they explicitly specify
byte offset fields for everything, so cmnd[n] does map exactly to that,
so I find the fully folded out form easier to read and compare with the
relevant standard text.

That's why I'm not mandating anything other than keep the styles
consistent per file.  You're free to use whatever you like in your
files.

James


