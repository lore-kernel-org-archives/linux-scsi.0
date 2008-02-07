From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: no INQUIRY from userspace please
Date: Thu, 07 Feb 2008 18:13:43 +0100
Message-ID: <47AB3C47.6060805@s5r6.in-berlin.de>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>	 <1202151498.3096.84.camel@localhost.localdomain>	 <1202156151.13537.14.camel@linuxchandra>	 <1202156914.3096.112.camel@localhost.localdomain>	 <47A8C14A.3030207@cs.wisc.edu> <20080205215657.GA20963@linux.vnet.ibm.com>	 <47AAD898.30004@s5r6.in-berlin.de> <1202396490.3171.8.camel@localhost.localdomain> <47AB3A53.2030907@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <47AB3A53.2030907@s5r6.in-berlin.de>
Sender: linux-hotplug-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, sekharan@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> James Bottomley wrote:
>> It's all very well to say this, but I think if you look at what udev
>> does, you'll find that it uses scsi_id to send a VPD inquiry to the
>> device so it can populate /dev/disk/by-id, so the point is already
>> conceded

PS:  Alas we don't have a practicable way to know how many of the
  - doesn't work with Linux but works to some degree with Windows,
  - doesn't work with a 2.6 based Linux distro but did work with a
    2.4 based distro
kinds of devices are those with this INQUIRY bug or similar bugs.

While non-udev distros slowly went out of fashion on the desktop, there
was a certain frequency of reports of the latter kind of FireWire
devices, but this was before I became aware of that kind of firmware
bug, therefore I don't have any data whether it played a role for these
cases.
-- 
Stefan Richter
-=====-==--- --=- --===
http://arcgraph.de/sr/
