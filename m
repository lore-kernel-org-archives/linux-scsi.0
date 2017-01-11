From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Wed, 11 Jan 2017 14:33:17 +0100
Message-ID: <20170111133317.GA31565@pali>
References: <Pine.LNX.4.44L0.1701101551591.2462-100000@iolanthe.rowland.org>
 <1484086345.2518.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34948 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932177AbdAKNdZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 08:33:25 -0500
Content-Disposition: inline
In-Reply-To: <1484086345.2518.9.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dainius =?utf-8?Q?Masili=C5=ABnas?= <pastas4@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

On Tuesday 10 January 2017 14:12:25 James Bottomley wrote:
> On Tue, 2017-01-10 at 16:00 -0500, Alan Stern wrote:
> > In theory, I suppose we could change the kernel so that it would 
> > default to READ CAPACITY(16) for devices that report a SCSI level >= 
> > 3, or something along those lines.  In general we hesitate to make
> > changes of this sort, because they almost always end up breaking 
> > _some_ devices -- and if that happens then the change is reverted, 
> > with no exceptions.  Linus has a very strict rule about not breaking 
> > working systems.
> 
> You shouldn't have to change anything: it already does (otherwise how
> else would we detect physical exponent for proper SCSI devices) see
> sd.c:sd_try_rc16_first().  It always returns false for USB because you
> set sdev->try_rc_10_first

So.. what does it mean? Can we enable READ CAPACITY(16) for some USB
devices?

-- 
Pali Rohár
pali.rohar@gmail.com
