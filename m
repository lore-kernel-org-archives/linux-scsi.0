From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 12:27:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F71C5F5.9060008@pobox.com>
References: <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:445 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261433AbTIXQ1r
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 12:27:47 -0400
In-Reply-To: <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: smhatre@cisco.com
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org

Sachin Mhatre (smhatre) wrote:
> 2. The opening of files from kernel space is important for the iscsi
> probing mechanism.

No, it's not.  This is the _reverse_ of what you should be doing.


> We read/write into the "/proc/scsi/scsi" file for
> configuration/deconfiguration of iSCSI devices.

This is wrong.

	Jeff




