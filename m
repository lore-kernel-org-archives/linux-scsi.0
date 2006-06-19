From: "Ilia Sotnikov" <hostcc@gmail.com>
Subject: Status of SAS ability to attach SATA devices
Date: Mon, 19 Jun 2006 20:47:07 +0300
Message-ID: <6ac07bf90606191047o131ec37eq6e1bcaf6205ea8ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.207]:12382 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S1751238AbWFSRrI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jun 2006 13:47:08 -0400
Received: by nz-out-0102.google.com with SMTP id s1so1156114nze
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jun 2006 10:47:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com, James.Bottomley@steeleye.com

Hardware: IBM 206m, AIC 9405 SAS/SATA controller, 2 SATA drives.

Having read several threads about SAS ability to attach SATA devices
(what's needed in my case), I found that this is work-in-progress.

Also during the investigation I've found that there are exist several
GIT trees with different SAS / AIC94xx versions: maintained by James
Bottomley, Jeff Garzik and Luben Tuikov.

I've tried all three of above mentioned versions - PHYs are discovered
correctly (as far as I can tell) but no disk devices are registered.
According to comments in sources that's predictable.

Questions are:
- what tree is recommended to work on;
- how could I help (if could) to improve the situation.

Thanks in advance,
-- 
 Ilia Sotnikov
