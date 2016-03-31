From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] uas: Add a new NO_REPORT_LUNS quirk
Date: Thu, 31 Mar 2016 10:17:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1603311014480.2252-100000@iolanthe.rowland.org>
References: <1459426971-11927-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459426971-11927-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Webb <djw-8SE8IwxHpK9aa/9Udqfwiw@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 31 Mar 2016, Hans de Goede wrote:

> Add a new NO_REPORT_LUNS quirk and set it for Seagate drives with
> an usb-id of: 0bc2:331a, as these will fail to respond to a
> REPORT_LUNS command.

> @@ -532,6 +532,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
>  		case 'i':
>  			f |= US_FL_IGNORE_DEVICE;
>  			break;
> +		case 'j':
> +			f |= US_FL_NO_REPORT_LUNS;
> +			break;
>  		case 'l':
>  			f |= US_FL_NOT_LOCKABLE;
>  			break;

You forgot to document this new module parameter flag in 
Documentation/kernel-parameters.txt.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
