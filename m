From: yoma sophian <sophian.yoma@gmail.com>
Subject: question about passing physical address to lower level driver in scsi
Date: Sun, 30 Oct 2011 20:05:57 +0800
Message-ID: <CADUS3okkKEu_Re1FU_AvVk6agFwrmx0mwzbMSmso6pV8HFfWMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36560 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab1J3MF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Oct 2011 08:05:58 -0400
Received: by qyk27 with SMTP id 27so5640962qyk.19
        for <linux-scsi@vger.kernel.org>; Sun, 30 Oct 2011 05:05:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear all:
in scsi_init_sgtable, we create sgtable, sdb->table.sgl, and get the
page from blk_rq_map_sg.
But when the dma_address of sdb->table.sgl will be calclated out
before send the scsi command down to the lower level driver?

Thanks for your help in advance,
