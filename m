From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Thu, 25 Mar 2004 17:31:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40635DD9.8090809@pobox.com>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de> <20040325082949.GA3376@gondor.apana.org.au> <20040325220803.GZ16746@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:54478 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263682AbUCYWcJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2004 17:32:09 -0500
In-Reply-To: <20040325220803.GZ16746@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


Well IANAL, but it seems not so cut-n-dried, at least.

Firmware is a program that executes on another processor, so no linking 
is taking place at all.  It is analagous to shipping a binary-only 
program in your initrd, IMO.



