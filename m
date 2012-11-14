From: Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Try #3: Use SCSI read/write(16) with > 32-bit LBA drives
Date: Thu, 15 Nov 2012 02:22:46 +0400
Message-ID: <50A419B6.4070605@mvista.com>
References: <1352930602-3505-1-git-send-email-hernejj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352930602-3505-1-git-send-email-hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, Elliott-VXdhtT5mjnY@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 15-11-2012 2:03, Jason J. Herne wrote:

> From: "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

   You have already posted Try #3. And preferrably, information about patch 
version should be included with [PATCH] prefix like this [PATCH v4].

> Force large capacity (> 0xFFFFFFFF blocks) drives to use READ/WRITE(16) instead
> of READ/WRITE(10). Some(most/all?) USB enclosures do not like READ(10) commands
> when a large capacity drive is installed. This issue was reported and discussed
> here: http://marc.info/?l=linux-usb&m=135247705222324&w=2

> Signed-off-by: Jason J. Herne <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

WBR, Sergei


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
