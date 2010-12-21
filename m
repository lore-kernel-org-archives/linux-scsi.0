From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2a/7] SCST core / sysfs interface
Date: Tue, 21 Dec 2010 11:01:29 -0800
Message-ID: <20101221190129.GA10717@suse.de>
References: <201012211105.49590.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab0LUTC1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 14:02:27 -0500
Content-Disposition: inline
In-Reply-To: <201012211105.49590.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@suse.de, Dmitry Torokhov <dmitry.torokhov@gmail.com>

On Tue, Dec 21, 2010 at 11:05:49AM +0100, Bart Van Assche wrote:
> Apparently patch 2/7 did not make it to the linux-scsi mailing list, probably
> because it was too big. So I'm resending the part of that patch that underwent
> the most changes since the previous time the SCST core was posted, namely the
> sysfs interface. Please let me know if other parts of the core should be posted
> again for review on the linux-scsi mailing list too.
> 
> This is what has been changed in the sysfs code since the previous time the
> SCST core was posted for review:
> - Instead of creating kernel objects in /sys/kernel/scst_tgt, the
>   bus/driver/device infastructure is now used.
> - The sysfs worker thread has been eliminated.
> -  A locking strategy for scst_mutex versus sysfs locking has been defined.
> - Several races between registration and unregistration functions have been fixed.
> - Several wait loops and state variables have been eliminated.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> diff --git a/Documentation/scst/SysfsRules b/Documentation/scst/SysfsRules

That's fine, but you need to properly create the files in
Documentation/ABI for your sysfs files.  Please do that as well.

thanks,

greg k-h
