From: Jan Bakuwel <jan.bakuwel@int.greenpeace.org>
Subject: Marvell SATA status
Date: Tue, 17 Jan 2006 22:55:45 +0100
Message-ID: <43CD67E1.7080703@int.gl3>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.greenpeace.org ([212.19.215.77]:64968 "EHLO
	fw.greenpeace.org") by vger.kernel.org with ESMTP id S932441AbWAQV5L
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 16:57:11 -0500
Received: (from root@localhost) by fw.greenpeace.org (8.9.3c/8.6.12) id WAA22843 for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 22:57:09 +0100 (CET)
Received: by fw.greenpeace.org (TUNIX/Firewall SMTP Server)
	for <linux-scsi@vger.kernel.org> id sma022011; Tue, 17 Jan 06 22:56:02 +0100
Received: from gpclust2.int.gl3 (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 25B7C10C004
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 22:56:01 +0100 (CET)
Received: from [192.168.206.251] (unknown [192.168.206.251])
	by mail.int.gl3 (Postfix) with ESMTP id 6C12F10C002
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 22:56:00 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I need to decide whether to add an additional 3ware SATA RAID adapter to
a server or to utilise the onboard Marvell SATA RAID adapter
(preferred). The Marvell driver (2.6.15.1) is "highly experimental" and
I see no traffic mentioning this driver since Sept last year... I was
wondering what the current status is. If it's still alive I'm obviously
offering to help debug it...

cheers,
Jan


