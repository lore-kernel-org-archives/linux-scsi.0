From: Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: Reported regressions for 4.7 as of Sunday, 2016-06-19
Date: Tue, 5 Jul 2016 20:43:35 +0200
Message-ID: <e9e9933c-c1dd-2e77-fd85-c1c2ff0db885@leemhuis.info>
References: <7cc588b7-f1cf-62a8-e45b-ec7d863ba51e@leemhuis.info>
 <CA+5PVA63r9xLXtiiVMxKPdgZD5VZ_8io1f=9MH520LAFBbe9kg@mail.gmail.com>
 <CA+55aFyyKjupjdd4tC82VEnZwb3AyEGJBVCJzdyvfgeUFGVfLw@mail.gmail.com>
 <yq1wpli2ewx.fsf@sermon.lab.mkp.net>
 <20160622115131.4bh7sh6uhmmhw44v@c203.arch.suse.de>
 <A19CCC3E-1B00-45A5-BA4B-2E082E98AF87@qlogic.com>
 <CA+5PVA6NVTQUPZBCZ7J+NV-fEPkGKk2DDNQHn80sv71NNYOJnA@mail.gmail.com>
 <CA+55aFzwVT4spevcuC5Ncee974w2QyxwVJ7RS_2YCEikkqKdGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzwVT4spevcuC5Ncee974w2QyxwVJ7RS_2YCEikkqKdGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Josh Boyer <jwboyer@fedoraproject.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05.07.2016 19:32, Linus Torvalds wrote:
> On Tue, Jul 5, 2016 at 9:30 AM, Josh Boyer <jwboyer@fedoraproject.org=
> wrote:
>> On Wed, Jun 22, 2016 at 11:57 AM, Quinn Tran <quinn.tran@qlogic.com>=
 wrote:
>>>
>>> -       if (rsp->msix->cpuid !=3D smp_processor_id()) {
>>> +       if (rsp->msix && (rsp->msix->cpuid !=3D smp_processor_id())=
) {
>>
>> Did this wind up going into an official commit somewhere?
> It's not in my tree, at least.
> And I don't think I've seen a "yes, that fixes it".

Quinn Tran ACKed a nearly identical patch from Bruno Pr=C3=A9mont in a
different thread:
http://thread.gmane.org/gmane.linux.kernel/2257008/focus=3D2257139

=46rom what I can see in the initial mail in that thread it seems Bruno
successfully tested the patch he submitted. But I have no idea if the
patch is in someones queue to mainline right now. That's why I had it o=
n
my "if nothing happens soon, poke someone" list...

HTH, CU, Thorsten
