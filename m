From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Wed, 26 Feb 2003 22:37:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030227063737.GB13803@beaverton.ibm.com>
References: <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com> <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net> <20030203171726.GA1583@beaverton.ibm.com> <20030216131835.B23422@one-eyed-alien.net> <20030217193737.GB1990@beaverton.ibm.com> <20030222234834.A32167@one-eyed-alien.net> <20030226233702.GC1376@beaverton.ibm.com> <20030226171043.F28571@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030226171043.F28571@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> Right... but I removed the release() function because that was marked (in
> the documentation) as only for the old-style drivers.  So I'll need to
> re-introduce it -- but it looks like all it has to do is free some memory.
> Does that sound about right?

Yes it was previously removed, but IIRC this is the direction
discussed on this thread. For a idle device the release functionality could
be done in the context of the scsi_remove_host call, but for a busy
device we need to have this call to clean up later.

-andmike
--
Michael Anderson
andmike@us.ibm.com

