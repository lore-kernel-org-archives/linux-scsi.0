From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: UASP updates (uasp.c)
Date: Tue, 4 Jan 2011 10:15:53 -0800 (PST)
Message-ID: <914550.72241.qm@web31813.mail.mud.yahoo.com>
Reply-To: ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Here are the updates you can find at https://github.com/ltuikov/linux-2.6:

commit 7b725e4ffa88490cb2bb042a703644f75bcd52b9
Author: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Date:   Mon Jan 3 16:26:23 2011 -0800

    [USB] UASP: Updates
    
    * Free the RESPONSE IU URB if unused, i.e. a
      status urb was never used due to the failing
      command.
    * Make some debug messages clearer.
    * REQ_HARDBARRIER no longer exists--update.
    * scsi_host::queuecommand changed prototype--update.
    
    Signed-off-by: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>

commit 58f76dfb08d155644ed639a319677c5dd9e11f16
Author: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Date:   Mon Jan 3 15:38:21 2011 -0800

    [USB] UASP: Remove conflict markers in Makefile
    
    Signed-off-by: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>

commit 1a15005eeb46c10067354b492ac73f09305c3e6b
Author: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Date:   Mon Jan 3 15:11:14 2011 -0800

    [USB] UASP: Remove confict markers in Kconfig
    
    Signed-off-by: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
