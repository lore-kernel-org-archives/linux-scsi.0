From: Samuel Flory <sflory@rackable.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Fri, 20 Dec 2002 16:51:25 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3E03BB0D.5070605@rackable.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com> <176730000.1040430221@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, marcelo@conectiva.com.br
Cc: Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Justin T. Gibbs wrote:

>>I have an Adaptec AIC-7897 Ultra2 SCSI adapter on a system with 8G
>>of physical memory.  The adapter is using bounce buffers when DMA'ing
>>to memory >4G because of a bug in the aic7xxx driver. 
>>    
>>
>
>This has been fixed in both the aic7xxx and aic79xx drivers for some
>time.  The problem is that these later revisions have not been integrated
>into the mainline trees.
>
>  
>
  Marcelo, what is required get the aic79xx driver, and the aic7xxx 
updates into 2.4.21?  A number of linux distros are already using it. 
 It would really help people using board with the U320.  

    I've been using both drivers for some time with no issues.  Or maybe 
you'd prefer Alan put it in his tree 1st?

-- 
There is no such thing as obsolete hardware.
Merely hardware that other people don't want.
(The Second Rule of Hardware Acquisition)
Sam Flory  <sflory@rackable.com>
