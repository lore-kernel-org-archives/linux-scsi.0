From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: DMA mapping on SCSI device?
Date: Wed, 30 Jan 2008 22:01:32 -0700
Message-ID: <20080131050132.GA3836@parisc-linux.org>
References: <479E6E8C.2090501@shaw.ca> <896139.88121.qm@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <896139.88121.qm@web31812.mail.mud.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 29, 2008 at 02:09:52PM -0800, Luben Tuikov wrote:
> > The ideal solution would be to do mapping against a
> > different struct 
> > device for each port, so that we could maintain the proper
> > DMA mask for 
> > each of them at all times. However I'm not sure if
> > that's possible. The 
> > thought of using the SCSI struct device for DMA mapping was
> > brought up 
> > at one point.. any thoughts on that?
> 
> The reason for this is that the object that a struct scsi_dev
> represents has nothing to do with HW DMA engines.

It really would work, once the few remaining architectures move away
from asserting that the 'struct device' passed in is a pci device.
It seems like the best way forward to me.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
