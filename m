From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
Date: Fri, 15 Aug 2014 12:34:22 -0600
Message-ID: <53EE52AE.4050006@kernel.dk>
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net> <53EE4FDE.2070904@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44041 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaHOSe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2014 14:34:26 -0400
Received: by mail-pa0-f50.google.com with SMTP id et14so3956759pad.9
        for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2014 11:34:26 -0700 (PDT)
In-Reply-To: <53EE4FDE.2070904@roeck-us.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Webb Scales <webbnh@hp.com>

On 2014-08-15 12:22, Guenter Roeck wrote:
> ping ... the problem fixed by this patch still affects the upstream kernel
> (v3.16-11383-gc9d2642) as well as -next (20140815).

James, could you upstream this one in time for -rc1?

-- 
Jens Axboe

