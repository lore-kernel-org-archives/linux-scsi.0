From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] USB: uas: Fix slave queue_depth not being set
Date: Mon, 13 Jun 2016 14:56:37 +0200
Message-ID: <ffea547b-f6a4-2cfa-ea78-810632ec1e01@redhat.com>
References: <1464679083-2914-1-git-send-email-hdegoede@redhat.com>
 <1464679083-2914-2-git-send-email-hdegoede@redhat.com>
 <1465819550.15666.23.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465819550.15666.23.camel-IBi9RG/b67k@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 13-06-16 14:05, Oliver Neukum wrote:
> On Tue, 2016-05-31 at 09:18 +0200, Hans de Goede wrote:
>> Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level")
>> removed the scsi_change_queue_depth() call from uas_slave_configure()
>> assuming that the slave would inherit the host's queue_depth, which
>> that commit sets to the same value.
>>
>> This is incorrect, without the scsi_change_queue_depth() call the slave's
>> queue_depth defaults to 1, introducing a performance regression.
>
> Hans, may I ask what become of this patch? I don't see it in the queue.

It is here:

https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/?h=usb-linus&id=593224ea77b1ca842f45cf76f4deeef44dfbacd1

Which is part of:

https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/log/?h=usb-linus

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
