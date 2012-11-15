From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] Try #3: Use SCSI read/write(16) with > 32-bit LBA drives
Date: Thu, 15 Nov 2012 04:20:51 -0500
Message-ID: <20121115092051.GA16140@infradead.org>
References: <1352930602-3505-1-git-send-email-hernejj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1352930602-3505-1-git-send-email-hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, Elliott-VXdhtT5mjnY@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 14, 2012 at 05:03:22PM -0500, Jason J. Herne wrote:
> From: "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Force large capacity (> 0xFFFFFFFF blocks) drives to use READ/WRITE(16) instead
> of READ/WRITE(10). Some(most/all?) USB enclosures do not like READ(10) commands
> when a large capacity drive is installed. This issue was reported and discussed
> here: http://marc.info/?l=linux-usb&m=135247705222324&w=2

Is there any reason not to simply use the 16 byte command
unconditionally for large devices?

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
