From: "Lev A. Melnikovsky" <leva@hotmail.com>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Wed, 7 Jun 2006 02:57:05 +0400 (MSD)
Message-ID: <Pine.LNX.4.64.0606070253580.14004@nev.ubzr>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange> <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
 <Pine.LNX.4.60.0606060008330.22057@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.45.14.9] ([212.45.14.9]:45021 "EHLO ari.home")
	by vger.kernel.org with ESMTP id S1751293AbWFFW5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2006 18:57:00 -0400
In-Reply-To: <Pine.LNX.4.60.0606060008330.22057@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Dear Guennadi,

   On Tue, 6 Jun 2006 at 12:14am, Guennadi Liakhovetski wrote:

>>>> This scanner is the only device on the bus. My understanding is that 
>>>> I don't need to manually terminate anything, please correct me if I'm 
>>>> wrong.
>>> The bus has to be terminated on both ends. The HBA is, probably,
>>> terminating automatically, but the external end has to be terminated.
>>> Either with an external terminator or with a switch / jumper on your
>>> scanner.
>> OK, let's put it in the following way: I can find neither switches nor jumpers
>> in it.
> Do you have the manual for the scanner?
No, I don't. And I can't find it at HP's site.

> I don't know, maybe it has an automatic internal terminator. If not, you 
> need an external one. It has 2 SCSI connectors, right?
No. It has only one SCSI connector and this is why I assumed that I 
shouldn't care about terminators.

Thanks
-L.
