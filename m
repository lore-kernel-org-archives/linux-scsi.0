From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_level constants in scsi.h
Date: Tue, 24 Aug 2004 12:52:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824125239.A28215@infradead.org>
References: <412B28F8.8000107@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:58632 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267548AbUHXLwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 07:52:40 -0400
Content-Disposition: inline
In-Reply-To: <412B28F8.8000107@torque.net>; from dougg@torque.net on Tue, Aug 24, 2004 at 09:39:36PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2004 at 09:39:36PM +1000, Douglas Gilbert wrote:
> The scsi_level value in struct scsi_device is a bit
> mysterious. Hopefully this patch makes it a bit clearer
> since it is visible via sysfs.
> 
> Changes:
>    - add scsi_level constants for SPC-2 and SPC-3
>    - comment on relationship between scsi_level and INQUIRY response

Looks cool.  What about turning it into an enum while you're at it?

