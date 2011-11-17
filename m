From: Greg KH <gregkh@suse.de>
Subject: Re: hv_storvsc driver
Date: Thu, 17 Nov 2011 09:41:32 -0800
Message-ID: <20111117174132.GA13208@suse.de>
References: <1321549858-23822-1-git-send-email-kys@microsoft.com>
 <CAO+b5-pn1GswdXXB=EVThaoWaSW2EJmB=_GAE93Fa9+EeYxR1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1KQRtr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2011 12:49:47 -0500
Content-Disposition: inline
In-Reply-To: <CAO+b5-pn1GswdXXB=EVThaoWaSW2EJmB=_GAE93Fa9+EeYxR1g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, James.Bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Thu, Nov 17, 2011 at 06:27:00PM +0100, Bart Van Assche wrote:
> On Thu, Nov 17, 2011 at 6:10 PM, K. Y. Srinivasan <kys@microsoft.com> wrote:
> > Sometime back I had sent the scsi mailing list, the patch to move the
> > Hyper-V storage driver out of staging. This patch addresses most of the
> > review comments I have gotten to date from you and Christoph (I have not heard
> > from anybody else in scsi mailing list). The patches addressing the review comments
> > have already been sent to the staging tree. Let me know what I can do to expedite the
> > move from the staging tree.
> 
> I've noticed that commit 46a971913611a23478283931460a95be962ce329
> added an entry for the Hyper-V drivers directly under "Device
> Drivers", that there exists an entry "Device Drivers/Virtio drivers",
> that there exists an entry "Device Drivers/SCSI device support/SCSI
> low-level drivers/VMware PVSCSI driver support" and also that there
> exists an entry "Processor type and features/Paravirtualized guest
> support/Xen guest support" . IMHO we should be able to come up with a
> less confusing config menu structure for paravirtualized guest
> support.

Patches are always gladly welcomed.

thanks,

greg k-h
