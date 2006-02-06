From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
Date: Mon, 06 Feb 2006 11:33:56 +0900
Message-ID: <20060206113356T.fujita.tomonori@lab.ntt.co.jp>
References: <1138157885.11692.32.camel@max>
	<1139164228.3017.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:59264 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750891AbWBFCeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Feb 2006 21:34:11 -0500
In-Reply-To: <1139164228.3017.14.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
Date: Sun, 05 Feb 2006 12:30:28 -0600

> OK ... I think this looks good enough to fix up in tree.  I just have
> one minor quibble, so could you fix that and I'll put it in.
> 
> On Tue, 2006-01-24 at 20:58 -0600, Mike Christie wrote:
> > @@ -31,6 +32,7 @@ struct scsi_pointer {
> >  struct scsi_cmnd {
> >         int     sc_magic;
> >  
> > +       struct Scsi_Host *shost;
> >         struct scsi_device *device;
> 
> This is an unnecessary addition; you can get this from device->host.

Thanks a lot. I've just fixed this.

As Mike said, we replaced our mapping code with the standard helper
functions (such as bio_map_user) and some netlink code with the packet
socket interface. We've been preparing for the second submission. We
will do that in a couple of days.


> Do you have a pointer for the userspace side of this yet?

Yes, we have though it's really messy.

http://svn.berlios.de/svnroot/repos/stgt/branches/use-scsi-ml/usr

The current code doesn't catch up with the changes that I've
discribed. We'll update it until the seccond submission.
