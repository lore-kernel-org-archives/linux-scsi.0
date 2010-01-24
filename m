From: Gal Rosen <galr@storwize.com>
Subject: Re: [PATCH] SCSI: Synchronization issue while deleting vport
Date: Sun, 24 Jan 2010 09:20:16 +0200
Message-ID: <1264317616.17255.4.camel@galr-linux>
References: <1264061732.31083.51.camel@galr-linux>
	 <4B5A5859.1010006@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:3005 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752520Ab0AXHVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jan 2010 02:21:34 -0500
In-Reply-To: <4B5A5859.1010006@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

What is the process until it will enter to the code ?
and for what version 2.6.26 or 2.6.33 ?

Thanks,
Gal.
On Fri, 2010-01-22 at 21:00 -0500, James Smart wrote:
> Gal,
> 
> Thanks for correcting this issue.  Patch looks good.
> 
> Signed-off-by: James Smart <james.smart@emulex.com>
> 
> 
> 
> Gal Rosen wrote:
> > Hi,
> > 
> > Attach proposed patch for the PROBLEM: Synchronization issue in
> > scsi_transport_fc.
> > 
> > Gal Rosen.
> > 
> 

