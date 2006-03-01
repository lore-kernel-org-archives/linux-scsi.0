From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: sg regression in 2.6.16-rc5
Date: Wed, 1 Mar 2006 10:28:31 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net>
 <20060301083824.GA9871@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750767AbWCAS2r@vger.kernel.org>
In-Reply-To: <20060301083824.GA9871@merlin.emma.line.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Douglas Gilbert <dougg@torque.net>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Wed, 1 Mar 2006, Matthias Andree wrote:
>
> On Tue, 28 Feb 2006, Douglas Gilbert wrote:
> 
> > You can stop right there with the 1 MB reads. Welcome
> > to the new, blander sg driver which now shares many
> > size shortcomings with the block subsystem.
> 
> What is the reason to break user-space applications like this?

Did you read the whole thread? It was a low-level SCSI driver issue, where 
nothing broke user space, but the command was just fed to the drive 
differently, which then hit a limit in the driver.

		Linus
