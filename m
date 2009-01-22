From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Wed, 21 Jan 2009 16:26:03 -0800
Message-ID: <39FF78AD-75CB-4495-99C7-C4FAFB23999D@qlogic.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>    <E463DF2B2E584B4A82673F53D62C2EF45CEAB48E@cosmail01.lsi.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:12087 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZAVA0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2009 19:26:05 -0500
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45CEAB48E@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>


On Jan 21, 2009, at 4:00 PM, Moger, Babu wrote:

> Hi All,
> Have you guys seen this following error?
>
> Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: Firmware image  
> unavailable.
> Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: Firmware images  
> can be retrieved from: ftp://ftp.qlogic.com/outgoing/linux/firmware/.
>
> After this error, qlogic driver fails to detect the LUNs attached.
>
> I am running 2.6.29-rc2 kernel on x86_64 machine.
>
> I tried couple of things without any success. I downloaded all the  
> qlogic firmwares available and kept it in /lib/firmware. Tried  
> rebuilding the kernel. Did not help. Thanks in advance.
Could you double check that those firmware binaries under /lib/ 
firmware have correct naming convention as defined in qla_os.c:  
FW_FILE_ISP2XXX?

>
>
>
> Thanks
> Babu Moger
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

