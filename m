From: Stefan Priebe <stefan@prie.be>
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old
 Opteron / Xeon servers
Date: Tue, 20 Mar 2007 11:33:11 +0100
Message-ID: <45FFB867.3060500@prie.be>
References: <45FDA626.9000404@prie.be> <20070319232732.854d7120.akpm@linux-foundation.org>
Reply-To: stefan@prie.be
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751380AbXCTKdf@vger.kernel.org>
In-Reply-To: <20070319232732.854d7120.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello!

Here are more informations... the problem seems to be a little bit more 
special.

1.) I've bootet these systems through NFS and would like to access 
/dev/sda or /dev/sdb then. For example via fdisk and this does not work.

2.) I've now tested the following kernels -
2.6.18.8 - works
2.6.19.7 - works
2.6.20 - does not work
2.6.21-rc4 - does not work

3.) The funny thing is, i can boot the whole system via 2.6.18.8 for 
example - fdisk the harddisk and format it + plus copying the whole 
image with a 2.6.20.3 kernel - and then the Server installied works 
perfectly i also can fdisk /dev/sdb or so. It only does not work if the 
system itself is bootet via NFS...

Stefan

Andrew Morton schrieb:
> On Sun, 18 Mar 2007 21:50:46 +0100 Stefan Priebe <stefan@prie.be> wrote:
> 
>> Hello!
>>
>> We've a very strange Problem with Kernel 2.6.20.x
>>
>> If i try to access a SCSI or SATA Disk (tested with Adaptec U320 
>> ASC-29320, ICP Vortex 9024, Promise TX300) the whole server hangs - no 
>> output - no error on the screen - but it hangs completely. But it does 
>> not happen on all our systems affected are only old 604pin xeons and 
>> socket 940 Opterons. Socket F Opteron or 771 Xeons does work fine.
>>
>> I've also testet apci=off pci=routeirq but both does not help. The 
>> systems work fine with 2.6.19.x and before.
> 
> Well that's a bit sad.
> 
> Could you please set up netconsole
> (Documentation/networking/netconsole.txt) and add initcall_debug to the
> kernel boot command line and then send us the full bootup logs?
> 
> (Even better: serial console with earlyprintk).
> 
> If that doesn't shed any light, we might have to ask you to perform a
> git-bisect search to find the buggy commit, I'm afraid.
