From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: UAS crash with Apricorn USB3 SATA bridge
Date: Wed, 10 Dec 2014 09:19:04 +0100
Message-ID: <548801F8.8080207@redhat.com>
References: <20141209193116.GA25163@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141209193116.GA25163-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09-12-14 20:31, Darrick J. Wong wrote:
> Hi,
>
> I have an Apricorn USB 3 disk dongle thing that claims to support UAS.
> However, the kernel crashes when I plug it in[1].

Yes there are some known issues with uas error handling which are fixed
in 3.18, can you try with a 3.18 kernel please ?

Note that the device will likely still not work, but it should no
longer crash things. When running 3.18 please collect the output of
"dmesg" after plugging in the drive and send that to me, then we'll see
if we can get it to work from there.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
