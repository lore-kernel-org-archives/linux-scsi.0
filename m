From: Luben Tuikov <tluben@rogers.com>
Subject: [RFC] device identification, VPD 0x83
Date: Thu, 08 May 2003 15:32:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBAB0D0.40807@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:22968
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S261968AbTEHTUF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2003 15:20:05 -0400
Received: from rogers.com ([24.102.172.157])
          by fep04-mail.bloor.is.net.cable.rogers.com
          (InterMail vM.5.01.05.12 201-253-122-126-112-20020820) with ESMTP
          id <20030508193232.XSMZ4342.fep04-mail.bloor.is.net.cable.rogers.com@rogers.com>
          for <linux-scsi@vger.kernel.org>; Thu, 8 May 2003 15:32:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

What is the alternative to providing a device identification
if the device doesn't provide one (assuming scanning from
userspace)?

My thoughts are that since device identification is
a property of the device, it should be provided by the
kernel if the device supports it (VPD 0x83 is mandatory).

The reason is security and configuration.

A LLDD can always filter or emulate it (depending on the
bus it's using, e.g. USB Storage) if the device itself
doesn't provide it.

Comments?

-- 
Luben


