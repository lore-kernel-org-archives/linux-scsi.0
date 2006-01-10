From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Error handling in LibATA
Date: Tue, 10 Jan 2006 23:15:16 +0000
Message-ID: <1136934917.26976.4.camel@localhost.localdomain>
References: <BAY101-F102837A76FADACF6F37DBBDF250@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [81.2.110.250] ([81.2.110.250]:53135 "EHLO lxorguk.ukuu.org.uk")
	by vger.kernel.org with ESMTP id S1030466AbWAJXMH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 18:12:07 -0500
In-Reply-To: <BAY101-F102837A76FADACF6F37DBBDF250@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Maw, 2006-01-10 at 16:30 -0600, John Treubig wrote:
> I've traced the errors down to the fact that the errors are caught in 
> libata-core.c (ata_qc_timeout).  I'd like to put a call in libata-core.c 


drivers/ide/* doesn't use libata. libata is used by the new PATA/SATA
drivers.

