From: Thomas Mueller <thomas@chaschperli.ch>
Subject: Re: mvsas: blocked task on writing to tape
Date: Fri, 20 Aug 2010 11:26:55 +0200
Message-ID: <4C6E4A5F.1010708@chaschperli.ch>
References: <i4jbu0$icb$2@dough.gmane.org>	<6B62480106F2B34D8404CF2FDAA4D9EF96D9C4CBFF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>	<4C6D6CB5.5030806@chaschperli.ch>	<AANLkTi=q0q0UOq8gw6O1Q7aoD-X0VKcOST1r0AsOUtt=@mail.gmail.com>	<4C6E132F.40207@chaschperli.ch> <AANLkTik2R0e__9W0bkvat0Ma95KgkUKBfe2cp=G-s=pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trillian.muellerit.ch ([83.169.22.129]:51236 "EHLO
	trillian.muellerit.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0HTJ1C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2010 05:27:02 -0400
In-Reply-To: <AANLkTik2R0e__9W0bkvat0Ma95KgkUKBfe2cp=G-s=pQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andy yan <andyysj@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 20.08.2010 08:54, andy yan wrote:
> There should be not wide port with your connections, it is strange wide
> port is configured.
> you can try attaching only one tage drive and cable, then check the log
> if wide port is build.

i'll check it , but i'm just next thursday on site.

at least the card (ARC-1300ix-16) supports "wide port":
http://www.areca.us/products/sasnoneraid.htm
