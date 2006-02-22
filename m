From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lsscsi-0.17 released
Date: Wed, 22 Feb 2006 11:27:16 -0500
Message-ID: <43FC90E4.10805@torque.net>
References: <43FBA4CD.6000505@torque.net> <m34q2r93q2.fsf@merlin.emma.line.org> <43FC7CCB.4090508@torque.net> <20060222160602.GB17473@merlin.emma.line.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:5792 "EHLO
	tomts43-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S1751352AbWBVQ2O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 11:28:14 -0500
In-Reply-To: <20060222160602.GB17473@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Matthias Andree wrote:
> On Wed, 22 Feb 2006, Douglas Gilbert wrote: 
>>Matthias Andree wrote:
>>>Does this work around new incompatibilities in the kernel
>>>or does this fix lsscsi bugs?
>>
>>The former. In lk 2.6.16-rc1 the
>>/sys/class/scsi_device/<hcil>/device/block symlink
>>changed to ".../block:sd<x>" breaking lsscsi 0.16 (and
>>earlier) and sg_map26 (in sg3_utils).
> 
> Heck, what was the reason for breaking userspace again?

Maybe the person responsible can answer. I'm only reacting
to a change that broke two of my utilities.

> Why would someone even consider using sysfs at all if it changes
> incompatibly?

Indeed.

Doug Gilbert
