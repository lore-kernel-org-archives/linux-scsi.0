From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHv7 0/3][Resend] Display EVPD pages in sysfs
Date: Sun, 02 Mar 2014 09:53:53 +0100
Message-ID: <5312F1A1.4070605@acm.org>
References: <1392287281-75002-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.6]:37128 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaCBIx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Mar 2014 03:53:57 -0500
In-Reply-To: <1392287281-75002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 02/13/14 11:27, Hannes Reinecke wrote:
> After discussion with jejb I've dropped the EVPD parsing.
> So with this version we're just displaying the EVPD page
> 0x80 and 0x83 as hexdumps; no parsing is attempted.
> This drastically simplifies the patch, and we don't
> have to worry about any parsing errors in kernel space.
> Of course we'll need a parser in userspace, but that
> doesn't need to do any I/O. So it's still a very nice
> gain.

A general comment about this patch series: I think the cached copies of
these pages should be refreshed at least after an INQUIRY DATA HAS
CHANGED unit attention code has been received. Some SCSI target
implementations allow to change this data after a LUN has been created.

Bart.
