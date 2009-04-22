From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Re: [PATCH v2] fix sign extension with 1.5TB usb-storage LBD=y
Date: Wed, 22 Apr 2009 05:09:21 -0600
Message-ID: <20090422110921.GE1926@parisc-linux.org>
References: <1240347174.10627.20.camel@nimitz> <20090421211858.GA1926@parisc-linux.org> <1240351210.10627.30.camel@nimitz> <49EEC82B.5040603@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <49EEC82B.5040603-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 22, 2009 at 10:32:59AM +0300, Boaz Harrosh wrote:
> These are actually aligned access it might be worth sacrificing a cast
> to be32/64 for sake of speed.

"for sake of speed"?  How often do you think we ask a device how large
it is?  How much overhead do you think is incurred by the unaligned code
if the data happens to be aligned?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
