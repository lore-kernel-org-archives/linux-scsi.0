From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: dc395x: can't write to tape
Date: Sun, 9 Jan 2005 23:51:17 +1100
Message-ID: <20050109125116.GA6293@twibble.org>
References: <200501060518.25782.andrex@alumni.utexas.net> <Pine.LNX.4.60.0501062138580.7568@poirot.grange> <20050109053342.GA5799@twibble.org> <Pine.LNX.4.60.0501091238010.3910@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nynaeve.twibble.org ([202.173.155.194]:33955 "EHLO
	nynaeve.twibble.org") by vger.kernel.org with ESMTP id S261377AbVAIMvT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jan 2005 07:51:19 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0501091238010.3910@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Andrew Schulman <andrex@alumni.utexas.net>, linux-scsi@vger.kernel.org

On Sun, Jan 09, 2005 at 12:42:26PM +0100, Guennadi Liakhovetski wrote:
[...]
> The driver is full of "hardware bug workarounds". Jamie, are those PIO 
> operations really needed? Do you ever see, that DMA doesn't transfer the 
> last 1-3 bytes of the segment?

What I suspect those workarounds were added for was to handle a
driver bug with dealing with WIDE transfers. The dc315 doesn't
support WIDE transfers and that's the card I have.

I wouldn't mind removing all the PIO code and disabling support for
WIDE devices. It'll simplify various bits of code a lot and mean no
longer having to be concered about breaking things for the dc395 when
making changes. 

[...]
> I could try to improve the highmem situation / sg-handling. Or do you plan 
> to do it, Jamie?

It's on my list of things to do, but I doubt I'll have any time to do
anything about in the next few months. So if you have the time and
desire please go ahead! I'll can test any changes you make (with a
CD-R/W, tape-drive and HDD), although it may take me a week or two to
get around to it.

-- 
 Jamie Lenehan <lenehan@twibble.org>
