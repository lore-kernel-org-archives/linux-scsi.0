From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [14/18] qla2xxx: Use proper include files
Date: Tue, 22 Jun 2004 18:22:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622172207.GB6074@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B0DD027D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:3721 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265045AbUFVRWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 13:22:15 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD027D@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Tue, Jun 22, 2004 at 09:50:37AM -0700, Andrew Vasquez wrote:
> 
> On Tuesday, June 22, 2004 1:57 AM, Christoph Hellwig wrote:
> > >  #include <scsi/scsi_ioctl.h>
> > > +#include <scsi/scsicam.h>
> > >  #include <scsi/scsi_transport.h>
> > >  #include <scsi/scsi_transport_fc.h>
> > 
> > Umm, no.  I moved them away from qla_os.h precisly because I want to
> > get rid of that file in the next steps.
> 
> Ugg.  Ok, how about this as an alternative - add the necessary
> #includes to qla_def.h in order to support its own structure
> definitions.  Then add any specifically needed #includes in each of
> the supporting .c modules.

Sounds good to me.

> +/*
> +* String arrays
> +*/
> +#define LINESIZE    256
> +#define MAXARGS      26

IIRC these weren't actually used anywhere.

