From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH]
 fusion update to current APIs)
Date: Tue, 15 Jun 2004 18:10:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF73D7.3090501@pobox.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com> <20040615213458.GC182050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:56984 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265978AbUFOWNL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 18:13:11 -0400
In-Reply-To: <20040615213458.GC182050@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Douglas Gilbert <dougg@torque.net>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

Jeremy Higdon wrote:
> Okay.  How about this then.  At least it will fail in a noisy way,
> so that host adapter driver maintainers will not be pressured to "fix"
> their drivers (which is how the direction override code ended up in
> qlogic and mpt in the first place).

ok with me :)


