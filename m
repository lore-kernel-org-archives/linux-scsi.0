From: Sancho Dauskardt <sda-ls@bdit.de>
Subject: Re: usb-storage and Sony Handycam
Date: Mon, 10 Nov 2003 23:46:01 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <5.0.2.1.2.20031110233937.05634b10@pop.kundenserver.de>
References: <20031110095914.B22518@beaverton.ibm.com> <Pine.LNX.4.44L0.0311101335310.6288-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0311101335310.6288-100000@ida.rowland.org>
References: <20031110095914.B22518@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>, Patrick Mansfield <patmans@us.ibm.com>
Cc: Dmitri Katchalov <dmitrik@users.sourceforge.net>, Idan Sofer <idan@idanso.dyndns.org>, ronald@kuetemeier.com, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> > Has anyone looked at why the reset failed? I assume that would clear the
> > sense.
>
>How could anyone attempt to find out why the reset failed?

Just some ideas:
a) not supported - AFAIK many storage devices don't seem to support the 
bulk-reset, as the 'Other Popular OS' doesn't seem to issue them.
b) possibly VIA UHCI chipset which got killed by babble ?

- sda



-------------------------------------------------------
This SF.Net email sponsored by: ApacheCon 2003,
16-19 November in Las Vegas. Learn firsthand the latest
developments in Apache, PHP, Perl, XML, Java, MySQL,
WebDAV, and more! http://www.apachecon.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
