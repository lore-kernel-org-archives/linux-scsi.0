From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 14:41:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014204122.GB24904@codepoet.org>
References: <20021014054035.GA10686@codepoet.org> <20021014000602.F30278@one-eyed-alien.net> <20021014071252.GB13512@codepoet.org> <20021014154719.GE21010@nbkurt.casa-etp.nl> <20021014161922.GB2940@beaverton.ibm.com>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021014161922.GB2940@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Mon Oct 14, 2002 at 09:19:22AM -0700, Mike Anderson wrote:
> Kurt Garloff [garloff@suse.de] wrote:
> > There are some scary comments around the scsi add/remove-single-device
> > code which imply that this stuff only works by accident. 
> > I have used this functionality heavily for some time now and have never 
> > had a problem. Same for people I talked to.
> > But it would  probably make sense to review the code for possible
> > problems.
> > 
> > But I'm all for integrating your patch. It does not introduce new
> > problems. And if it exposes old ones, because the code is more
> > heavily used, this can only be good.
> 
> The comments may be pointing at the issues of the locking around the
> host_queue. Adds will probably be ok as we init the scsi_device before

It was my understanding that the comments (which were present
long before I changed anything) refer mainly to the fact that
hotswapping with a normal SCSI subsystem (without additional
electronic support for hotswapping) is electrically unsafe and is
likely to fry up your drives and your SCSI host controller.  For
people with hotswap safe hardware (or using ieee1394 or usb mass
storage devices), hotswapping is perfectly normal and safe, and
the scarry comments do not apply.

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
