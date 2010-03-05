From: Asdo <asdo@shiftmail.org>
Subject: Re: LSI SAS changes SCSI address and by-path on hot-swap
Date: Sat, 06 Mar 2010 00:05:38 +0100
Message-ID: <4B918E42.6030009@shiftmail.org>
References: <4B8FE5F2.2040506@shiftmail.org>
 <1267770172.8894.24.camel@mulgrave.site>
 <627C309F4690914DAF54F22C0CD5F9001FCCFAD082@FRD01MAIL01.ads.invitrogen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:50223 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab0CEXGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 18:06:41 -0500
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-b2 #31825) id <01NKEQAQL000BFGHET@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Sat, 06 Mar 2010 00:05:36 +0100
In-reply-to: <627C309F4690914DAF54F22C0CD5F9001FCCFAD082@FRD01MAIL01.ads.invitrogen.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Michael" <Michael.Moore@lifetech.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Moore, Michael wrote:
> I did this with a LSI-1068E HBA and 2 x 4 drive hot swap SATA bays.  I was able to create udev rules to map the drive slots to consistent /dev entries.  However, the bigger problem I had was that if I had a drive inserted and mounted (say in slot A) and then I added or swapped another drive on the same port ( 4 SAS channels per port on the external HBAs) it would cause some sort of reset on the bus that would end up unmounting the drive    
> in slot A even though I never did anything to the drive in slot A.  Now, this was with SATA drives connected directly to the 1068 which should work, but since I needed this to work, I had to revert to the older setup that used Silicon Image 3124 eSATA cards.
>
> I can try to dig up the udev rules I used if this would be helpful.
>
> - Mike
>   

Michael, thanks for replying.
The problem you describe would really be a showstopper for us, so I'd 
really like to understand it well!...
I tried to reread your post multiple times but I don't fully understand, 
excuse my ignorance... this is because I am not really familiar with 
SAS/SCSI terms.

You have an LSI-1068E attached directly to hot swap SATA bays, you don't 
have expanders in the middle, right?
Then you swapped one of the 8 drives and another one got disconnected 
because of that?

This doesn't seem to happen on my setup. I have a mainboard-integrated 
LSI-1068E and kernel 2.6.24. I only have 4 drives connected and they all 
belong to "port-5:x" (x is different for each drive) I didn't try to 
swap all of them, but I definitely tried swapping one, and no other 
drive was disconnected because of this. The other drives were part of an 
md-raid, it would have been disastrous if it happened.
What kernel version do you have?

The following sentence is not clear to me:
"then I added or swapped another drive on the same port ( 4 SAS channels 
per port on the external HBAs)"
what is the "external HBAs"? Is that an expander?

Also... are you sure the problem was not maybe due to the udev rule? 
Sorry I don't know udev, I don't know if it even has the power to 
unmount a drive...

Thank you
A.

