From: Matthew Schumacher <matt.s@aptalaska.net>
Subject: Re: new kernel = megaraid performance cut in half
Date: Tue, 14 May 2002 01:48:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CE0DD7B.9090201@aptalaska.net>
References: <E177YdO-0007VV-00@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Alan,

FYI,

[root@mail_test root]# uname -a
Linux mail_test 2.4.18-4smp #1 SMP Thu May 2 18:32:34 EDT 2002 i686 unknown
[root@mail_test root]# hdparm -t /dev/sda

/dev/sda:
  Timing buffered disk reads:  64 MB in  1.22 seconds = 52.46 MB/sec
[root@mail_test root]# hdparm -t /dev/sda

So the redhat 2.4.18 kernel reads disk almost 2.5 times better on my 
system.... sounds like something that would be handy in a stable kernel 
release.

Thanks for you help,

schu


Alan Cox wrote:
>>I am running exactly 1g of ram in the machine.  Is there a way to apply 
>>those patches manually or should I get the kernel-2.4.18-4.i686.rpm from 
>>here: http://rhn.redhat.com/errata/RHBA-2002-085.html.
> 
> 
> Your best bet is probably to grab the RH errata kernel. If you get the
> source rpm that also includes the patches for some controllers to do
> I/O from all of memory.
> 
> Hopefully that restores the speed



