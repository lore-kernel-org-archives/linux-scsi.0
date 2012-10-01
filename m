From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Mon, 1 Oct 2012 12:17:46 +0300
Message-ID: <20121001091746.GA8912@reaktio.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
 <50237151.9000801@suse.com>
 <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:58259 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab2JAJRv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Oct 2012 05:17:51 -0400
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

Hello,

Hopefully these T10 patches can go in during the 3.7 merge window!

Thanks,

-- Pasi

