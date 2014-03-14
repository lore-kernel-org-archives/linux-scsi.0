From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Fri, 14 Mar 2014 13:11:10 -0700
Message-ID: <CAPcyv4iVMss=Vj8O9RR2GGCw-4uesw1MKj-qFuaXZqtTz1Cqdg@mail.gmail.com>
References: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
	<1394511589.2142.5.camel@dabdike.int.hansenpartnership.com>
	<CAPcyv4gJssEE7hADEDXmi4ao031uSVjMenKk9AFcbTukm1MKNg@mail.gmail.com>
	<1394515014.2142.11.camel@dabdike.int.hansenpartnership.com>
	<CAPcyv4gLEQ9-e2GJpfbQQ+DN+nsv-90oFwXxh-_K_hU0z4U5YQ@mail.gmail.com>
	<1394519379.2142.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:53253 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbaCNULL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2014 16:11:11 -0400
Received: by mail-ve0-f180.google.com with SMTP id jz11so3217911veb.39
        for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2014 13:11:10 -0700 (PDT)
In-Reply-To: <1394519379.2142.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>

On Mon, Mar 10, 2014 at 11:29 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>> > In the long game, though this whole debate is moot: setups with hard
>> > wired start times adhere to them regardless of what the system does, so
>> > they ignore start unit commands.  Systems without hard wired start times
>> > can usually be started at once, so us introducing a delay is unnecessary
>> > in either case.
>>
>> Ok, then I'll let the patch stand as is.
>
> Sounds good.
>
> James
>
>

Well, one more chirp about this.  If the user has disabled async
scanning by CONFIG_SCSI_SCAN_ASYNC=n or scsi_mod.scan != "async" then
resume should follow suit.  I'll include this in the next rev.
