From: Denny Page <denny@cococafe.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Wed, 25 Jan 2006 08:25:53 -0800
Message-ID: <43D7A691.1040606@cococafe.com>
References: <43D604AD.6050607@ilsb.tuwien.ac.at> <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain> <Pine.LNX.4.63.0601242251190.6350@kai.makisara.local> <43D69590.5050003@ilsb.tuwien.ac.at> <Pine.LNX.4.64.0601251107480.5181@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:59777 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S1750823AbWAYQ0A
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 11:26:00 -0500
In-Reply-To: <Pine.LNX.4.64.0601251107480.5181@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chip Coldwell <coldwell@redhat.com>
Cc: Gerhard Schneider <gs@ilsb.tuwien.ac.at>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

I agree.  In my case, the problem is also initial negation: 3 MB/s :-(.

Denny


Chip Coldwell wrote:
> I'm curious -- what was the impact on performance of disabling direct
> I/O in your case?
>
> I agree with Kai that the biggest performance hit is the 20 MB/s
> negotiated bus speed.
>
> Chip
>
