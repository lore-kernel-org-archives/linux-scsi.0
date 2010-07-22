From: Danilo Godec <danilo.godec@agenda.si>
Subject: Re: RE pm8001 bug - pcieport error when loading 'pm8001' driver /
 no backplane drives seen
Date: Thu, 22 Jul 2010 17:33:30 +0200
Message-ID: <4C4864CA.8040508@agenda.si>
References: <4C483158.9060405@agenda.si> <F84ED190842B4649A809941E3F3F4BBA@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.agenda.si ([89.212.65.59]:50691 "EHLO zimbra.agenda.si"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756595Ab0GVPdd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2010 11:33:33 -0400
In-Reply-To: <F84ED190842B4649A809941E3F3F4BBA@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org

Thank you for a quick reply - but I'm not sure I understand correctly...

> [Jack]ATTO H608 use pm8001 SAS SPC chip as controller, but they don't
> use original PMC-Sierra's firmware AFAIK, the firmware we don't test well
> with our pm8001 driver.So I recommended you use HBA card made by USI.
> If you want to try pm8001 to drive your ATTO HBA, you'd better make sure
> remove ATTO's driver and reboot to load pm8001 fresh.
>   

The 'esas2hba' driver wasn't even installed - I downloaded and compiled
it later, after I couldn't get pm8001 to 'see' drives on the backplane.

If I use a MiniSAS to 4x SATA cable, the pm8001 driver works perfectly
with the ATTO - even with the 'pcieport' error. It's only when the
drives are in the enclosure / backplane. that the pm8001 driver doesn't
'see' them.

> [Jack] The errors means all SATA disks have affiliations with
> other devices, here I think it's esas2hba.
>
>
> [Jack]I believe the all 6 drives are SATA disks. They have affiliations
> with esas2hba.
>   

You are right - all of my drives are SATA, connected to a SAS backplane,
which is connected to the HBA via a SAS expander / midplane (at least as
far as I understand).

I don't quite understand what you mean by 'affiliations with esas2hba'
(especially since there was no 'esas2hba' driver in the beginning)?

I'm quite new to SAS and especially to 'expanders', so maybe I'm missing
something obvious...

Regards, Danilo

