From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug 1.64 for lk2.5.47 mark II
Date: Mon, 18 Nov 2002 09:08:39 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD81367.8030206@torque.net>
References: <3DD7A1AA.6040009@torque.net> <20021117190238.GB3280@redhat.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

Doug Ledford wrote:
> On Mon, Nov 18, 2002 at 01:03:22AM +1100, Douglas Gilbert wrote:
> 
>>cleans up BIOS geometry code (parts copied from the aic7xxx
>>driver).
> 
> 
> 
> My opinion is that the aic7xxx bios geometry code is broken for really 
> large devices, so you might want to think about that ;-)

Doug,
I was looking for an example of calls to scsi_bios_ptable()
and scsi_partsize() in the (forlorn) hope that they would
cure the missing partitions problem. So the code got cleaned
up a bit in the process.

Hopefully no-one tries to get a 140 GB ram disk with
scsi_debug! In practice the largest allocation would be
4 GB (or the largest number vmalloc() can take) on i386.

Doug Gilbert


