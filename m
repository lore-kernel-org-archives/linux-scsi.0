From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 05 Jun 2008 13:19:35 -0600
Message-ID: <20080605191935.GZ2961@webber.adilger.int>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
 <20080605104042.GB20308@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41869 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYFETTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 15:19:37 -0400
In-reply-to: <20080605104042.GB20308@shareable.org>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Jun 05, 2008  11:40 +0100, Jamie Lokier wrote:
> >From a database perspective, I'm thinking it would be very useful to
> provide similar information for large files.  Database engines have
> the same requirement to know stripe width etc., and filesystems
> allocate large contiguous extents so it it makes sense to pass the
> device characteristics up to the app, with appropriate offset.
> 
> (Same for loopback devices.)
> 
> This is an extreme example of different properties in different offset
> ranges - it depends on file allocation.
> 
> Is there scope to extend FIEMAP to pass this sort of information?

I have ideas in that direction, but have been gun-shy about presenting
them until the existing controversy dies down...  I think it is actually
fairly straight forward to enhance FIEMAP to allow arbitrary file layouts
to be returned to an application.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

