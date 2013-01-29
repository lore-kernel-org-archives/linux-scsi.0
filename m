From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [scsi:for-next 23/27] drivers/scsi/fnic/fnic_scsi.c:183:35:
 sparse: invalid assignment: &=
Date: Tue, 29 Jan 2013 14:16:54 +1100
Message-ID: <1359429414.2408.22.camel@dabdike>
References: <50cf2343.OFwbZqu4+cv8MZmU%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41813 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab3A2DRB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2013 22:17:01 -0500
In-Reply-To: <50cf2343.OFwbZqu4+cv8MZmU%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Hiral Patel <hiralpat@cisco.com>, linux-scsi@vger.kernel.org, Narsimhulu Musini <nmusini@cisco.com>

On Mon, 2012-12-17 at 21:50 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
> commit: 188061001ac78b40780af042dd2156e2213e29ed [23/27] [SCSI] fnic:fixing issues in device and firmware reset code
> 
> 
> sparse warnings:
> 
> + drivers/scsi/fnic/fnic_scsi.c:183:35: sparse: invalid assignment: &=
> drivers/scsi/fnic/fnic_scsi.c:183:35:    left side has type restricted unsigned long long
> drivers/scsi/fnic/fnic_scsi.c:183:35:    right side has type unsigned long long
> drivers/scsi/fnic/fnic_scsi.c:185:35: sparse: invalid assignment: |=
> drivers/scsi/fnic/fnic_scsi.c:185:35:    left side has type restricted unsigned long long
> drivers/scsi/fnic/fnic_scsi.c:185:35:    right side has type unsigned long long

I still haven't seen fixes for these patches.  I've flushed the fnic
patches from the tree pending resolution.  That means the only remaining
fnic patches I have are

1/10 fnic: updated MAINTAINERS list
2/10 fnic: fix for trusted cos

Please fix this and the smatch issues and resubmit the other eight.

Thanks,

James


