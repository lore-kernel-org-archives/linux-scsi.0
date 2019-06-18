From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Mon, 17 Jun 2019 20:28:01 -0700
Message-ID: <da579578-349e-1320-0867-14fde659733e@acm.org>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
 <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
 <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, Marc Gonzalez <marc.w.gonzalez@free.fr>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 6/17/19 5:35 PM, Douglas Gilbert wrote:
> For sg3_utils:
> 
> $ find . -name '*.c' -exec grep "/proc/scsi" {} \; -print
> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./src/sg_read.c
> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./src/sgp_dd.c
> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./src/sgm_dd.c
> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./src/sg_dd.c
>                  "'echo 1 > /proc/scsi/sg/allow_dio'\n", q_len, 
> dirio_count);
> ./testing/sg_tst_bidi.c
> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./examples/sgq_dd.c
>  
> That is 6 (not 38) by my count.

Hi Doug,

This is the command I ran:

$ git grep /proc/scsi | wc -l
38

I think your query excludes scripts/rescan-scsi-bus.sh.

Bart.
