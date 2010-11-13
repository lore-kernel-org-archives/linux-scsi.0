From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Fri, 12 Nov 2010 21:09:17 -0500
Message-ID: <4CDDF34D.7080201@garzik.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <4CDDF1DB.1020707@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47592 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0KMCJW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2010 21:09:22 -0500
In-Reply-To: <4CDDF1DB.1020707@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 11/12/2010 09:03 PM, Jeff Garzik wrote:
> That [silent breakage issue] is precisely what I mentioned in the original patch:
> http://marc.info/?l=linux-ide&m=128891665713984&w=2
>
> And brought this up again when James merged my patch:
> http://marc.info/?l=linux-scsi&m=128943169802009&w=2

For the record, I prefer a rename to a prototype change.

	Jeff


