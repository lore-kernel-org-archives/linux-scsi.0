From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi: killing requests for dead queue
Date: Fri, 4 Nov 2011 19:26:17 +0100
Message-ID: <CAO+b5-qR61O7cQCRgpPGYUB2rewHN2fN+CUvsXb8NC+-k2_C=w@mail.gmail.com>
References: <4eb3064c133909be1c@agluck-desktop.sc.intel.com>
	<201111041838.46062.bvanassche@acm.org>
	<987664A83D2D224EAE907B061CE93D5301FBD0FDFE@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42688 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab1KDS0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2011 14:26:18 -0400
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301FBD0FDFE@orsmsx505.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>

On Fri, Nov 4, 2011 at 7:07 PM, Luck, Tony <tony.luck@intel.com> wrote:
> > Commit 3308511 causes the SCSI queue cleanup code to be invoked
> > for every killed queue. Since the SCSI scanning code can create
> > and destroy SCSI queues repeatedly while probing LUNs, the
> > following message can be printed several times during boot:
> >
> > =A0 =A0scsi: killing requests for dead queue
>
> Does this message show up in some other situation (like when
> a device has failed?). Would you actually want to see these
> messages then? =A0If so, demoting them to debug sounds like
> the wrong thing to do.

I might be wrong but I doubt that anyone is interested in these
messages. It's not even mentioned in these messages which queue is
being cleaned up.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
