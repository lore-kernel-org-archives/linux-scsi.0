From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 3w-sas 0000:02:00.0: vpd r/w failed.
Date: Wed, 26 Jan 2011 14:45:23 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

Kernel 2.6.37, I have been running a 9750-24i4e for a while now, no 
problems, but I saw this today, what does it mean, what would cause it?

Would not using barriers cause this problem (e.g., nobarrier mount 
option?)

[475380.769837] 3w-sas 0000:02:00.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.

Justin.
