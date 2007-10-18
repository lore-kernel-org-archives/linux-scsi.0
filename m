From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Add suspend/resume support for aic7xxx/aic79xx
Date: Thu, 18 Oct 2007 08:37:37 -0400
Message-ID: <1192711057.13229.33.camel@localhost.localdomain>
References: <47161877.1090000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44518 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757306AbXJRMhp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 08:37:45 -0400
In-Reply-To: <47161877.1090000@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2007-10-17 at 16:13 +0200, Hannes Reinecke wrote:
> Hi James,
> 
> due to popular demand I've clobbered together a patch for
> suspend/resume support in aic79xx/aic7xxx.
> 
> Looks reasonable enough, boots, but now I'd need someone
> to actually test it :-)
> 
> As usual, comments, results, fixes, etc. welcome.

This doesn't actually compile for me:

drivers/scsi/aic7xxx/aic7770.c:158: error: 'struct ahc_softc' has no
member named 'bus_suspend'
drivers/scsi/aic7xxx/aic7770.c:159: error: 'struct ahc_softc' has no
member named 'bus_resume'
make[3]: *** [drivers/scsi/aic7xxx/aic7770.o] Error 1

James


