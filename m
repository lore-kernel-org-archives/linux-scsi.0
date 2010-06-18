From: Jesse Barnes <jbarnes-Y1mF5jBUw70BENJcbMCuUQ@public.gmane.org>
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
Date: Fri, 18 Jun 2010 13:05:38 -0700
Message-ID: <20100618130538.0fc562ee@virtuousgeek.org>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	<1276666434-11227-5-git-send-email-justinmattock@gmail.com>
	<20100618102330.29eccb5b@virtuousgeek.org>
	<4C1BBF7D.8090904@kernel.org>
	<20100618124956.40c869a0@virtuousgeek.org>
	<4C1BD024.1030707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C1BD024.1030707-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 18 Jun 2010 12:59:32 -0700
"Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> just added this in(as a test), and the retval warning still shows up.
> with the last post I just added a printk was that legit, and if so what 
> else might be added to it to make it complete and proper?

What's the full warning?  Seems like printing the value should have
been enough to shut up gcc...

-- 
Jesse Barnes, Intel Open Source Technology Center
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
