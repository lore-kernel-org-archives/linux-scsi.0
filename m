From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Fix error path when adding sysfs attributes
Date: Fri, 16 Jan 2004 13:29:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116212926.GB1183@beaverton.ibm.com>
References: <20040116192801.GT27591@localhost> <20040116194839.GA1053@beaverton.ibm.com> <20040116203325.GX27591@localhost> <20040116205223.GY27591@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:39828 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265792AbUAPVYb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 16:24:31 -0500
Content-Disposition: inline
In-Reply-To: <20040116205223.GY27591@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@bork.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Martin Hicks [mort@bork.org] wrote:
> 
> 
> On Fri, Jan 16, 2004 at 03:33:25PM -0500, Martin Hicks wrote:
> > 
> > 
> > On Fri, Jan 16, 2004 at 11:48:39AM -0800, Mike Anderson wrote:
> > > While we are cleaning there appears to also be an extra return on line
> > > 364 after a goto. It might be good to include this change in the patch.
> > > 
> > 
> > Good idea.  Here's an updated patch that fixes the original bugs, the
> > extra "return" and a bit of whitespace.
> > 

Looks good. Thanks.

-andmike
--
Michael Anderson
andmike@us.ibm.com

