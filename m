From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/7] Revert "usb/uas: make sure data urb is gone if we
 receive status before that"
Date: Thu, 21 Jun 2012 10:27:43 +0200
Message-ID: <4FE2DAFF.8040809@redhat.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com> <1340092494-18876-2-git-send-email-kraxel@redhat.com> <20120620235626.GC31520@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120620235626.GC31520-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 06/21/12 01:56, Greg KH wrote:
> On Tue, Jun 19, 2012 at 09:54:48AM +0200, Gerd Hoffmann wrote:
>> This reverts commit e4d8318a85779b25b880187b1b1c44e797bd7d4b.
>>
> 
> Should this revert also go into 3.4-stable so that the device will work
> properly on ehci?

Yes.

cheers,
  Gerd

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
