From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 14:56:54 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0301241454370.715-100000@ida.rowland.org>
References: <3E318FA7.9050701@splentec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E318FA7.9050701@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Doug Ledford <dledford@redhat.com>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Are you aware that you are contradicting yourself?

On Fri, 24 Jan 2003, Luben Tuikov wrote:

> A LLDD should and must *not* call scsi_unregister_host().  This brakes
> all hierarchy.

On Fri, 24 Jan 2003, Luben Tuikov wrote:

> Oh, I forgot to mention in my previous by date letter:
> The entity which calls scsi_register_host() should by good design call
> scsi_unregister_host().

In usb-storage, it _is_ the LLDD that calls scsi_register_host().

Alan Stern

