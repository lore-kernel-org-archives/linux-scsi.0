From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: 2.6.6 Kernel + Adaptec aic7890/91 = Kernel panic
Date: Wed, 04 Aug 2004 17:41:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <411157F4.7070807@adaptec.com>
References: <40C30644.2020307@dasralph.de> <166998953.1086771720@stonetable> <40C76B6F.3010103@dasralph.de> <123170000.1086819395@aslan.scsiguy.com> <41113ECF.3050506@dasralph.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:27076 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267443AbUHDVlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 17:41:53 -0400
In-Reply-To: <41113ECF.3050506@dasralph.de>
List-Id: linux-scsi@vger.kernel.org
To: Ralph Bergmann <ralph@dasralph.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

Taken off linux-scsi.

Ralph Bergmann wrote:
> Justin T. Gibbs wrote:
> 
>  >>Justin T. Gibbs wrote:
>  >>
>  >>
>  >>>...  Can you provide the output of
>  >>>"lspci -vv -n" which will indicate the PCI ID information of your
>  >>>controller?
>  >>
>  >>
>  >>yes of course
>  >>
>  >>0000:02:01.0 Class 0100: 9005:0010
>  >>         Subsystem: 9005:a180
>  >
>  >
>  > Hmm.  Those IDs should be supported in the driver.  Can you add
>  > printk statements in aic7xxx_osm_pci.c just before each location
>  > where the driver returns "-ENODEV".  This should help narrow down
>  > why the driver is refusing to attach to the controller.  If I
>  > had to guess, I would say that pci_enable_device() is failing for
>  > some strange reason.
>  >
>  > --
>  > Justin
>  >
> 
> First of all I have to excuse, because you have to wait so long for my
> answer. But I've got good news: the problem is partially fixed. I put
> the scsi-adapter in another pci-slot (now a 32bit one in contradiction
> to the 64bit one I used before), and now it's working. But I've got some
> questions concerning this:
> 
> 1. should it have worked, no matter, which kind of pci-slot I use? When
> i used the 2.4 kernel, there were no error-messages, but when i switched
> to 2.6 kernel, I run into trouble as you know... So is it a
> kernel-problem or a hardware-thing?
> 
> 2. And if you want to have the specific output nevertheless,  I would
> prefer, that you send me the special adjusted file I have to use,
> because I have no idea about kernel-programming at all...
> 
> Ralph
> 

-- 
Luben


