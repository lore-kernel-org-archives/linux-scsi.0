From: Willem Riede <wrlk@riede.org>
Subject: Re: buggy scsi_register behaviour in 2.5.51
Date: Tue, 17 Dec 2002 06:47:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021217114730.GE7990@linnie.riede.org>
References: <3DFE998E.1080103@interlog.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DFE998E.1080103@interlog.com>; from dgilbert@interlog.com on Mon, Dec 16, 2002 at 22:27:10 -0500
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

On 2002.12.16 22:27 Douglas Gilbert wrote:
> Willem,
> Can't fix all those problems but I did notice that
> idescsi_release() was missing a call to scsi_unregister().
> With this patch the ide-scsi entry remains dangling in
> sysfs (ide problem??) but the scsi host gets cleaned up
> after rmmod.
> 
> The attachment is against lk 2.5.52 . The ide-scsi
> driver in lk 2.5.52 needs cleaning up in several
> areas. If no-one else wants to attack it then I
> will.
> 
Thanks Doug.

I'll also see if I can find what the remaining problems are. I'd also be
prepared do do "cleaning up" of ide-scsi -- what in your opinion needs
taking care of?

Regards, Willem Riede.
