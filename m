From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ATA Pass-Through support
Date: Wed, 01 Mar 2006 18:31:01 -0500
Message-ID: <44062EB5.7010901@torque.net>
References: <DF9C50EF9E8CDA45A06FE8735C68F85E568F0D@earthex2.power.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:6800 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1751939AbWCAXcM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 18:32:12 -0500
In-Reply-To: <DF9C50EF9E8CDA45A06FE8735C68F85E568F0D@earthex2.power.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quat Le <Quat.Le@dothill.com>
Cc: linux-scsi@vger.kernel.org

Quat Le wrote:
> Sorry if this is not the right place to ask this question.

This is the right place to ask.

> I wrote some application code to send ATA Pass-Through SCSI commands via
> SG_IO ioctl to SATA drives connected to a LSI Logic SAS HBA. What I got
> was ILLEGAL REQUEST (INVALID COMAND OPERATION CODE) for both SCSI
> OPCODE's A1H and 85H. I tried some other SCSI commands and saw that they
> were translated to ATA commands correctly. I am running Linux kernel
> 2.6.15 and am under the impression that it supports ATA Pass-Through.

I thought support for those two opcodes went into libata
for lk 2.6.15 as well but haven't written discrete code
to test it. Does the lsi SAS HBA use libata on its STP
(or direct connect) path? Eyeballing the libata code,
those opcodes are used internally. I know that
"smartctl -a -d ata /dev/sda" works when /dev/sda is a
SATA disk using libata on a regular SATA HBA. At present I
do not have any hardware nearby to test it. If you can direct
connect a SATA disk to a SATA controller on your motherboard
(i.e. bypassing the SAS HBA) does that make any difference?

Doug Gilbert
