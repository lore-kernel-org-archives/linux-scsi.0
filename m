From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: megaraid /proc under kernel 2.6.2
Date: Sun, 15 Feb 2004 20:56:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40302342.10806@pobox.com>
References: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:27795 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265290AbUBPB4c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2004 20:56:32 -0500
In-Reply-To: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
List-Id: linux-scsi@vger.kernel.org
To: Paul Wagland <paul@kungfoocoder.org>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

Paul Wagland wrote:
> Hi all,
> 
> I was playing around with forward porting the 2.10.1 megaraid driver to
> use the new megaraid layout as found in kernel 2.6.2. First I wanted to
> make sure that the default kernel worked as previously, and then to make
> sure that each of my layered patches kept the same behaviour.
> 
> However, the /proc/megaraid directory is no longer populated, and I am
> not quite sure why.


Maybe I can address the issue another way :)

We are moving away from procfs...  so may I suggest taking this 
opportunity to consider what procfs outputs, and a better way to provide 
that to userspace.  Perhaps this information is already duplicated in 
sysfs...

	Jeff



