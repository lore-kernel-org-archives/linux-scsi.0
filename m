From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] gdth: integer overflow in ioctl
Date: Thu, 21 Oct 2010 09:29:39 +0200
Message-ID: <20101021072939.GF5985@bicker>
References: <20101008070307.GF11681@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34370 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0JUH3y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2010 03:29:54 -0400
Content-Disposition: inline
In-Reply-To: <20101008070307.GF11681@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, Oct 08, 2010 at 09:03:07AM +0200, Dan Carpenter wrote:
> gdth_ioctl_alloc() takes the size variable as an int.
> copy_from_user() takes the size variable as an unsigned long.
> gen.data_len and gen.sense_len are unsigned longs.
> On x86_64 longs are 64 bit and ints are 32 bit.
> 
> We could pass in a very large number and the allocation would truncate
> the size to 32 bits and allocate a small buffer.  Then when we do the
> copy_from_user(), it would result in a memory corruption.
> 
> CC: stable@kernel.org
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

I never know if anyone gets my emails and so I has a small sad face on
the front of my head here: --------------->   :(

regards,
dan carpenter


