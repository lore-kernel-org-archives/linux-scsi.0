From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 18 Jan 2017 18:35:29 +0300
Message-ID: <CANvN+emF5YUYEfW8fKZ2anDDm03gGM92QfotpXhLtntDApNR3A@mail.gmail.com>
References: <20170111134312.GH6286@linux-x5ow.site> <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk> <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me> <53a3fb6c-c75a-519a-f669-2bcab404e01d@grimberg.me>
 <20170117162752.GE6067@linux-x5ow.site> <6df6bf6a-7cd3-1700-2b0a-e140325ebf47@grimberg.me>
 <20170118135156.GG3514@linux-x5ow.site> <e3438024-e0f2-db96-5122-4508863be603@grimberg.me>
 <CANvN+emK-+HietjkUEuv9Ec=DYNN48jDQnpTiwm7UZMGz1hXig@mail.gmail.com> <a52f2192-81c8-24db-3657-98da3cc11ef7@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <a52f2192-81c8-24db-3657-98da3cc11ef7@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Linux-scsi@vger.kernel.org, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 18, 2017 at 5:40 PM, Sagi Grimberg <sagi@grimberg.me> wrote:
>
>> Your report provided this stats with one-completion dominance for the
>> single-threaded case. Does it also hold if you run multiple fio
>> threads per core?
>
>
> It's useless to run more threads on that core, it's already fully
> utilized. That single threads is already posting a fair amount of
> submissions, so I don't see how adding more fio jobs can help in any
> way.

With a single thread, your completion processing/submission is
completely serialized. From my experience, it takes fio couple of
microsec to process completion and submit next request, and that'
(much) larger than your interrupt processing time.

Regards,
Andrey
