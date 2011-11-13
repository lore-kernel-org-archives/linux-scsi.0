From: adam radford <aradford@gmail.com>
Subject: Re: megaraid_sas: Memory corruption with STP commands
Date: Sun, 13 Nov 2011 11:18:55 -0800
Message-ID: <CAHtARFF60+4LqNoNeo62gvZYwmT_s1r-zBqizXS9d6QjAL2LUg@mail.gmail.com>
References: <alpine.LFD.2.02.1111132100070.6318@beren.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35281 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1KMTS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Nov 2011 14:18:56 -0500
Received: by wwe5 with SMTP id 5so3478115wwe.1
        for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2011 11:18:55 -0800 (PST)
In-Reply-To: <alpine.LFD.2.02.1111132100070.6318@beren.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chapman <mike@very.puzzling.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 13, 2011 at 2:03 AM, Michael Chapman <mike@very.puzzling.or=
g> wrote:

> + =A0 =A0 =A0 cmd->frame->hdr.flags &=3D ~(MFI_FRAME_SGL64 | MFI_FRAM=
E_SENSE64 |
> MFI_FRAME_IEEE);

Michael,

Thanks for your patch.

Some MegaRAID firmware runs in IEEE SGL mode.  We are going to verify
this patch works with older MegaCLI on a controller that supports IEEE
SGL and one that doesn't before we ack it.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
