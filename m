From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Silencing 'killing requests for dead queue'
Date: Thu, 10 Nov 2011 12:57:37 +0100
Message-ID: <CAO+b5-pAuUixoNsckZheThHnh5H2LbYHh8D8Tm7PQfRxEMgRJw@mail.gmail.com>
References: <1320824364-8510-1-git-send-email-hare@suse.de>
	<20111110131029.be09b1080f3fe22d5fa86fe4@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36687 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab1KJL5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2011 06:57:38 -0500
Received: by wyh15 with SMTP id 15so2591431wyh.19
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2011 03:57:37 -0800 (PST)
In-Reply-To: <20111110131029.be09b1080f3fe22d5fa86fe4@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Thu, Nov 10, 2011 at 3:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> ipr_init is now down to 2543495 usecs (down from 494857993 usecs without
> this patch) and the machine boots as well as can be expected.

These timing differences are puzzling me. Have you been able to find
out what is causing them ? Are kernel messages on that system perhaps
sent to a serial console ?

Bart.
