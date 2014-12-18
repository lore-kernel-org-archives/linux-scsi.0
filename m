From: Charles Chiou <ch1102chiou@gmail.com>
Subject: Re: [PATCH 3/4 v3] scsi:stex.c Add reboot support
Date: Thu, 18 Dec 2014 11:41:30 +0800
Message-ID: <54924CEA.3060808@gmail.com>
References: <548FCD81.7030106@gmail.com> <20141217093027.GA13198@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141217093027.GA13198@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>, ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 12/17/2014 05:30 PM, Christoph Hellwig wrote:
> I'm not going to add a new reboot notifier for a driver.  If you can
> convince the driver model / PM people to pass this information to
> ->shutdown we can add support for this difference, but not in this way.
>
> Can you send me a series that just adds the hardware support for now, so
> we can dash this PM issue out separately?
>

Hi, we need to provide this information to our device.
We face the HW signal issue on various motherboards.
We experiment on many motherboards, and we observe that the restart 
signal is different on different motherboard. If device misses the 
signal, PCI loss or volume disappearance might happen.


To make power management easier, driver provide the shutdown or reboot 
information to the device.

Sorry, I'm not understand what is meaning of "series".
Could you specify what you what me to send you?
Thank you

BRS
Charles
