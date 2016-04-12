From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 4/5] scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS
Date: Mon, 11 Apr 2016 19:43:26 -0700
Message-ID: <570C60CE.6000306@sandisk.com>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
 <1459806491-16428-5-git-send-email-mlin@kernel.org>
 <20160405145555.GE7822@mtj.duckdns.org>
 <CAF1ivSZSerbCO0MdELaTLbNUWMbeGBBv32-YO3sjHJZJYMQzrQ@mail.gmail.com>
 <yq1r3eb25jd.fsf@sermon.lab.mkp.net>
 <CAF1ivSYPbp_W68JS5CQwyLsTf1=oYa8yRZdbSAPp3LGrN5dq+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSYPbp_W68JS5CQwyLsTf1=oYa8yRZdbSAPp3LGrN5dq+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, sagi@grimberg.me
List-Id: linux-scsi@vger.kernel.org

On 04/11/16 15:04, Ming Lin wrote:
> On Mon, Apr 11, 2016 at 2:34 PM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>>>>>> "Ming" == Ming Lin <mlin@kernel.org> writes:
>>
>> Ming> Are we ready to merge it?
>>
>> We're still missing an ack from Sagi.
>
> Thought we already had a ack from Bart.
> OK, let's get one more from Sagi.

Hmm ... this patch doesn't touch any code for which Sagi is the 
maintainer so I think my ack for the ib_srp changes is sufficient.

Bart.
