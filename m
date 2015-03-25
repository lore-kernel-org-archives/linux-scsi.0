From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: RFC: should we deprecate unmaintained isa-only drivers?
Date: Wed, 25 Mar 2015 21:52:53 +0100
Message-ID: <201503252152.53914.linux@rainbow-software.org>
References: <20141230160616.GA29149@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1.atlantis.sk ([92.240.247.91]:44801 "EHLO
	smtp-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbbCYVAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2015 17:00:06 -0400
In-Reply-To: <20141230160616.GA29149@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Miroslav Zagorac <zaga@fly.cc.fer.hr>, Dario Ballabio <ballabio_dario@emc.com>

On Tuesday 30 December 2014 17:06:16 Christoph Hellwig wrote:
> We've got a few very old, isa-only SCSI HBA drivers in the tree.  Of
> those only one (aha152x) sas significant maintaince since the dawn
> of git, all others only saw global / automatic updates.  4 of those
> are fairly trivial wrappers aroudn the NCR538 core, so I don't mind
> keeping them:
>
>  - dtc
>  - g_NCR5380
>  - pas16
>  - t128
>
> but I'd love to know if anyone is actually using the other drivers:
>
>  - wd7000
>  - aha1542
>  - in2000
>  - NCR53c406
>  - sym53c416
>  - u14-34f
>  - ultrastor

NCR53c406a and sym53c416 look very similar. The register numbers and commands 
are almost the same so NCR53c406 support could probably be added to sym53c416 
driver (looks better of the two) and NCR53c406a driver removed. Now I have 
cards with both chips so I'll try.

-- 
Ondrej Zary
