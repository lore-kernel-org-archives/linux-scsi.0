From: Arne Jansen <lists@die-jansens.de>
Subject: Re: mpt2sas: bug in disk ordering?
Date: Fri, 13 May 2011 12:37:13 +0200
Message-ID: <4DCD09D9.4080702@die-jansens.de>
References: <BANLkTi=SsdjeHJOU_we+kZMgM0qm7eaVjg@mail.gmail.com> <BANLkTikmS3ytn2MNczbvRinvwk4M-ba90g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:26851 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1EMKhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 06:37:15 -0400
In-Reply-To: <BANLkTikmS3ytn2MNczbvRinvwk4M-ba90g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: linux-scsi@vger.kernel.org

On 13.05.2011 12:34, Caspar Smit wrote:
> I tried with Debian Squeeze with the latest backports kernel 2.6.38,
> which has mpt2sas version 07.100.00.00
> and now the disks are ordered this way:
> 
> /dev/sdb = slot 3
> /dev/sdc = slot 2
> /dev/sdd = slot 1
> /dev/sde = slot 0
> /dev/sdf = slot 7
> /dev/sdg = slot 6
> /dev/sdh = slot 5
> /dev/sdi = slot 4

I see something similar here, and, what's worse, the order may very from
boot to boot.

-Arne

