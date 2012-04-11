From: adam radford <aradford@gmail.com>
Subject: Re: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Wed, 11 Apr 2012 13:57:21 -0700
Message-ID: <CAHtARFERLPA345Qsp=-_+5BGAdOrLaJ+HLGzqENBFNRXNJMDhg@mail.gmail.com>
References: <201203211716.45418.thomas@fjellstrom.ca>
	<CAHtARFGL0ibTZ=ADOL+x4akVvF-d1LjWoqW-WAv8_AeX+O3RdA@mail.gmail.com>
	<201203211752.05576.thomas@fjellstrom.ca>
	<201204111417.28893.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60615 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761200Ab2DKU5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Apr 2012 16:57:23 -0400
In-Reply-To: <201204111417.28893.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, Apr 11, 2012 at 1:17 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
>>
>> ADP_RESET_GEN2: HostDiag=a0
>>
>> followed by a bunch of:
>>
>> RESET_GEN2: retry=%x, hostdiag=a4
>>
>> Now I'm not sure the hostdiag should be different between the two. if this
>> aN identifier is similar to the aN identifiers in the MegaCli tool, then
>> it would mean its trying to reset a device that doesn't exist? I only have
>> a single M1015 card installed.

host diag register output a0 or a4 has absolutely nothing to do with
MegaCli -aN command line argument for specifying adapter number.

> I just got a second M1015 card in today and gave it a go. Similar issues,
> different log messages. (hand typed from picture taken of screens)
>
> Lots of:
>
> megasas: Waiting for 1 commands to complete

Can you try booting with kernel command line argument pcie_aspm=off

-Adam
