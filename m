From: Christoph Hellwig <hch@infradead.org>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Tue, 6 Sep 2005 12:43:50 +0100
Message-ID: <20050906114350.GE5309@infradead.org>
References: <20050811164003.GB4351@infradead.org> <OFD1AF1EB2.F396BA40-ONC125705A.005C072D-C125705A.005C7944@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:16857 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964818AbVIFLn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2005 07:43:58 -0400
Content-Disposition: inline
In-Reply-To: <OFD1AF1EB2.F396BA40-ONC125705A.005C072D-C125705A.005C7944@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Seipp <SEIPP@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Aug 11, 2005 at 06:50:03PM +0200, Harald Seipp wrote:
> Christoph Hellwig wrote on 11.08.2005 18:40:03:
> > On Thu, Aug 11, 2005 at 05:44:46PM +0200, Harald Seipp wrote:
> > > Thank you for your quick responses! It finally looks like the task I
> need
> > > to do - fully rescan all hosts for newly attached/changed devices -
> must
> > > include the logic to skip devices with mounted fs for 2.6.
> >
> > Why do you want to rescan a full bus anyway?  What SCSI transport do you
> > want this for?  All transports where new targets can be hot-plugged
> should
> > be doing automatic scanning already.
> Old-fashioned parallel SCSI bus and FC/SAN where there are no hot-plug
> events AFAIK.

In FC you get per-target events, although none for new LUs showing up
on a given target (in fact no SAM transport does the latter)

