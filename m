From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: [Bugme-new] [Bug 2147] New: my scsi emulated cdrom is locked
Date: Fri, 20 Feb 2004 08:25:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040220072508.GC27190@suse.de>
References: <20040219122414.73fd7c6c.akpm@osdl.org> <20040220005223.GW4957@serve.riede.org> <20040219171332.08ea4011.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:40345 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267700AbUBTHZR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 02:25:17 -0500
Content-Disposition: inline
In-Reply-To: <20040219171332.08ea4011.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: wrlk@riede.org, linux-scsi@vger.kernel.org

On Thu, Feb 19 2004, Andrew Morton wrote:
> Willem Riede <wrlk@riede.org> wrote:
> >
> > I have had a proposed update to 
> > ide-scsi's error handling out for review for some time, see
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=107246268217888&w=2
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=107443923827330&w=2
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=107558923328533&w=2
> > 
> > If there are no comments on it, perhaps it can be given some exposure (e.g. in
> > -mm patches) to get user feedback?
> 
> I think Jens was digging himself in the ribs over this.
> 
> If you have a patch you want tested then sure, sling it across.

Yeah... William, send the last patch you had without any style cleanups
to Andrew. There's no reason it can't sit in -mm for a little while,
while getting reviewed.

-- 
Jens Axboe

