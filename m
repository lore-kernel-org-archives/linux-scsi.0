From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 17 Feb 2003 11:37:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217193737.GB1990@beaverton.ibm.com>
References: <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com> <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net> <20030203171726.GA1583@beaverton.ibm.com> <20030216131835.B23422@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030216131835.B23422@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> Any updates on this?  I saw some patches, but they don't seem to be in my
> tree (the usb tree, which is synced from Linus' tree).
> 
> People are starting to reports OOPSes to me because of this being
> missing....
> 
> Matt
> 

The scsi_set_device_offline interface is part of the last patch (scsi
error) I sent to linux-scsi. I updated my patch post some comments from
the list, but I am working on issue with the patch before I resend.

-andmike
--
Michael Anderson
andmike@us.ibm.com

