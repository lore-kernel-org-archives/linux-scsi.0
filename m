From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V2 2/8] pm80xx: Corrected device state changes in I_T_Nexus_Reset.
Date: Mon, 17 Aug 2015 09:52:40 +0200
Message-ID: <CAMGffEndTUzwNPgaUqX+0weAirBbzq_tb9+VmFoWezHj+g_bJA@mail.gmail.com>
References: <1439285792-12030-1-git-send-email-Viswas.G@pmcs.com>
 <1439285792-12030-3-git-send-email-Viswas.G@pmcs.com> <CAMGffEmt82v3jw0mY8bg+ikmjCJYpROQ7KMPMtBOASMX2OePpA@mail.gmail.com>
 <DB8BCD22E410A84DA91083F3479A3DB3C6275C41@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:32800 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbbHQHxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2015 03:53:00 -0400
Received: by iods203 with SMTP id s203so142413479iod.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2015 00:52:59 -0700 (PDT)
In-Reply-To: <DB8BCD22E410A84DA91083F3479A3DB3C6275C41@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Hannes Reinecke <hare@suse.com>

On Fri, Aug 14, 2015 at 9:15 AM, Viswas G <Viswas.G@pmcs.com> wrote:
> On Thu, Aug 13, 2015 at 6:13 PM, Jinpu Wang <jinpu.wang@profitbricks.=
com> wrote:
>> Hi
>>
>> On Tue, Aug 11, 2015 at 11:36 AM,  <Viswas.G@pmcs.com> wrote:
>>> From: Viswas G <Viswas.G@pmcs.com>
>>>
>>> In Nexus reset the device state request are not needed.
>>>
>>> Changes from V1:
>>> Device state change request has been removed as the firmware
>>> will handle it during internal cleanup. Also updated the
>>> proper return value in case of failures.
>>
>> If above is true, should we remove the device state change command
>> support at all?
>>
>
> We can't remove the state change command as it is required for
> some task management command such as ABORT_TASK.
>

Ok, thanks

--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang@profitbricks.com
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
