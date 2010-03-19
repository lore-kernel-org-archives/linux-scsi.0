From: Marco Schindler <marco.schindler@gmail.com>
Subject: Re: Intel SASMF8I
Date: Sat, 20 Mar 2010 00:04:16 +0100
Message-ID: <4BA402F0.1040501@gmail.com>
References: <4BA3FD3E.9070801@gmail.com> <87d699441003191546v6c0f0b89t64ab93c4e3207f37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51855 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0CSXEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2010 19:04:20 -0400
In-Reply-To: <87d699441003191546v6c0f0b89t64ab93c4e3207f37@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Eric.Moore@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 19.03.10 23:46, Ilia Mirkin wrote:
> On Fri, Mar 19, 2010 at 6:39 PM, Marco Schindler
> <marco.schindler@gmail.com>  wrote:
>> Hello,
>> this card (using LSISAS1068(E)) is not recognized by FUSION_SAS, after
>> patching the device code it appears to work nicely.
>>
>
> I was 99% of the way there to submit a similar patch (actually there's
> a few more places where you want to add the new ID), but noticed a
> previous discussion when a comparable patch was rejected. Turns out
> there was a jumper on my motherboard (Supermicro X8DT3) which switches
> between "raid" and "regular" mode (except they were called something
> much fancier), and the regular mode switches the PCI ID to 0x58 which
> in turn is recognized. [And the mptsas driver doesn't support the RAID
> features anyways... there's a what appears to be proprietary driver
> for that, megasr, which I did not need.]

SASMF8I doesn't seem to have any jumpers for "regular" mode and I don't 
want to use the sw raid of the chip. As far as I remember megasr didn't 
let me access drives directly. Is there no option then, except patching 
locally?
