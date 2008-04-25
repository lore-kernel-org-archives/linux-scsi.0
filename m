From: Pekka J Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before	mounting
 root
Date: Fri, 25 Apr 2008 09:09:18 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0804250907120.27149@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080424225604.GA18737-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsd-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 Apr 2008, Greg KH wrote:
> What happens if there is no USB device present in the system?  Because
> of that, there is no way that this option could ever be enabled by any
> distro or anyone wanting their kernel to run on more than one machine :(

Not sure what you mean. If there are no USB devices present on the system, 
the boot proceeds as usual. The config option will make the kernel wait 
only if you have a USB mass storage device (or some other device that 
cause async SCSI scanning) _plugged in_.

		Pekka
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
