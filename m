From: Dmitry Torokhov <dtor_core@ameritech.net>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently on 2.6.8.1
Date: Sun, 24 Oct 2004 12:22:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410241222.50426.dtor_core@ameritech.net>
References: <Pine.LNX.4.44.0409050434540.8779-100000@sasami.anime.net> <20041024150051.GA21922@suse.de> <1098631356.10824.33.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp812.mail.sc5.yahoo.com ([66.163.170.82]:27316 "HELO
	smtp812.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261543AbUJXRWz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 13:22:55 -0400
In-Reply-To: <1098631356.10824.33.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Olaf Hering <olh@suse.de>, Dan Hollis <goemon@anime.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bcollins@debian.org

On Sunday 24 October 2004 10:22 am, James Bottomley wrote:
> The trace doesn't show any error handler activity at all.  Are there no
> messages in the log about offlining the device?  If not, it sounds like
> there's a problem somewhere in the firewire system.
> 

The thing is that the hang is happening only with CD/DVD devices (sr_mod)
and not with hard drives (sd_mod) and as far as I can tell SBP2 does not
differentiate betweeh an HD and a CD so I think there is something going
on in sr_mod code.

-- 
Dmitry
