From: Oliver Neukum <oneukum@suse.com>
Subject: Re: JMS56x not working reliably with uas driver
Date: Tue, 27 Dec 2016 15:34:15 +0100
Message-ID: <1482849255.1731.1.camel@suse.com>
References: <Pine.LNX.4.44L0.1612221734120.15794-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932449AbcL0OlN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Dec 2016 09:41:13 -0500
In-Reply-To: <Pine.LNX.4.44L0.1612221734120.15794-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: George Cherian <gcherian@caviumnetworks.com>, hdegoede@redhat.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Thu, 2016-12-22 at 17:44 -0500, Alan Stern wrote:
> I don't see how this patch fixes anything.  Unless I'm mistaken, it
> just avoids the problem by preventing the system from issuing the
> command that provokes the error, rather than really fixing the
> underlying error.

Please clarify. If a reset leads to a disconnect, isn't that
exactly what we want?

	Regards
		Oliver

