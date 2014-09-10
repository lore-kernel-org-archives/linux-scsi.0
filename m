From: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 01/21] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Date: Wed, 10 Sep 2014 13:56:24 +0200
Message-ID: <1410350184.12706.18.camel@linux-fkkt.site>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
	 <1410349611-17573-2-git-send-email-hdegoede@redhat.com>
	 <54103AA3.7000801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54103AA3.7000801-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sanjeev Sharma <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-09-10 at 13:48 +0200, Hans de Goede wrote:
> Hi,
> 
> Note this series is NOT intended for stable, but I accidentally
> had "cc = stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" in my .git/config when sending
> this series, please ignore for stable.
> 
> NACK for stable.

If this is not for stable, what do you intend to do about
the problems in stable? For example patch#01 of this series
looks like clear stable material to me.

	Regards
		Oliver


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
