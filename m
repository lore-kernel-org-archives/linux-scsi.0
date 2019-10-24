Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A0BCA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 05:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CC0520679
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 05:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437613AbfJXFve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 01:51:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:37746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437590AbfJXFve (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 01:51:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6CCB0B1B1;
        Thu, 24 Oct 2019 05:51:31 +0000 (UTC)
Subject: Re: [PATCH v5 20/23] sg: introduce request state machine
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20191008075022.30055-1-dgilbert@interlog.com>
 <20191008075022.30055-21-dgilbert@interlog.com>
 <c222a727-eebb-ebc0-9df4-efa694c9989c@suse.de>
 <9360e6da-39da-15bb-d9e8-cf881b936e8d@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 mQINBE6KyREBEACwRN6XKClPtxPiABx5GW+Yr1snfhjzExxkTYaINHsWHlsLg13kiemsS6o7
 qrc+XP8FmhcnCOts9e2jxZxtmpB652lxRB9jZE40mcSLvYLM7S6aH0WXKn8bOqpqOGJiY2bc
 6qz6rJuqkOx3YNuUgiAxjuoYauEl8dg4bzex3KGkGRuxzRlC8APjHlwmsr+ETxOLBfUoRNuE
 b4nUtaseMPkNDwM4L9+n9cxpGbdwX0XwKFhlQMbG3rWA3YqQYWj1erKIPpgpfM64hwsdk9zZ
 QO1krgfULH4poPQFpl2+yVeEMXtsSou915jn/51rBelXeLq+cjuK5+B/JZUXPnNDoxOG3j3V
 VSZxkxLJ8RO1YamqZZbVP6jhDQ/bLcAI3EfjVbxhw9KWrh8MxTcmyJPn3QMMEp3wpVX9nSOQ
 tzG72Up/Py67VQe0x8fqmu7R4MmddSbyqgHrab/Nu+ak6g2RRn3QHXAQ7PQUq55BDtj85hd9
 W2iBiROhkZ/R+Q14cJkWhzaThN1sZ1zsfBNW0Im8OVn/J8bQUaS0a/NhpXJWv6J1ttkX3S0c
 QUratRfX4D1viAwNgoS0Joq7xIQD+CfJTax7pPn9rT////hSqJYUoMXkEz5IcO+hptCH1HF3
 qz77aA5njEBQrDRlslUBkCZ5P+QvZgJDy0C3xRGdg6ZVXEXJOQARAQABtCpIYW5uZXMgUmVp
 bmVja2UgKFN1U0UgTGFicykgPGhhcmVAc3VzZS5kZT6JAkEEEwECACsCGwMFCRLMAwAGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheABQJOisquAhkBAAoJEGz4yi9OyKjPOHoQAJLeLvr6JNHx
 GPcHXaJLHQiinz2QP0/wtsT8+hE26dLzxb7hgxLafj9XlAXOG3FhGd+ySlQ5wSbbjdxNjgsq
 FIjqQ88/Lk1NfnqG5aUTPmhEF+PzkPogEV7Pm5Q17ap22VK623MPaltEba+ly6/pGOODbKBH
 ak3gqa7Gro5YCQzNU0QVtMpWyeGF7xQK76DY/atvAtuVPBJHER+RPIF7iv5J3/GFIfdrM+wS
 BubFVDOibgM7UBnpa7aohZ9RgPkzJpzECsbmbttxYaiv8+EOwark4VjvOne8dRaj50qeyJH6
 HLpBXZDJH5ZcYJPMgunghSqghgfuUsd5fHmjFr3hDb5EoqAfgiRMSDom7wLZ9TGtT6viDldv
 hfWaIOD5UhpNYxfNgH6Y102gtMmN4o2P6g3UbZK1diH13s9DA5vI2mO2krGz2c5BOBmcctE5
 iS+JWiCizOqia5Op+B/tUNye/YIXSC4oMR++Fgt30OEafB8twxydMAE3HmY+foawCpGq06yM
 vAguLzvm7f6wAPesDAO9vxRNC5y7JeN4Kytl561ciTICmBR80Pdgs/Obj2DwM6dvHquQbQrU
 Op4XtD3eGUW4qgD99DrMXqCcSXX/uay9kOG+fQBfK39jkPKZEuEV2QdpE4Pry36SUGfohSNq
 xXW+bMc6P+irTT39VWFUJMcSuQINBE6KyREBEACvEJggkGC42huFAqJcOcLqnjK83t4TVwEn
 JRisbY/VdeZIHTGtcGLqsALDzk+bEAcZapguzfp7cySzvuR6Hyq7hKEjEHAZmI/3IDc9nbdh
 EgdCiFatah0XZ/p4vp7KAelYqbv8YF/ORLylAdLh9rzLR6yHFqVaR4WL4pl4kEWwFhNSHLxe
 55G56/dxBuoj4RrFoX3ynerXfbp4dH2KArPc0NfoamqebuGNfEQmDbtnCGE5zKcR0zvmXsRp
 qU7+caufueZyLwjTU+y5p34U4PlOO2Q7/bdaPEdXfpgvSpWk1o3H36LvkPV/PGGDCLzaNn04
 BdiiiPEHwoIjCXOAcR+4+eqM4TSwVpTn6SNgbHLjAhCwCDyggK+3qEGJph+WNtNU7uFfscSP
 k4jqlxc8P+hn9IqaMWaeX9nBEaiKffR7OKjMdtFFnBRSXiW/kOKuuRdeDjL5gWJjY+IpdafP
 KhjvUFtfSwGdrDUh3SvB5knSixE3qbxbhbNxmqDVzyzMwunFANujyyVizS31DnWC6tKzANkC
 k15CyeFC6sFFu+WpRxvC6fzQTLI5CRGAB6FAxz8Hu5rpNNZHsbYs9Vfr/BJuSUfRI/12eOCL
 IvxRPpmMOlcI4WDW3EDkzqNAXn5Onx/b0rFGFpM4GmSPriEJdBb4M4pSD6fN6Y/Jrng/Bdwk
 SQARAQABiQIlBBgBAgAPBQJOiskRAhsMBQkSzAMAAAoJEGz4yi9OyKjPgEwQAIP/gy/Xqc1q
 OpzfFScswk3CEoZWSqHxn/fZasa4IzkwhTUmukuIvRew+BzwvrTxhHcz9qQ8hX7iDPTZBcUt
 ovWPxz+3XfbGqE+q0JunlIsP4N+K/I10nyoGdoFpMFMfDnAiMUiUatHRf9Wsif/nT6oRiPNJ
 T0EbbeSyIYe+ZOMFfZBVGPqBCbe8YMI+JiZeez8L9JtegxQ6O3EMQ//1eoPJ5mv5lWXLFQfx
 f4rAcKseM8DE6xs1+1AIsSIG6H+EE3tVm+GdCkBaVAZo2VMVapx9k8RMSlW7vlGEQsHtI0FT
 c1XNOCGjaP4ITYUiOpfkh+N0nUZVRTxWnJqVPGZ2Nt7xCk7eoJWTSMWmodFlsKSgfblXVfdM
 9qoNScM3u0b9iYYuw/ijZ7VtYXFuQdh0XMM/V6zFrLnnhNmg0pnK6hO1LUgZlrxHwLZk5X8F
 uD/0MCbPmsYUMHPuJd5dSLUFTlejVXIbKTSAMd0tDSP5Ms8Ds84z5eHreiy1ijatqRFWFJRp
 ZtWlhGRERnDH17PUXDglsOA08HCls0PHx8itYsjYCAyETlxlLApXWdVl9YVwbQpQ+i693t/Y
 PGu8jotn0++P19d3JwXW8t6TVvBIQ1dRZHx1IxGLMn+CkDJMOmHAUMWTAXX2rf5tUjas8/v2
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <35ac1ffc-bab1-321e-cbab-7d7e9569f4a6@suse.de>
Date:   Thu, 24 Oct 2019 07:51:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9360e6da-39da-15bb-d9e8-cf881b936e8d@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/19 6:24 AM, Douglas Gilbert wrote:
> On 2019-10-18 6:25 a.m., Hannes Reinecke wrote:
>> On 10/8/19 9:50 AM, Douglas Gilbert wrote:
>>> The introduced request state machine is not wired in so that
>>> the size of one of the following patches is reduced. Bit
>>> operation defines for the request and file descriptor level
>>> are also introduced. Minor rework og sg_rd_append() function.
>>>
>>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>> ---
>>>   drivers/scsi/sg.c | 237 ++++++++++++++++++++++++++++++++++------------
>>>   1 file changed, 175 insertions(+), 62 deletions(-)
>>>
>>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>>> index 5b560f720993..4e6f6fb2a54e 100644
>>> --- a/drivers/scsi/sg.c
>>> +++ b/drivers/scsi/sg.c
>>> @@ -75,7 +75,43 @@ static char *sg_version_date = "20190606";
>>>   #define uptr64(val) ((void __user *)(uintptr_t)(val))
>>>   #define cuptr64(val) ((const void __user *)(uintptr_t)(val))
>>>   +/* Following enum contains the states of sg_request::rq_st */
>>> +enum sg_rq_state {
>>> +    SG_RS_INACTIVE = 0,    /* request not in use (e.g. on fl) */
>>> +    SG_RS_INFLIGHT,        /* active: cmd/req issued, no response
>>> yet */
>>> +    SG_RS_AWAIT_RD,        /* response received, awaiting read */
>>> +    SG_RS_DONE_RD,        /* read is ongoing or done */
>>> +    SG_RS_BUSY,        /* temporary state should rarely be seen */
>>> +};
>>> +
>>> +#define SG_TIME_UNIT_MS 0    /* milliseconds */
>>> +#define SG_DEF_TIME_UNIT SG_TIME_UNIT_MS
>>>   #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ,
>>> USER_HZ)
>>> +#define SG_FD_Q_AT_HEAD 0
>>> +#define SG_DEFAULT_Q_AT SG_FD_Q_AT_HEAD /* for backward
>>> compatibility */
>>> +#define SG_FL_MMAP_DIRECT (SG_FLAG_MMAP_IO | SG_FLAG_DIRECT_IO)
>>> +
>>> +/* Only take lower 4 bits of driver byte, all host byte and sense
>>> byte */
>>> +#define SG_ML_RESULT_MSK 0x0fff00ff    /* mid-level's 32 bit result
>>> value */
>>> +
>>> +#define SG_PACK_ID_WILDCARD (-1)
>>> +
>>> +#define SG_ADD_RQ_MAX_RETRIES 40    /* to stop infinite _trylock(s) */
>>> +
>>> +/* Bit positions (flags) for sg_request::frq_bm bitmask follow */
>>> +#define SG_FRQ_IS_ORPHAN    1    /* owner of request gone */
>>> +#define SG_FRQ_SYNC_INVOC    2    /* synchronous (blocking)
>>> invocation */
>>> +#define SG_FRQ_DIO_IN_USE    3    /* false->indirect_IO,mmap; 1->dio */
>>> +#define SG_FRQ_NO_US_XFER    4    /* no user space transfer of data */
>>> +#define SG_FRQ_DEACT_ORPHAN    7    /* not keeping orphan so
>>> de-activate */
>>> +#define SG_FRQ_BLK_PUT_REQ    9    /* set when blk_put_request()
>>> called */
>>> +
>>> +/* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
>>> +#define SG_FFD_FORCE_PACKID    0    /* receive only given
>>> pack_id/tag */
>>> +#define SG_FFD_CMD_Q        1    /* clear: only 1 active req per fd */
>>> +#define SG_FFD_KEEP_ORPHAN    2    /* policy for this fd */
>>> +#define SG_FFD_MMAP_CALLED    3    /* mmap(2) system call made on fd */
>>> +#define SG_FFD_Q_AT_TAIL    5    /* set: queue reqs at tail of blk q */
>>>     /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
>>>   #define SG_FDEV_EXCLUDE        0    /* have fd open with O_EXCL */
>>> @@ -83,12 +119,11 @@ static char *sg_version_date = "20190606";
>>>   #define SG_FDEV_LOG_SENSE    2    /* set by ioctl(SG_SET_DEBUG) */
>>>     int sg_big_buff = SG_DEF_RESERVED_SIZE;
>>> -/* N.B. This variable is readable and writeable via
>>> -   /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a
>>> buffer
>>> -   of this size (or less if there is not enough memory) will be
>>> reserved
>>> -   for use by this file descriptor. [Deprecated usage: this variable
>>> is also
>>> -   readable via /proc/sys/kernel/sg-big-buff if the sg driver is
>>> built into
>>> -   the kernel (i.e. it is not a module).] */
>>> +/*
>>> + * This variable is accessible via /proc/scsi/sg/def_reserved_size .
>>> Each
>>> + * time sg_open() is called a sg_request of this size (or less if
>>> there is
>>> + * not enough memory) will be reserved for use by this file descriptor.
>>> + */
>>>   static int def_reserved_size = -1;    /* picks up init parameter */
>>>   static int sg_allow_dio = SG_ALLOW_DIO_DEF;
>>>   @@ -132,6 +167,7 @@ struct sg_request {    /* SG_MAX_QUEUE requests
>>> outstanding per file */
>>>       char sg_io_owned;    /* 1 -> packet belongs to SG_IO */
>>>       /* done protected by rq_list_lock */
>>>       char done;        /* 0->before bh, 1->before read, 2->read */
>>> +    atomic_t rq_st;        /* request state, holds a enum
>>> sg_rq_state */
>>>       struct request *rq;    /* released in sg_rq_end_io(), bio kept */
>>>       struct bio *bio;    /* kept until this req -->SG_RS_INACTIVE */
>>>       struct execute_work ew_orph;    /* harvest orphan request */
>>> @@ -208,10 +244,15 @@ static void sg_unlink_reserve(struct sg_fd
>>> *sfp, struct sg_request *srp);
>>>   static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
>>>   static void sg_remove_sfp(struct kref *);
>>>   static struct sg_request *sg_add_request(struct sg_fd *sfp);
>>> -static int sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
>>> +static void sg_deact_request(struct sg_fd *sfp, struct sg_request
>>> *srp);
>>>   static struct sg_device *sg_get_dev(int dev);
>>>   static void sg_device_destroy(struct kref *kref);
>>>   static void sg_calc_sgat_param(struct sg_device *sdp);
>>> +static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
>>> +static void sg_rep_rq_state_fail(struct sg_fd *sfp,
>>> +                 enum sg_rq_state exp_old_st,
>>> +                 enum sg_rq_state want_st,
>>> +                 enum sg_rq_state act_old_st);
>>>     #define SZ_SG_HEADER ((int)sizeof(struct sg_header))    /* v1 and
>>> v2 header */
>>>   #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))    /* v3
>>> header */
>>> @@ -219,6 +260,8 @@ static void sg_calc_sgat_param(struct sg_device
>>> *sdp);
>>>     #define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING,
>>> (sdp)->fdev_bm)
>>>   #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
>>> +#define SG_RS_ACTIVE(srp) (atomic_read(&(srp)->rq_st) !=
>>> SG_RS_INACTIVE)
>>> +#define SG_RS_AWAIT_READ(srp) (atomic_read(&(srp)->rq_st) ==
>>> SG_RS_AWAIT_RD)
>>>     /*
>>>    * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log
>>> messages.
>>> @@ -382,15 +425,6 @@ sg_open(struct inode *inode, struct file *filp)
>>>       res = sg_allow_if_err_recovery(sdp, non_block);
>>>       if (res)
>>>           goto error_out;
>>> -    /* scsi_block_when_processing_errors() may block so bypass
>>> -     * check if O_NONBLOCK. Permits SCSI commands to be issued
>>> -     * during error recovery. Tread carefully. */
>>> -    if (!((op_flags & O_NONBLOCK) ||
>>> -          scsi_block_when_processing_errors(sdp->device))) {
>>> -        res = -ENXIO;
>>> -        /* we are in error recovery for this device */
>>> -        goto error_out;
>>> -    }
>>>         mutex_lock(&sdp->open_rel_lock);
>>>       if (op_flags & O_NONBLOCK) {
>>> @@ -494,12 +528,12 @@ sg_write(struct file *filp, const char __user
>>> *p, size_t count, loff_t *ppos)
>>>       struct sg_device *sdp;
>>>       struct sg_fd *sfp;
>>>       struct sg_request *srp;
>>> +    u8 cmnd[SG_MAX_CDB_SIZE];
>>>       struct sg_header ov2hdr;
>>>       struct sg_io_hdr v3hdr;
>>>       struct sg_header *ohp = &ov2hdr;
>>>       struct sg_io_hdr *h3p = &v3hdr;
>>>       struct sg_comm_wr_t cwr;
>>> -    u8 cmnd[SG_MAX_CDB_SIZE];
>>>         res = sg_check_file_access(filp, __func__);
>>>       if (res)
>>> @@ -748,11 +782,25 @@ sg_common_write(struct sg_fd *sfp, struct
>>> sg_comm_wr_t *cwrp)
>>>       return 0;
>>>   }
>>>   +static inline int
>>> +sg_rstate_chg(struct sg_request *srp, enum sg_rq_state old_st,
>>> +          enum sg_rq_state new_st)
>>> +{
>>> +    enum sg_rq_state act_old_st = (enum sg_rq_state)
>>> +                atomic_cmpxchg(&srp->rq_st, old_st, new_st);
>>> +
>>> +    if (act_old_st == old_st)
>>> +        return 0;       /* implies new_st --> srp->rq_st */
>>> +    else if (IS_ENABLED(CONFIG_SCSI_LOGGING))
>>> +        sg_rep_rq_state_fail(srp->parentfp, old_st, new_st,
>>> +                     act_old_st);
>>> +    return -EPROTOTYPE;
>>> +}
>>>   
>> -EPROTOTYPE?
>> Now there someone has read POSIX ... why not simply -EINVAL as one would
>> expect?
> 
> I expect EINVAL from very shallow errors, like sanity checks by
> ioctl(SG_IOSUBMIT) or write(2) before they issue a command/request to the
> lower levels.
> 
> This however is a lot more interesting. It is potentially two readers in
> a race, and if the race is close, the loser gets this error. Depending on
> the context, the user will either see this error, or EBUSY. There is an
> inherent race in the read/receive side of all AIO designs, as far as I
> can determine. Such a race is advised against in my documentation, but
> if a user, accidentally or otherwise, generates that race, then IMO
> the driver needs to handle it. By "handle it" I don't mean trying to help
> such users, I mean to protect the driver and the kernel behind it.
> 
> A later patch (46/62 currently) adds a 28 entry table of errno values
> with their meaning if returned by this driver:
> ....
>    EPROTOTYPE    atomic state change failed unexpectedly
> ....
> 
Ah, right. Fine.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
