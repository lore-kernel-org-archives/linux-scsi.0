From: Eero Volotinen <eero.volotinen@iki.fi>
Subject: Re: mptsas and mptbase sas problems on fujitsu-siemens rx200-s3	rack
 server
Date: Fri, 22 Aug 2008 17:46:20 +0300
Message-ID: <48AED13C.7080106@iki.fi>
References: <48AE9DFB.7070502@iki.fi> <1219414589.3339.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pokat.org ([193.208.0.238]:39484 "EHLO pokat.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbYHVOrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 10:47:18 -0400
In-Reply-To: <1219414589.3339.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


> The first thing to note is that HBA based hardware RAID is not something
> anyone should enable blindly.  The fusion isn't even a dedicated RAID
> card, so its RAID engine is effectively jammed into left over firmware
> space because it was available (HP, for instance, required this
> capability to be removed on some of the HP OEM models).
> 
> Even for dedicated hardware RAID, the problem you have is that it
> effectively puts the onboard processor in the direct I/O path.  Since
> cards are (reasonably) cheap, these processors don't have the fastest
> busses or highest processing capabilities, and often top out at
> surprisingly low bandwidths, especially for compute intensive
> transactions like RAID-5/RAID-6.

Mainly this internal sas array (2*73GB 10k sas disks) is used for 
operating system only. Currently I am running it on raid1

After weekend I can try to run it without hardware acceleration,
it mainly makes installing operating system a bit harder.

So, this looks like that I need to buy working sas raid controller,
if I want to use hardware raid on this machine? Rest of data is on
fibrechannel san and it is working fine.

--
Eero
