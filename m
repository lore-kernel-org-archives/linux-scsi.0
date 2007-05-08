From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
 boolean-values
Date: Tue, 8 May 2007 13:11:52 -0700
Message-ID: <20070508131152.0003b770.akpm@linux-foundation.org>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
	<1178567419.3729.44.camel@mulgrave.il.steeleye.com>
	<20070507140656.3debfb55.akpm@linux-foundation.org>
	<1178637060.3737.15.camel@mulgrave.il.steeleye.com>
	<20070508121411.d187a648.akpm@linux-foundation.org>
	<1178652273.3737.67.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032062AbXEHUMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 16:12:39 -0400
In-Reply-To: <1178652273.3737.67.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Tue, 08 May 2007 14:24:32 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> However, could we compromise and just add TRUE = true, FALSE = false to
> the enum?

That sounds sane.  But I don't recall all the details of the discussion
and perhaps I'm missing something.

I think the whole bool/true/false thing is pretty dissatisfactory really. 
Java gets this right and C cannot and will not and we end up with people
using true and false as plain old "1" and "0".
