From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] SAM-3 status codes
Date: Thu, 23 Jan 2003 08:48:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123074845.GS910@suse.de>
References: <3E2F24DA.50206@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E2F24DA.50206@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Thu, Jan 23 2003, Douglas Gilbert wrote:
> The perverse CHECK_CONDITION in include/scsi/scsi.h seems
> to have struck again (see "Can't burn DVD under 2.5.59 with
> ide-cd" thread on the linux kernel list). Most users of
> CHECK_CONDITION found out to their surprise that it is
> shifted 1 bit (right) from those values found in the
> standards.
> 
> The attachment marks the orginal list of SCSI status codes
> as deprecated and supplies defines taken from the most
> recent SAM-3 draft.
> 
> The patch is against 2.5.59 but may also be suitable for
> the lk 2.4 tree.

Thanks Doug, the old defines were really sick, dunno who was smoking
what. I not so sure I like the naming, though. The old ones still have
the most obvious naming :(

-- 
Jens Axboe

