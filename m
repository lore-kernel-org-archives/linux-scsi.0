From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add attribute container to the generic device model
Date: Wed, 12 Jan 2005 15:19:08 -0800
Message-ID: <20050112231908.GC15085@kroah.com>
References: <1105506370.10378.26.camel@mulgrave> <20050112070802.GB2085@kroah.com> <1105561045.8030.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261581AbVALX0X@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1105561045.8030.2.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 12, 2005 at 02:17:25PM -0600, James Bottomley wrote:
> How about the attached.  It makes all the symbols EXPORT_SYMBOL_GPL,
> updates the docs for the attribute_container_add_device function and
> also integrates with the driver_init() function of drivers/base.

Looks good to me.  Feel free to push this with your scsi tree and you
can add:

Signed-off-by: Greg Kroah-Hartman <greg@kroah.com>

if you want to.

Again, nice job.  Now lets see about adding some pressure to SATA to use
this :)

thanks,

greg k-h
