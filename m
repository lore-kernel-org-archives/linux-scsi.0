From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 17:40:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924174046.A20362@infradead.org>
References: <20030924144817.A16189@infradead.org> <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:34828 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261487AbTIXQkt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 12:40:49 -0400
Content-Disposition: inline
In-Reply-To: <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com>; from smhatre@cisco.com on Wed, Sep 24, 2003 at 09:50:02PM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>
Cc: 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Wed, Sep 24, 2003 at 09:50:02PM +0530, Sachin Mhatre (smhatre) wrote:
> indent -kr -i8 -ts8 -sob -l80 -ss -bs -psl <filename>.c
> However, this does not handle the log messages in double quotes. We will
> manually take care of such messages.

Please do.

> 2. The opening of files from kernel space is important for the iscsi
> probing mechanism.

It's not.  Opening files from kernelspaced is utter crap.  Creating
directories and special files from kernelspace is even worse.

> We read/write into the "/proc/scsi/scsi" file for
> configuration/deconfiguration of iSCSI devices.

I see.  And that's exactly wrong.  Take a look at the usb-storage or sbp2
drivers on how to handle it.

