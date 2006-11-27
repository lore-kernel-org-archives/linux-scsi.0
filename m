From: Alexander Jolk <alexj@buf.com>
Subject: Re: SCSI tape (Re: scsi negotiation problem on aic79xx (39320A) in
 2.6.14)
Date: Mon, 27 Nov 2006 19:01:31 +0100
Message-ID: <456B27FB.1090707@buf.com>
References: <Impo.871wnune7w@hush.zonix.de>	<F7D518BF-C626-4964-B184-1AC4C6D2C3B2@cococafe.com>	<456B2052.1060300@buf.com> <Impo.87d578vkwp@hush.zonix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.buf.fr ([195.68.52.65]:31660 "EHLO mail.buf.fr")
	by vger.kernel.org with ESMTP id S1758417AbWK0SBf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 13:01:35 -0500
In-Reply-To: <Impo.87d578vkwp@hush.zonix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raymond Scholz <rscholz@zonix.de>
Cc: Denny Page <denny@cococafe.com>, linux-scsi@vger.kernel.org

Raymond Scholz wrote:
> My initial (private) mail didn't contain any specific hardware
> versions.  So if it helps to track down the reason for the negotiation
> problem, here they are:
> 
> LTO tape:
> 
> Host: scsi2 Channel: 00 Id: 06 Lun: 00
>   Vendor: CERTANCE Model: ULTRIUM 2        Rev: 1823
>   Type:   Sequential-Access                ANSI SCSI revision: 03
> 
> Controller:
> 
> Adaptec AIC79xx driver version: 1.3.11
> Adaptec AIC7902 Ultra320 SCSI adapter
> aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs

Here are mine:
Host: scsi1 Channel: 00 Id: 01 Lun: 00
   Vendor: HP       Model: Ultrium 3-SCSI   Rev: G25H
   Type:   Sequential-Access                ANSI SCSI revision: 03

Fusion MPT SPI Host driver 3.04.02
ioc1: 53C1030: Capabilities={Initiator,Target}
scsi1 : ioc1: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=19
scsi 1:0:1:0: Sequential-Access HP       Ultrium 3-SCSI   G25H PQ: 0 ANSI: 3
  target1:0:1: Beginning Domain Validation
  target1:0:1: Ending Domain Validation
  target1:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI PCOMP (6.25 ns, 
offset 64)

Alex


-- 
Alexander Jolk         /         BUF Compagnie
tel +33-1 42 68 18 28 /  fax +33-1 42 68 18 29
