From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH]
 fusion update to current APIs)
Date: Tue, 15 Jun 2004 11:07:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF10AA.3050509@pobox.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:40121 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265685AbUFOPHo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:07:44 -0400
In-Reply-To: <20040615074137.GA179379@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Douglas Gilbert <dougg@torque.net>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

Jeremy Higdon wrote:
> On Tue, Jun 15, 2004 at 04:47:11PM +1000, Douglas Gilbert wrote:
> 
>>So I guess this patch only applies to sg_header usage since the
>>users of sg_io_hdr (including SG_IO ioctl users) must explicitly
>>give the data direction.
> 
> 
> Correct.  Several apps declare a response length greater than the
> absolute minimum, not realizing that this confuses sg, causing
> direction to get set incorrectly, and requiring the host drivers
> to have their own tables.


We're still at "hacking the kernel to fix broken apps"  :(:(

	Jeff


