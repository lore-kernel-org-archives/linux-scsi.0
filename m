From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH v2 1/3] uas: Allow uas_use_uas_driver to return usb-storage
 flags
Date: Tue, 21 Apr 2015 11:04:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1504211104260.1518-100000@iolanthe.rowland.org>
References: <1429608032-6910-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429608032-6910-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Steve Bangert <sbangert-/1bC63wxbnBWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 21 Apr 2015, Hans de Goede wrote:

> uas_use_uas_driver may set some US_FL_foo flags during detection, currently
> these are stored in a local variable and then throw away, but these may be
> of interest to the caller, so add an extra parameter to (optionally) return
> the detected flags, and use this in the uas driver.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16
> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

For this whole series:

Acked-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
