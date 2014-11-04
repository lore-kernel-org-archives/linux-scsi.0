From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Large disk drives
Date: Tue, 04 Nov 2014 08:52:42 +0100
Message-ID: <1415087562.2351.3.camel@jarvis.mobile.lan>
References: <201411032106.sA3L6MqU026397@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35096 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbaKDHwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:52:46 -0500
In-Reply-To: <201411032106.sA3L6MqU026397@hobgoblin.ariadne.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Mon, 2014-11-03 at 16:06 -0500, Dale R. Worley wrote:
> Was there any resolution as to how large disk drives would be handled
> if their interface did not support the "capacity" request that would
> tell how large they were?

Realistically no ... unless someone comes up with a reliable heuristic
to give us the size.

> Or as an alternative, is there any way to avoid buying USB-SCSI
> interfaces that do not support the large-capacity request?
> Unfortunately, such devices work OK with Windows (since Windows trusts
> what the partition table says), you can't just say to the salesperson
> "It has to work on drives over 3 TB."

This is a stopgap: your 3TB drive can be guessed as the 16 bit capacity
plus 2TB, but the same won't happen for a 5TB device.  Believing the
partition table gives us a chicken and egg problem because something
still has to get the partition table on to the device.

I don't think "don't buy something that doesn't work" is a hugely
unreasonable response to this.

James

> Dale
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


