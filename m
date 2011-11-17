From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: hv_storvsc driver
Date: Thu, 17 Nov 2011 18:27:00 +0100
Message-ID: <CAO+b5-pn1GswdXXB=EVThaoWaSW2EJmB=_GAE93Fa9+EeYxR1g@mail.gmail.com>
References: <1321549858-23822-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34634 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab1KQR1C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2011 12:27:02 -0500
Received: by wwe5 with SMTP id 5so3368230wwe.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2011 09:27:01 -0800 (PST)
In-Reply-To: <1321549858-23822-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: James.Bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>

On Thu, Nov 17, 2011 at 6:10 PM, K. Y. Srinivasan <kys@microsoft.com> wrote:
> Sometime back I had sent the scsi mailing list, the patch to move the
> Hyper-V storage driver out of staging. This patch addresses most of the
> review comments I have gotten to date from you and Christoph (I have not heard
> from anybody else in scsi mailing list). The patches addressing the review comments
> have already been sent to the staging tree. Let me know what I can do to expedite the
> move from the staging tree.

I've noticed that commit 46a971913611a23478283931460a95be962ce329
added an entry for the Hyper-V drivers directly under "Device
Drivers", that there exists an entry "Device Drivers/Virtio drivers",
that there exists an entry "Device Drivers/SCSI device support/SCSI
low-level drivers/VMware PVSCSI driver support" and also that there
exists an entry "Processor type and features/Paravirtualized guest
support/Xen guest support" . IMHO we should be able to come up with a
less confusing config menu structure for paravirtualized guest
support.

Bart.
