From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Make scsi error recovery play nice with devices	blocked by transport
Date: Fri, 13 Jan 2006 20:38:37 +0100
Message-ID: <20060113193837.GB5668@lst.de>
References: <43A35498.6030903@sgi.com> <43B2B77B.20602@emulex.com> <43BEE23E.8040707@sgi.com> <43C27ABC.2020504@emulex.com> <1136821157.3364.11.camel@mulgrave> <43C7FFB4.5000801@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:31969 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422860AbWAMTir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 14:38:47 -0500
Content-Disposition: inline
In-Reply-To: <43C7FFB4.5000801@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

On Fri, Jan 13, 2006 at 01:29:56PM -0600, Michael Reed wrote:
> I'm planning on working on this once the fusion fc_transport code finally
> makes it in.  What do you see as a deadline for code addressing this problem?
> 
> Perhaps someone else already has something to address this in progress?
> It's a significant issue with our fibre channel customers.

There's not at all.  Sunday is feature deadline for 2.6.16, but we'll
happily accept everything good for 2.6.17.  OTOH this probably falls
into fixes that can go in after -rc1 anyway.
