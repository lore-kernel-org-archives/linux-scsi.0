From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: TRIM / UNMAP read response
Date: Fri, 12 Aug 2011 10:55:29 -0400
Message-ID: <4E453EE1.4050705@interlog.com>
References: <4E452A6E.4040809@shiftmail.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50474 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1HLOzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 10:55:35 -0400
In-Reply-To: <4E452A6E.4040809@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: linux-ide@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11-08-12 09:28 AM, joystick wrote:
> Hi all IDE and SCSI ml's,
>
> is it guaranteed by the standards that reading from a device a region that has
> been TRIMmed (IDE) or UNMAPped (SCSI) will certainly return zeroes?

ATA:
In 'hdparm -I' you need to see this line:
    *  Deterministic read ZEROs after TRIM
[See the ATA IDENTIFY DEVICE command]

SCSI:
In the READ CAPACITY (16) response the LBPRZ needs to
be set to 1. Recently the same LBPRZ bit was added to
the Logical Block Provisioning VPD page (sbc3r27.pdf).

Doug Gilbert
