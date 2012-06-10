From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH v3 2/4] usb: storage: add support for write cache quirk
 on usb hdd
Date: Sun, 10 Jun 2012 13:36:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1206101335510.31367-100000@netrider.rowland.org>
References: <1339291826-2547-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339291826-2547-1-git-send-email-linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 9 Jun 2012, Namjae Jeon wrote:

> Add support for write cache quirk on usb hdd. scsi driver will be set to wce
> by detecting write cache quirk in quirk list when plugging usb hdd.

> --- a/include/linux/usb_usual.h
> +++ b/include/linux/usb_usual.h
> @@ -64,7 +64,9 @@
>  	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
>  		/* cannot handle READ_CAPACITY_16 */		\
>  	US_FLAG(INITIAL_READ10,	0x00100000)			\
> -		/* Initial READ(10) (and others) must be retried */
> +		/* Initial READ(10) (and others) must be retried */	\
> +	US_FLAG(WRITE_CACHE,	0x00200000)			\
> +		/* Write Cache status is not available */

The documentation for the new flag should be added in the same patch 
along with the flag itself.  There's no reason to have separate 
patches.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
