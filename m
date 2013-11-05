From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] libata: use sleep instead of standby command
Date: Tue, 05 Nov 2013 10:44:32 +0800
Message-ID: <52785B90.4050807@intel.com>
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com> <527856B6.8030901@intel.com> <52785A4E.7080006@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52785A4E.7080006@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>
List-Id: linux-scsi@vger.kernel.org

On 11/05/2013 10:39 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 11/04/2013 09:23 PM, Aaron Lu wrote:
>> I suppose this is mainly for runtime PM? Since for system 
>> suspend/hibernation, the disk and its controller will be powered
>> off anyway.
> 
> Yes, or the second patch also helps when one manually issues hdparm
> - -Y, which otherwise will cause the drive to be woken up to answer the
> CHECK POWER command, which udisks issues to decide if it should skip
> polling the SMART status of the drive.

OK, I see.
I wish udidks can do both of these(polling smart status and put the disk
into sleep mode), so that it knows when the disk is in sleep mode and it
will not send out the needless poll...

-Aaron
