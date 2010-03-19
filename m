From: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: Intel SASMF8I
Date: Fri, 19 Mar 2010 18:46:49 -0400
Message-ID: <87d699441003191546v6c0f0b89t64ab93c4e3207f37@mail.gmail.com>
References: <4BA3FD3E.9070801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37478 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0CSWqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2010 18:46:51 -0400
In-Reply-To: <4BA3FD3E.9070801@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marco Schindler <marco.schindler@gmail.com>
Cc: Eric.Moore@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 6:39 PM, Marco Schindler
<marco.schindler@gmail.com> wrote:
> Hello,
> this card (using LSISAS1068(E)) is not recognized by FUSION_SAS, after
> patching the device code it appears to work nicely.
>

I was 99% of the way there to submit a similar patch (actually there's
a few more places where you want to add the new ID), but noticed a
previous discussion when a comparable patch was rejected. Turns out
there was a jumper on my motherboard (Supermicro X8DT3) which switches
between "raid" and "regular" mode (except they were called something
much fancier), and the regular mode switches the PCI ID to 0x58 which
in turn is recognized. [And the mptsas driver doesn't support the RAID
features anyways... there's a what appears to be proprietary driver
for that, megasr, which I did not need.]
