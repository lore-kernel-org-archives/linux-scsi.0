From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: use block-layer tags
Date: 13 Oct 2004 16:49:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097704168.1714.262.camel@mulgrave>
References: <Pine.LNX.4.60.0410122307180.4565@poirot.grange>
	<Pine.LNX.4.60.0410132131040.3426@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15022 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269870AbUJMVta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 17:49:30 -0400
In-Reply-To: <Pine.LNX.4.60.0410132131040.3426@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-10-13 at 14:35, Guennadi Liakhovetski wrote:
> On Tue, 12 Oct 2004, Guennadi Liakhovetski wrote:
> 
> > Slightly tested. Applies on the top of all up to date tmscsim patches (if 
> > I didn't miss any). Reviews, tests highly welcome. Inline patch should be 
> > fine now. Will re-send if still not...
> 
> I think, there was (at least) one missing chunk in the first version of 
> the patch. Here's an updated version. Patch inlining seems to work indeed 
> now.

This doesn't want to apply to scsi-misc-2.6 ...

Patch failed.  **** patch log follows ****
Patching file drivers/scsi/tmscsim.c
11 out of 13 hunks FAILED -- saving rejects to file
drivers/scsi/tmscsim.c.rej

James


