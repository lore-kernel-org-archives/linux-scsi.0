From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 11:47:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015174708.GA15778@codepoet.org>
References: <200210142107.g9EL7IX04354@localhost.localdomain> <200210150019.53689.oliver@neukum.name> <20021015002252.GE1274@redhat.com> <200210150953.29905.oliver@neukum.name> <20021015143533.GA4288@redhat.com>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015143533.GA4288@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue Oct 15, 2002 at 10:35:33AM -0400, Doug Ledford wrote:
> Now, please, someone tell me why everyone is whining about user space 
> doing so little to accomplish what the much larger patch that was 
> posted does in kernel space?  My point is, and was, that since we need the 

Much larger patch?  If you look closely, that patch is actually
very small.  It simply moves the code already the proc/scsi/scsi
"scsi add-single-device" and "scsi remove-single-device" handlers
into standalone functions.  There is actually not so much as a
single line of new code...

> user space manager *anyway* to handle things the kernel will *never* 
> handle, there is no real reason to split up the code segments into a 
> kernel space portion and a user space portion.  In fact, it simply makes 
> things more complex because if something breaks and you have both a kernel 
> part and a user space part, you have to track down which one screwed the 
> pooch.  This way at least it's all in one spot.
> 
> Besides, I've not heard anyone address my concerns about what context the
> disc attach is done in with the kernel space patch.

I answered that last night.  It is called from within insmod
(i.e. not an interrupt handler or any such problematic case),

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
