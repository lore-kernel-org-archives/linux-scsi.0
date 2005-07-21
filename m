From: Lukasz Kosewski <lkosewsk@nit.ca>
Subject: Re: [PATCH 0/3] Add disk hotswap support to libata
Date: Thu, 21 Jul 2005 18:14:46 -0400
Message-ID: <42E01E56.4080301@nit.ca>
References: <42E01024.9030600@nit.ca> <42E01A68.6000002@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261900AbVGUWOs@vger.kernel.org>
In-Reply-To: <42E01A68.6000002@tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: jgarzik@pobox.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Michael Tokarev wrote:
> echo -n 1 > /sys/.../hostA/targetA:B:C/A:B:C:D/delete
> still works.  I think.
> And (again, I think) this same problem exists with 2.6.11 as well.
> At least, I wasn't able to remove-single-device even once (I discovered
> this mechanism only recently, haven't tried it with other kernels).

You're both correct and incorrect based on my testing; in 2.6.11.12, I 
have no problems.

However, in 2.6.13-rc1-mm1, you're right that echoing 1 into the delete 
node does remove the device.

It seems that there is some issue with the 'scsi_device_lookup' function 
then?

I'd have to debug further.

Luke Kosewski
Human Cannonball
Net Integration Technologies
