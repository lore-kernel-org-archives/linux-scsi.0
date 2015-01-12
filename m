From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 9/9] scsi_error: do not display kernel pointer in
 message logs
Date: Mon, 12 Jan 2015 08:12:26 -0500
Message-ID: <1421068346.3891.163.camel@localhost.localdomain>
References: <1420699430-9492-1-git-send-email-hare@suse.de>
	 <1420699430-9492-10-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbbALNMe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2015 08:12:34 -0500
In-Reply-To: <1420699430-9492-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, 2015-01-08 at 07:43 +0100, Hannes Reinecke wrote:
> It is not good practice to display the kernel pointer
> in any message logs, and it doesn't display any additional
> information. And as we know have block-layer assigned tags
> we can use them to differentiate the messages.
> So remove any pointer references from the displayed messages.
> 

I'd actually be sad to see this go -- I have found it useful
in the past when debugging crash dumps from customer sites
to be able to look in the kernel messages and see that a
particular scsi_cmnd had been aborted just before the crash
(and then later completed).

-Ewan


