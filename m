From: Tejun Heo <htejun@gmail.com>
Subject: Re: Kernel oops: 2.6.16-rc3-mm1 dvd mount
Date: Mon, 20 Feb 2006 23:21:37 +0900
Message-ID: <43F9D071.5000409@gmail.com>
References: <43F4A5FE.3080601@feise.com> <43F96743.9050103@gmail.com> <43F9CF85.1020500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.178]:13149 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964936AbWBTOVk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 09:21:40 -0500
Received: by pproxy.gmail.com with SMTP id s49so1115560pyc
        for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2006 06:21:39 -0800 (PST)
In-Reply-To: <43F9CF85.1020500@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jfeise@feise.com
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Tejun Heo wrote:
> Tejun Heo wrote:
> 
>> This oops happened because get_request() was invoked with NULL @q.  It 
>> seems like SCSI midlayer refcounting mixup.  I'll dig deeper and 
>> report again as soon as I can find something concrete.
> 
> 
> Hello, all & James.
> 
> I've bisected the patch series and the winner is #221 
> git-scsi-misc.patch which seems to contain eight commits. I think SCSI 
> people can hunt this down from now on. The bug happens whenever sr block 
> device is accessed - mount, cat, whatever, and now it seems like some 
> kind of data overrun.
> 

Oops, I snipped all important information. The original thread is

http://article.gmane.org/gmane.linux.kernel/379968

Sorry.

-- 
tejun
