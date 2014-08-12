From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Date: Tue, 12 Aug 2014 14:01:53 +0800
Message-ID: <20140812060153.GB13231@kroah.com>
References: <1407823717-17265-1-git-send-email-sanjeev_sharma@mentor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407823717-17265-1-git-send-email-sanjeev_sharma@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: hdegoede@redhat.com, kraxel@redhat.com, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 12, 2014 at 11:38:37AM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration and therefore it
> would be advise to replace with lockdep_assert_held().

Add "on some architectures" in here somewhere, as it's not broken on the
large majority of UP cpus :)

thanks,

greg k-h
