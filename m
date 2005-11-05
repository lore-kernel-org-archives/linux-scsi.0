From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.14
Date: Sat, 05 Nov 2005 13:37:16 -0500
Message-ID: <436CFBDC.8060509@pobox.com>
References: <1131207491.3614.5.camel@mulgrave>	 <Pine.LNX.4.64.0511050942490.3316@g5.osdl.org>	 <1131214408.3614.11.camel@mulgrave>  <436CF8FC.5070906@pobox.com> <1131215595.3614.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:48575 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932178AbVKEShV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Nov 2005 13:37:21 -0500
In-Reply-To: <1131215595.3614.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sat, 2005-11-05 at 13:25 -0500, Jeff Garzik wrote:
> 
>>Do you have standard permissions (chmod -R og+rX) on your repo, and, are 
>>you using rsync to push to kernel.org?
>>
>>I've attached my rsync-based push script.  git people seem to dislike 
>>rsync, but this tends to work every time, for all users.
> 
> 
> No, I push to my scsi-misc-2.6 repository and then clone that on hera
> for linus.  the scsi-misc-2.6 permissions are fine, it was the clone -l
> on hera that caused the problems.

Well, _something_ is clearly screwed up in your scsi-misc-2.6 repo on 
master.kernel.org, as its the only repo that I cannot pull from (last 
successful pull was Oct 31, before I left for Portland).

	Jeff



