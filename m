From: Matthew Schumacher <matt.s@aptalaska.net>
Subject: Re: new kernel = megaraid performance cut in half
Date: Tue, 14 May 2002 01:05:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CE0D359.9070800@aptalaska.net>
References: <E177YUg-0007Tf-00@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Alan,

I am running exactly 1g of ram in the machine.  Is there a way to apply 
those patches manually or should I get the kernel-2.4.18-4.i686.rpm from 
here: http://rhn.redhat.com/errata/RHBA-2002-085.html.

Thanks for the quick response.

schu

Alan Cox wrote:
>>running redhat 7.2.  I was using the default kernel but I decided to 
>>upgrade to 2.4.18 to get the new VM code and for some quota fixes. 
>>Anyway, I compiled the kernel and the machine boots fine but my disk 
>>speed cut in half.
> 
> 
> Do you have large amounts of memory ? The Red Hat kernel includes patches
> that vastly up performance of DMA capable controllers when more than 1Gb
> of RAM is in use.
> 
> Alan



