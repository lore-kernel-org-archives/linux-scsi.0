From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg
 list    with different entry count [map count=13] [unmap count=10]
Date: Tue, 26 May 2009 17:40:11 -0600
Message-ID: <4A1C7DDB.9010605@gmail.com>
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:34981 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbZEZXkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 19:40:15 -0400
In-Reply-To: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Torsten Kaiser wrote:
> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
> CONFIG_DMA_API_DEBUG=y
> Since then I get the following or similar errors on each boot:

Please retest with a newer -rc, this patch likely fixes it:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
