From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Re: Re: about scsi_hostlist
Date: 18 Nov 2002 00:58:27 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037581107.5855.2.camel@irongate.swansea.linux.org.uk>
References: <200211172318.gAHNI699027197@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211172318.gAHNI699027197@leviathan.ele.uri.edu>
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Doug Ledford <dledford@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, 2002-11-17 at 23:16, Ming Zhang wrote:
> Yes, I want to hold a pointer to the device open and modify its refcount
> directly. Although this might be a little informal.
> Or do u have any suggestion to me for implement such a kernel module
> in a more formal way. thx.

Have a look at how scsi generic grabs the device on its open, I think
that is probably what you needed


