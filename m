From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Thu, 30 Oct 2003 13:48:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031030134850.A9076@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org> <1067531731.4250.11.camel@pathost1.iomegacorp.com> <20031030091808.A6781@beaverton.ibm.com> <1067535485.6411.42.camel@pathost1.iomegacorp.com> <20031030100501.A7250@beaverton.ibm.com> <1067541899.1141.4.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:51633 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263009AbTJ3Vtl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 16:49:41 -0500
Content-Disposition: inline
In-Reply-To: <1067541899.1141.4.camel@ronald.kuetemeier.com>; from ronald@kuetemeier.com on Thu, Oct 30, 2003 at 12:25:00PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

On Thu, Oct 30, 2003 at 12:25:00PM -0700, Ronald Kuetemeier wrote:
> Sorry Patrick,
> didn't work.
> 
> Applied patch (compile ...)
> reboot no 3f
> mount camera.
> file: err-pat-scsi-1.patch_messages.txt
> Ronald

Ronald -

Does the camera work OK on 2.4?

Can you hack the base 2.6 so the len is 255, and configure or modify to
that it uses only page 3f so it closely matches what 2.4 sends, and see
what happens?

I don't think I screwed up the write check change, but that is possible.

-- Patrick Mansfield
