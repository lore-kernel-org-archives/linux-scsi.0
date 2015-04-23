From: Ceriel Jacobs <linux-scsi@crashplan.pro>
Subject: Re: mvsas panics and dies when attached to a port extender on newer
 kernels
Date: Thu, 23 Apr 2015 13:10:06 +0200
Message-ID: <5538D30E.6090300@crashplan.pro>
References: <CAH_2GhdM7RgP0a2fYnY3yqb1T_LhGasmwBwsaF+yfCqRhXUikg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33665 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbbDWLKK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 07:10:10 -0400
In-Reply-To: <CAH_2GhdM7RgP0a2fYnY3yqb1T_LhGasmwBwsaF+yfCqRhXUikg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>, linux-scsi@vger.kernel.org

Your mvsas port expander bug might be related to bug# 81861

https://bugzilla.kernel.org/show_bug.cgi?id=81861

Adam Talbot schreef op 13-04-15 om 17:11:
> To make a very long debugging story short, I think there is an issues/bug
> with the mvsas driver. It works, with older kernels, and breaks on
> newer kernels.
>
> My Debian Jessie system was running great on a 3.18 kernel.  Changed
> cases to a newer supermicro case with a SAS expander backplane (SAS933EL).  That
> was the only hardware change.  Now, when ever I boot, the system kernel panics.
>
> 3.2.65-1+deb7u2 works
> 3.9.0 Gentoo CD works
> 3.16+ all fail
> Attached are 3 kernel panics on 3.16+ kernels.
>
> Motherboard is a Supermicro X8SIE, with a "Marvell Technology Group Ltd.
> 88SE6440 SAS/SATA PCIe controller"
>
> Is this a known bug?
>
> At this point I have two options:
> Stick with the old kernel (yuck)
> Buy a new card running a better supported chipset
>
> Any help would be greatly appreciated
> Thanks
> Adam
>
