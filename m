From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: eata irq abuse (was: Re: Linux 2.5.60)
Date: Wed, 12 Feb 2003 10:28:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4A6801.3050702@pobox.com>
References: <70652A801D9E0C469C28A0F8BCF49CF9012EBA15@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <70652A801D9E0C469C28A0F8BCF49CF9012EBA15@itmi1mx2.corp.emc.com>
List-Id: linux-scsi@vger.kernel.org
To: Ballabio_Dario@emc.com
Cc: manfred@colorfullife.com, warp@mercury.d2dc.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-eata@i-connect.net

Ballabio_Dario@emc.com wrote:
> Yes, you are correct. I used spin_unlock in order to release the local
> driver lock
> during the scsi_register call, but I forgot that I had the irq disabled as
> well.
> SO the correct fix is to use spin_unlock_irq/spin_lock_irq around the
> scsi_register call. Same fix applies to the u14-34f driver.


scsi_register may want to sleep, so that is not a fix at all...

