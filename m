From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 16:09:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E31AB91.9080400@splentec.com>
References: <Pine.LNX.4.44L0.0301241454370.715-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Doug Ledford <dledford@redhat.com>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> Are you aware that you are contradicting yourself?
> 
> On Fri, 24 Jan 2003, Luben Tuikov wrote:
> 
> 
>>A LLDD should and must *not* call scsi_unregister_host().  This brakes
>>all hierarchy.
> 

What I probably meant is the detect()/release() pair; release() itself
normally calls scsi_unregister(host); the point is that it got nudged
from ``above'', i.e. SCSI Core.

How can a LLDD be certain that it can safely call scsi_unregister_host()
whenever it wishes?  As Doug pointed out this leads to problems.

Furhtermore, are we talking about scsi_unregister_host() or
scsi_unregister(host)?  The former does drivers and the latter
does hosts.  This would mean that my original statement was
nevertheless correct, how can a LLDD decide to unload itself safely?

-- 
Luben



