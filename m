From: Alex Krohn <alex@gossamer-threads.com>
Subject: Re: Address or Write Phase Parity Error Detected
Date: Fri, 10 Sep 2004 10:56:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040910105617.4F9E.ALEX@gossamer-threads.com>
References: <20040803085706.D2A9.ALEX@gossamer-threads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gossamer.nmsrv.com ([64.69.64.21]:33951 "EHLO
	gossamer-threads.com") by vger.kernel.org with ESMTP
	id S267681AbUIJRws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 13:52:48 -0400
In-Reply-To: <20040803085706.D2A9.ALEX@gossamer-threads.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

> I'm seeing the following errors intermitently:
> 
> scsi0: Host Status: Failed(0)
> DevQ(0:0:0): 0 waiting
> DevQ(0:2:0): 0 waiting
> scsi0: Address or Write Phase Parity Error Detected in DFF0.

Following up to my own post. This error turned out to be a problem with
amd760mpx chipset not being stable at 66mhz, even with no other pci
cards installed. 

The solution was to jumper the tyan s2469 boards pci bus back down to 33
mhz and we haven't seen the error since.

Cheers,

Alex
