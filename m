From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] uas: Set no_report_opcodes
Date: Tue, 9 Sep 2014 09:01:50 -0700
Message-ID: <20140909160150.GA15724@infradead.org>
References: <1410274800-11578-1-git-send-email-hdegoede@redhat.com>
 <1410274800-11578-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1410274800-11578-2-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 09, 2014 at 04:59:59PM +0200, Hans de Goede wrote:
> asm1051e usb <-> sata bridges hang when receiving a report opcodes scsi cmnd.
> Take a page out of the usb-storage book, and simple disable no_report_opcodes
> outright.

Given that this device also seems broken in other ways can we wait a bit
before using the big hammer?  I'm still hoping UAS might give us some
better SCSI implementation so that we don't have to disable any kind of
advanced feature.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
