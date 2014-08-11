From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Date: Mon, 11 Aug 2014 16:28:11 +0800
Message-ID: <20140811082811.GC1422@kroah.com>
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: hdegoede@redhat.com, kraxel@redhat.com, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 11, 2014 at 01:29:26PM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration

Really?  On what processor type?  I don't see that being the case on a
few processors, but I didn't check them all, or I might be totally
confused with all of the arch_spin_is_locked() definitions in the tree.

> and therefore it
> would be advise to repalce with assert_spin_locked().

This implies that all uses of this function is wrong and should be
replaced and removed, right?

thanks,

greg k-h
