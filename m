From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Sun, 19 Aug 2012 17:49:32 +0300
Message-ID: <20120819144932.GT19851@reaktio.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
 <50237151.9000801@suse.com>
 <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:46342 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2HSOtg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Aug 2012 10:49:36 -0400
Content-Disposition: inline
In-Reply-To: <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

On Fri, Aug 17, 2012 at 12:00:55PM -0400, Martin K. Petersen wrote:
> >>>>> "Ankit" == Ankit Jain <jankit@suse.com> writes:
> 
> Ankit> Will these patches be merged? Or have they been superseded by
> Ankit> some other patchset?
> 
> Sorry, I've been out on vacation.
> 
> 2 of the patches are absolutely trivial and should just be applied.
> However, LSI objects to patch #3 which tweaks an incorrect NVDATA flag
> from within the driver.
> 
> Instead LSI has promised to revert to the original behavior in their
> firmware/NVDATA updates. Eric, can you give us an update? There was
> another bug report on linux-scsi just a couple of weeks ago.
> 

Btw do you know which LSI mpt2sas HBAs support T10 DIF stuff? 
(using 520 or 528 bytes/sector drives with checkums).

LSI SAS2008 based? SAS2308 based? 

Thanks,

-- Pasi

