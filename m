From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not recognized
Date: Mon, 28 May 2012 10:56:58 -0700
Message-ID: <CABE8wwsormFTiyE8Qepq_DBZ1rcA5P1+L9xLfgA7S8VY7_t0+Q@mail.gmail.com>
References: <Pine.LNX.4.44L0.1205251034190.1907-100000@iolanthe.rowland.org>
	<201205252127.21436.rjw@sisk.pl>
	<alpine.DEB.2.02.1205281835400.32511@debianer>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:24445 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751944Ab2E1R5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 May 2012 13:57:02 -0400
Received: by bkcjc3 with SMTP id jc3so2438781bkc.25
        for <linux-scsi@vger.kernel.org>; Mon, 28 May 2012 10:56:59 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.02.1205281835400.32511@debianer>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eldad Zack <eldadzack@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <jejbbe@hansenpartnership.com>, David Miller <davem@davemloft.net>, mroos@linux.ee, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Mon, May 28, 2012 at 9:46 AM, Eldad Zack <eldadzack@gmail.com> wrote=
:
>
> On Fri, 25 May 2012, Rafael J. Wysocki wrote:
>> On Friday, May 25, 2012, Alan Stern wrote:
>> > On Fri, 25 May 2012, James Bottomley wrote:
>> >
>> > Whether or not the boot kernel can have modular drivers isn't clea=
r to me;
>>
>> It can, but then the code in question is irrelevant and the resume h=
as to
>> be triggered in a different way. =A0For example, by writing to
>> /sys/power/resume from the initrd boot scripts.
>>
>> > I don't know when the check for a valid image in the swap area is =
carried
>> > out in relation to starting up the initramfs task.
>>
>> This particular one is carried out before the initrd is loaded.
>
> I just got hit by this one too, but on x86 qemu. There's no initrd, a=
nd all
> the modules are built in.
>
> With commit a7a20d103994fd760766e6c9d494daa569cbfe06 the kernel doesn=
't
> get to the point where it reads the partition table.
>
> If it's of any help, I can provide more details.

Yes, please send the qemu config details.

The proposed fix for 3.5 is here:
http://marc.info/?l=3Dlinux-scsi&m=3D133796775807498&w=3D2

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
