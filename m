From: Zang Rui <zangrui@gmail.com>
Subject: Why is SCSI_SENSE_BUFFERSIZE defined to be 96 bytes?
Date: Wed, 3 Aug 2011 15:25:51 +0800
Message-ID: <CAD6oLZWfz4k-wyMFUyzKxv_n2Wtd9Wy5eGcRez8F06_nFCzeZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61465 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1HCHZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2011 03:25:53 -0400
Received: by wyg8 with SMTP id 8so337369wyg.19
        for <linux-scsi@vger.kernel.org>; Wed, 03 Aug 2011 00:25:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello there,

I was looking into scsi_cmnd.h

I found the following of scsi_cmnd structure:

105 #define SCSI_SENSE_BUFFERSIZE   96
106         unsigned char *sense_buffer;
107                                 /* obtained by REQUEST SENSE when
108                                  * CHECK CONDITION is received on original
109                                  * command (auto-sense) */


SPC defines the maximum length of sense data to be 252 bytes.
Why it is defined such in Linux?

Sorry if it is a frequently asked question.

Thanks,
Aaron
