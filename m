From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 09:19:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014161922.GB2940@beaverton.ibm.com>
References: <20021014054035.GA10686@codepoet.org> <20021014000602.F30278@one-eyed-alien.net> <20021014071252.GB13512@codepoet.org> <20021014154719.GE21010@nbkurt.casa-etp.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021014154719.GE21010@nbkurt.casa-etp.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Erik Andersen <andersen@codepoet.org>, USB Storage List <usb-storage@one-eyed-alien.net>

Kurt Garloff [garloff@suse.de] wrote:
> There are some scary comments around the scsi add/remove-single-device
> code which imply that this stuff only works by accident. 
> I have used this functionality heavily for some time now and have never 
> had a problem. Same for people I talked to.
> But it would  probably make sense to review the code for possible
> problems.
> 
> But I'm all for integrating your patch. It does not introduce new
> problems. And if it exposes old ones, because the code is more
> heavily used, this can only be good.

The comments may be pointing at the issues of the locking around the
host_queue. Adds will probably be ok as we init the scsi_device before
adding it to the list (so one would see a ready scsi_device or NULL
?maybe?). The remove could be an issue if something  happened to be
traversing the list at the same time. 


-andmike
--
Michael Anderson
andmike@us.ibm.com

