From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 07:28:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A4BED5DA-15E5-11D8-B482-0050E416C45B@ieee.org>
References: <9B540282-15E4-11D8-9DF1-0050E416C45B@ieee.org>
Mime-Version: 1.0 (Apple Message framework v552)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rly-ip03.mx.aol.com ([64.12.138.7]:40442 "EHLO
	rly-ip03.mx.aol.com") by vger.kernel.org with ESMTP id S264288AbTKMOcX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 09:32:23 -0500
In-Reply-To: <9B540282-15E4-11D8-9DF1-0050E416C45B@ieee.org>
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, mdharm-scsi@one-eyed-alien.net, p.lavarre@ieee.org

P.S.

Another thought: have we yet begun to experiment with disks that we can 
write protect?

I am, I have an Iomega Zip disk - all those have soft write-protect 
tabs inside.

For the sake of experimenting with other kinds of disks I'm thinking we 
could easily write a small patch to add a virtual write protect tab 
inside Linux to any usb-storage PDT x00 HDD/Flash.  I think the change 
is as small as catching mode sense headers to flip the Writable bit of 
the device-specific-parameter, and catching write ops to fail via SK 
ASC ASCQ = x 7 27 00 NotWritable.

Pat LaVarre

