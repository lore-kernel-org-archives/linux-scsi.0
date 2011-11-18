From: KY Srinivasan <kys@microsoft.com>
Subject: RE: hv_storvsc driver
Date: Fri, 18 Nov 2011 00:43:17 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA6D173@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1321549858-23822-1-git-send-email-kys@microsoft.com>
 <CAO+b5-pn1GswdXXB=EVThaoWaSW2EJmB=_GAE93Fa9+EeYxR1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailc.microsoft.com ([131.107.115.214]:37552 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1KRAnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2011 19:43:18 -0500
In-Reply-To: <CAO+b5-pn1GswdXXB=EVThaoWaSW2EJmB=_GAE93Fa9+EeYxR1g@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>



> -----Original Message-----
> From: bart.vanassche@gmail.com [mailto:bart.vanassche@gmail.com] On Behalf
> Of Bart Van Assche
> Sent: Thursday, November 17, 2011 12:27 PM
> To: KY Srinivasan
> Cc: James.Bottomley@hansenpartnership.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; Greg Kroah-Hartman
> Subject: Re: hv_storvsc driver
> 
> On Thu, Nov 17, 2011 at 6:10 PM, K. Y. Srinivasan <kys@microsoft.com> wrote:
> > Sometime back I had sent the scsi mailing list, the patch to move the
> > Hyper-V storage driver out of staging. This patch addresses most of the
> > review comments I have gotten to date from you and Christoph (I have not
> heard
> > from anybody else in scsi mailing list). The patches addressing the review
> comments
> > have already been sent to the staging tree. Let me know what I can do to
> expedite the
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

Good point. Since this is not Hyper-V specific, we can address this issue as part
of a more broader cleanup.

Regards,

K. Y

