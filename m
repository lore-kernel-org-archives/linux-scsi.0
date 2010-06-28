From: Subs <sar.subs@gmail.com>
Subject: Alternate ways to do Scatter-Gather from BOT Class driver
Date: Mon, 28 Jun 2010 21:59:07 +0530
Message-ID: <AANLkTiljLLGh8zbx1EY53-6LezDZ-utWW8FFbpFQwPIr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37691 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0F1Q3I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 12:29:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Hi All,

In my class driver I am receiving data transfer buffer as number of
Scatter-Gather lists from SCSI layer to perform data transfers.

Is there any alternate way to get the transfer buffer from SCSI other
than SG. I wanted to receive the complete data transfer buffer as a
single pointer.

-Subs
