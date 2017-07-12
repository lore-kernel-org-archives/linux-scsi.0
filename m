From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 01/15] qla2xxx: Combine Active command arrays.
Date: Tue, 11 Jul 2017 17:39:22 -0700
Message-ID: <1499819962.30046.8.camel@haakon3.daterainc.com>
References: <20170614034730.15428-1-himanshu.madhani@cavium.com>
         <20170614034730.15428-2-himanshu.madhani@cavium.com>
         <1499816619.2586.53.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499816619.2586.53.camel@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-07-11 at 23:43 +0000, Bart Van Assche wrote:
> On Tue, 2017-06-13 at 20:47 -0700, Himanshu Madhani wrote:
> >  typedef struct srb {
> > +	/*
> > +	 * Do not move cmd_type field, it needs to
> > +	 * line up with qla_tgt_cmd->cmd_type
> > +	 */
> > +	uint8_t cmd_type;
> > +	uint8_t pad[3];
> 
> Hello Himanshu,
> 
> Had I understood correctly that you had promised to rework the command
> array merging such that a union is used instead of requiring certain
> fields to be present at certain offsets (see also
> https://www.spinics.net/lists/target-devel/msg15591.html)?
> 

Yeah, as discussed previously it was not a blocker for merge.
