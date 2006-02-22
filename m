From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lsscsi-0.17 released
Date: Wed, 22 Feb 2006 10:01:31 -0500
Message-ID: <43FC7CCB.4090508@torque.net>
References: <43FBA4CD.6000505@torque.net> <m34q2r93q2.fsf@merlin.emma.line.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:2717 "EHLO
	tomts20-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S1751313AbWBVPC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 10:02:29 -0500
In-Reply-To: <m34q2r93q2.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, taggart@debian.org

Matthias Andree wrote:
> Douglas Gilbert <dougg@torque.net> writes:
>>This version will be required for lsscsi to work properly
>>when lk 2.6.16 is released.
>>
>>ChangeLog:
>>Version 0.17 2006/2/6
>>  - fix disappearance of block device names in lk 2.6.16-rc1
> 
> Does this work around new incompatibilities in the kernel
> or does this fix lsscsi bugs?

The former. In lk 2.6.16-rc1 the
/sys/class/scsi_device/<hcil>/device/block symlink
changed to ".../block:sd<x>" breaking lsscsi 0.16 (and
earlier) and sg_map26 (in sg3_utils).

Doug Gilbert

