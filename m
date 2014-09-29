From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 33/38] libata: use __scsi_print_command()
Date: Mon, 29 Sep 2014 10:11:44 -0400
Message-ID: <20140929141144.GC15925@htj.dyndns.org>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
 <1411991947-130166-34-git-send-email-hare@suse.de>
 <20140929140606.GB15925@htj.dyndns.org>
 <54296856.2020104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61255 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaI2OLt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2014 10:11:49 -0400
Content-Disposition: inline
In-Reply-To: <54296856.2020104@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, Sep 29, 2014 at 04:10:30PM +0200, Hannes Reinecke wrote:
> On 09/29/2014 04:06 PM, Tejun Heo wrote:
> > On Mon, Sep 29, 2014 at 01:59:02PM +0200, Hannes Reinecke wrote:
> >> libata already uses an internal buffer, so we should be using
> >> __scsi_print_command() here.
> >>
> >> Cc: Tejun Heo <tj@kernel.org>
> >> Cc: linux-ide@vger.kernel.org
> >> Cc: LKML <linux-kernel@vger.kernel.org>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> > 
> > Applied to libata/for-3.18.
> > 
> > Thanks.
> > 
> Errm.
> Nice that you did, but it sort of relies for patches 01-32 to be
> applied previously.
> I'd rather apply your Signed-off-by: to the patch and have it
> routed through the SCSI tree; that way we're sure it'll only be
> applied if the previous patches are in.
> 
> Can you please pull it from libata to avoid build issues?

Ah, okay, pulled it.  Please feel free to add

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
