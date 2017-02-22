From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: Manual driver binding and unbinding broken for SCSI
Date: Wed, 22 Feb 2017 18:21:42 +0800
Message-ID: <CACVXFVOzpiXF=0vi5-y4hB+XZK2asDYyeQj9k0btRguiJVKeOw@mail.gmail.com>
References: <20170218003015.GA19776@vader.DHCP.thefacebook.com>
 <1487378636.4351.45.camel@HansenPartnership.com> <20170220021958.GA26238@vader>
 <20170221171441.GA15875@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170221171441.GA15875@quack2.suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Omar Sandoval <osandov@osandov.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Dan Williams <dan.j.williams@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 22, 2017 at 1:14 AM, Jan Kara <jack@suse.cz> wrote:
> On Sun 19-02-17 18:19:58, Omar Sandoval wrote:
>> On Fri, Feb 17, 2017 at 04:43:56PM -0800, James Bottomley wrote:
>> > This seems to be related to a 0day test we got on the block tree,
>> > details here:
>> >
>> > http://marc.info/?t=148624068800001
>> >
>> > I root caused the above to something not being released when it should
>> > be, so it looks like you have the same problem.  It seems to be a
>> > recent commit in the block tree, so could you bisect it since you have
>> > a nice reproducer?
>>
>> These appear to actually be two separate issues.
>>
>> The unbind followed by bind crash only happens with scsi-mq. It reproes
>> since at least 4.0.
>>
>> The unbind followed by a new device coming up crash happens both with
>> and without scsi-mq. The earliest version I was able to check for that
>> was 4.6, which did reproduce.
>>
>> I'll see if I can get some more info on these two issues separately.
>
> Actually, the second issue is only a warning right? And if I understand the
> issue correctly, it should be fixed by either Dan's patches in linux-block
> or my patch 4 in the series which matches your test results. So that is
> dealt with. I have no idea about the first issue though.

Looks the 1st one is one old issue in blk-mq, and I have sent one patchset
to address it:

http://marc.info/?l=linux-kernel&m=148775847517071&w=2

Omar, feel free to give a test.

thanks,
Ming Lei
