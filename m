From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
Date: Tue, 08 May 2007 15:41:47 -0500
Message-ID: <1178656907.3737.93.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
	 <1178567419.3729.44.camel@mulgrave.il.steeleye.com>
	 <20070507140656.3debfb55.akpm@linux-foundation.org>
	 <1178637060.3737.15.camel@mulgrave.il.steeleye.com>
	 <20070508121411.d187a648.akpm@linux-foundation.org>
	 <1178652273.3737.67.camel@mulgrave.il.steeleye.com>
	 <20070508131152.0003b770.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55977 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934109AbXEHUly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 16:41:54 -0400
In-Reply-To: <20070508131152.0003b770.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Tue, 2007-05-08 at 13:11 -0700, Andrew Morton wrote:
> On Tue, 08 May 2007 14:24:32 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > However, could we compromise and just add TRUE = true, FALSE = false to
> > the enum?
> 
> That sounds sane.  But I don't recall all the details of the discussion
> and perhaps I'm missing something.
> 
> I think the whole bool/true/false thing is pretty dissatisfactory really. 
> Java gets this right and C cannot and will not and we end up with people
> using true and false as plain old "1" and "0".

Right, that's the core of my complaint ... zero is false and anything
else is true ... I rather like the C isms that allow things like

if (ptr)
	*ptr = ...

If there were evidence that the C treatment of logicals as arithmeticals
was causing huge problems for driver writers, then yes I'd reconsider my
position ... but really any driver writer has to use bare metal
arithmetical values interchangeably with logical values because that's
the way device registers work.

James


