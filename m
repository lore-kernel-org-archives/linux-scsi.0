From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 17:45:56 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4165B914.7030507@pobox.com>
References: <4161A06D.8010601@rtr.ca> <4165B233.9080405@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S269646AbUJGVwt@vger.kernel.org>
In-Reply-To: <4165B233.9080405@rtr.ca>
To: Mark Lord <lsml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As another example, a piece of code that implements the HDIO_xxx ioctls 
in terms of a SCSI command can be quite generic, and separate from the 
libata driver API, while still in libata.

	Jeff
