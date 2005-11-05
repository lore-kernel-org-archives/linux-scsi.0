From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.14
Date: Sat, 05 Nov 2005 12:33:14 -0600
Message-ID: <1131215595.3614.13.camel@mulgrave>
References: <1131207491.3614.5.camel@mulgrave>
	 <Pine.LNX.4.64.0511050942490.3316@g5.osdl.org>
	 <1131214408.3614.11.camel@mulgrave>  <436CF8FC.5070906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32993 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932170AbVKESdZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Nov 2005 13:33:25 -0500
In-Reply-To: <436CF8FC.5070906@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-11-05 at 13:25 -0500, Jeff Garzik wrote:
> Do you have standard permissions (chmod -R og+rX) on your repo, and, are 
> you using rsync to push to kernel.org?
> 
> I've attached my rsync-based push script.  git people seem to dislike 
> rsync, but this tends to work every time, for all users.

No, I push to my scsi-misc-2.6 repository and then clone that on hera
for linus.  the scsi-misc-2.6 permissions are fine, it was the clone -l
on hera that caused the problems.

James


