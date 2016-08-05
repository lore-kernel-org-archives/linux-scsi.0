From: Laurence Oberman <loberman@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Thu, 4 Aug 2016 21:07:28 -0400 (EDT)
Message-ID: <1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com>
References: <20160801175948.GA6685@redhat.com> <20160802174533.GA18714@redhat.com> <1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com> <20160803004013.GA19956@redhat.com> <eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com> <20160804161047.GC6989@redhat.com> <4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com> <20160804235850.GB13132@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:58179 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965472AbcHEBHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2016 21:07:31 -0400
In-Reply-To: <20160804235850.GB13132@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Mike Snitzer" <snitzer@redhat.com>
> To: "Bart Van Assche" <bart.vanassche@sandisk.com>
> Cc: dm-devel@redhat.com, "Laurence Oberman" <loberman@redhat.com>, linux-scsi@vger.kernel.org
> Sent: Thursday, August 4, 2016 7:58:50 PM
> Subject: Re: dm-mq and end_clone_request()
> 
> I've staged another fix, Laurence is seeing success with this added:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.8&id=d50a6450104c237db1dc75314d17b78c990a8c05
> 
> I'll be sending all the fixes I've queued to Linus tonight or early
> tomorrow (since I'll then be on vacation until Monday 8/15).
> 
Hello Bart,

I applied that patch to your kernel and while I still obviously see all the debug logging its no longer failing fio for me.
I ran 8 loops with 20 parallel fio runs. This was on a different server to the one I had been testing on.

However I am concerned about timing playing a part here here so let us know what you find.

Thanks
Laurence
