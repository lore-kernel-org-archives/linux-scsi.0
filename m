From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: Still havind major MVSAS issues.
Date: Thu, 06 May 2010 08:44:10 +0200
Message-ID: <4BE2653A.6050607@powercraft.nl>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>       <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>       <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>       <CDBC7B5488B245E689B39330542DC434@usish.com.cn>       <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org>       <4BB50A92.3030205@gmx.net> <4BB53983.5050309@cisco.com>       <43193.87.210.74.220.1270217681.squirrel@ketsers.dhs.org> <1228.77.248.79.78.1270828327.squirrel@ketsers.dhs.org> <6B62480106F2B34D8404CF2FDAA4D9EF7F36EFEE0C@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:38456 "EHLO
	relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab0EFGoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 02:44:20 -0400
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF7F36EFEE0C@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: Caspar Smit <c.smit@truebit.nl>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Yugendranath R Singh - ERS, HCL Tech" <yugendranath.s@hcl.in>, "Geetha Gopalan, ERS-HCLTech" <geethagp@hcl.in>, "Mohan Kumar TG, ERS,HCLTech" <mohankumartg@hcl.in>

Dear Srinivas Naga Venkatastsa Pesagadugala,

Srinivas Naga Venkatasatya Pasagadugula, on 06-05-10 08:01:
> 1. Is this is the problem with only WD SATA drives? (I don't have
> WD SATA drives to reproduce this issue.) 2. Whether the problem is
> with direct attached SATA drives or drives connected in expanders
> also? 3. Could you please provide me the "dmesg" log or
> "/var/log/messages" log. 4. How much the capacity of SATA drives
> connected to controller? 5. Your HBA is having 6440 chipset?

I will check all points next weekend.

I tested it only with WD hard drives. I will attach some Samsung and
Segate drivers.

There where directly attached to the controller. There is are
backplanes in use, but they do not contain any expanders.

dmesg reports will be there this weekend.

All WD drivers where 1 TB, I will test some other drivers sizes this
weekend.

Thank you in advance,

WIth kind regards,

Jelle de Jong
