From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 4/4] scsi: cleanup usages of scsi_complete_async_scans
Date: Wed, 30 May 2012 14:49:13 -0700
Message-ID: <CABE8wwuNLEO+jmp_08VGHFbzD94y4ZhOfrFw207d=tLWi0UJ0Q@mail.gmail.com>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
	<20120530182145.23574.5156.stgit@dwillia2-linux.jf.intel.com>
	<201205302334.12247.rjw@sisk.pl>
	<201205302341.21821.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab2E3VtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2012 17:49:16 -0400
Received: by bkcjc3 with SMTP id jc3so252597bkc.25
        for <linux-scsi@vger.kernel.org>; Wed, 30 May 2012 14:49:13 -0700 (PDT)
In-Reply-To: <201205302341.21821.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Len Brown <len.brown@intel.com>, mroos@linux.ee, Arjan van de Ven <arjan@linux.intel.com>, James Bottomley <JBottomley@parallels.com>

On Wed, May 30, 2012 at 2:41 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > =A0 =A0 =A0 =A0 =A0 =A0 }
>> >
>> > - =A0 =A0 =A0 =A0 =A0 /*
>> > - =A0 =A0 =A0 =A0 =A0 =A0* We can't depend on SCSI devices being a=
vailable after loading
>> > - =A0 =A0 =A0 =A0 =A0 =A0* one of their modules until scsi_complet=
e_async_scans() is
>> > - =A0 =A0 =A0 =A0 =A0 =A0* called and the resume device usually is=
 a SCSI one.
>> > - =A0 =A0 =A0 =A0 =A0 =A0*/
>> > - =A0 =A0 =A0 =A0 =A0 scsi_complete_async_scans();
>> > -
>>
>> I believe this is wrong. =A0You're going to introduce a regression o=
n systems
>> using built-in hibernation and built-in SCSI stack.
>
> Ah, wait. =A0Do I understand correctly that wait_for_device_probe()
> is now going to do an equivalent of scsi_complete_async_scans()?
>
> If so, that should work, in which case please disregard my previous
> messages in this thread.

Yeah, no problem.  Patch 3 is what changed the assumptions in this rega=
rd.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
