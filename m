From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
Date: Wed, 23 May 2012 16:29:19 +0800
Message-ID: <CAF1ivSZuedC-WH1cduhLFwHnCa9d7YVFnWw_7YZ8id9v50Af7g@mail.gmail.com>
References: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205221209530.2100-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54904 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab2EWI3U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2012 04:29:20 -0400
In-Reply-To: <Pine.LNX.4.44L0.1205221209530.2100-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, May 23, 2012 at 12:10 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> Hi,
>>
>> In August 2010, Jens and Alan discussed about "Runtime PM and the block
>> layer". http://marc.info/?t=128259108400001&r=1&w=2
>>
>> Here are the RFC v3 patches that try to implement the ideas discussed.
>> Welcome to give it a try.
>
> Have you checked to make sure these changes won't break the IDE driver?
> Maybe it will need to set the REQ_PM flag too.

Will check it.

Another thing need to check is if system suspend/resume works.

>
> Alan Stern
