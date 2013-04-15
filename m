From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [SCSI] qla2xxx: Enhancements to support ISPFx00.
Date: Mon, 15 Apr 2013 20:40:15 +0000
Message-ID: <D63B9804CB63AD4FAAD966037695664651C633@avmb2.qlogic.org>
References: <20130415203451.GA30268@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:17067
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629Ab3DOUkW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Apr 2013 16:40:22 -0400
In-Reply-To: <20130415203451.GA30268@elgon.mountain>
Content-Language: en-US
Content-ID: <0A3D77EA41BB7E4B9B63A2E5C0EA7C2F@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Dan,

Thanks for bringing this to our attention. We will look into this and take
care of this. 

-- Giri

On 4/15/13 1:34 PM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

>Hello Giridhar Malavali,
>
>The patch 8ae6d9c7eb10: "[SCSI] qla2xxx: Enhancements to support
>ISPFx00." from Mar 28, 2013, leads to a bunch of Sparse endian warnings.
>
>See: http://lwn.net/Articles/205624/
>
>Most of them are just because the code hasn't been annotated but some
>look like real bugs like on line 3288.
>
>I've included the warnings below.
>
>regards,
>dan carpenter
>
><stdin>:1223:2: warning: #warning syscall finit_module not implemented
>[-Wcpp]
>drivers/scsi/qla2xxx/qla_mr.c:55:21: warning: restricted
>pci_channel_state_t degrades to integer
>drivers/scsi/qla2xxx/qla_mr.c:55:37: warning: restricted
>pci_channel_state_t degrades to integer
>drivers/scsi/qla2xxx/qla_mr.c:643:35: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:643:35:    expected unsigned short
>[unsigned] [usertype] request_q_outpointer
>drivers/scsi/qla2xxx/qla_mr.c:643:35:    got restricted __le16 [usertype]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:644:35: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:644:35:    expected unsigned short
>[unsigned] [usertype] response_q_inpointer
>drivers/scsi/qla2xxx/qla_mr.c:644:35:    got restricted __le16 [usertype]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:645:31: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:645:31:    expected unsigned short
>[unsigned] [usertype] request_q_length
>drivers/scsi/qla2xxx/qla_mr.c:645:31:    got restricted __le16 [usertype]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:646:32: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:646:32:    expected unsigned short
>[unsigned] [usertype] response_q_length
>drivers/scsi/qla2xxx/qla_mr.c:646:32:    got restricted __le16 [usertype]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:647:35: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:647:35:    expected unsigned int [unsigned]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:647:35:    got restricted __le32 [usertype]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:648:35: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:648:35:    expected unsigned int [unsigned]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:648:35:    got restricted __le32 [usertype]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:649:36: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:649:36:    expected unsigned int [unsigned]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:649:36:    got restricted __le32 [usertype]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:650:36: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:650:36:    expected unsigned int [unsigned]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:650:36:    got restricted __le32 [usertype]
><noident>
>drivers/scsi/qla2xxx/qla_mr.c:883:22: warning: cast removes address space
>of expression
>drivers/scsi/qla2xxx/qla_mr.c:898:22: warning: cast removes address space
>of expression
>drivers/scsi/qla2xxx/qla_mr.c:1424:17: warning: incorrect type in
>argument 2 (different address spaces)
>drivers/scsi/qla2xxx/qla_mr.c:1424:17:    expected void volatile
>[noderef] <asn:2>*addr
>drivers/scsi/qla2xxx/qla_mr.c:1424:17:    got unsigned int *<noident>
>drivers/scsi/qla2xxx/qla_mr.c:2200:34: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2222:49: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2223:47: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2224:45: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2227:29: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2298:23: warning: cast to restricted __le16
>drivers/scsi/qla2xxx/qla_mr.c:2299:23: warning: cast to restricted __le16
>drivers/scsi/qla2xxx/qla_mr.c:2353:29: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2355:29: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2357:32: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2652:26: warning: cast to restricted __le32
>drivers/scsi/qla2xxx/qla_mr.c:2720:16: warning: incorrect type in
>argument 1 (different address spaces)
>drivers/scsi/qla2xxx/qla_mr.c:2720:16:    expected void const volatile
>[noderef] <asn:2>*addr
>drivers/scsi/qla2xxx/qla_mr.c:2720:16:    got unsigned int *<noident>
>drivers/scsi/qla2xxx/qla_mr.c:2723:45: warning: incorrect type in
>argument 2 (different address spaces)
>drivers/scsi/qla2xxx/qla_mr.c:2723:45:    expected void const volatile
>[noderef] <asn:2>*src
>drivers/scsi/qla2xxx/qla_mr.c:2723:45:    got struct response_t
>[usertype] *[assigned] lptr
>drivers/scsi/qla2xxx/qla_mr.c:2774:17: warning: incorrect type in
>argument 2 (different address spaces)
>drivers/scsi/qla2xxx/qla_mr.c:2774:17:    expected void volatile
>[noderef] <asn:2>*addr
>drivers/scsi/qla2xxx/qla_mr.c:2774:17:    got unsigned int *<noident>
>drivers/scsi/qla2xxx/qla_mr.c:3152:29: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3152:29:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] dseg_count
>drivers/scsi/qla2xxx/qla_mr.c:3152:29:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3153:26: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3153:26:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] tgt_idx
>drivers/scsi/qla2xxx/qla_mr.c:3153:26:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_inline.h:90:26: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_inline.h:90:26:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_inline.h:90:26:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_inline.h:90:26: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_inline.h:90:26:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_inline.h:90:26:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3173:29: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3173:29:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] byte_count
>drivers/scsi/qla2xxx/qla_mr.c:3173:29:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:2995:48: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:2995:48:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:2995:48:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3000:38: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3000:38:    expected unsigned int
>[unsigned] [usertype] byte_count
>drivers/scsi/qla2xxx/qla_mr.c:3000:38:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3006:39: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3006:39:    expected unsigned char
>[unsigned] [usertype] cntrl_flags
>drivers/scsi/qla2xxx/qla_mr.c:3006:39:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3010:39: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3010:39:    expected unsigned char
>[unsigned] [usertype] cntrl_flags
>drivers/scsi/qla2xxx/qla_mr.c:3010:39:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:2967:49: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:2967:49:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:2967:49:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3038:28: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3038:28:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3038:28:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3039:28: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3039:28:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3039:28:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3040:28: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3040:28:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3040:28:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3230:24: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3230:24:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] handle
>drivers/scsi/qla2xxx/qla_mr.c:3230:24:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3232:25: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3232:25:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] timeout
>drivers/scsi/qla2xxx/qla_mr.c:3232:25:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3233:24: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3233:24:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] tgt_id
>drivers/scsi/qla2xxx/qla_mr.c:3233:24:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3234:31: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3234:31:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] control_flags
>drivers/scsi/qla2xxx/qla_mr.c:3234:31:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_inline.h:90:26: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_inline.h:90:26:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_inline.h:90:26:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3241:17: warning: incorrect type in
>argument 1 (different address spaces)
>drivers/scsi/qla2xxx/qla_mr.c:3241:17:    expected void *to
>drivers/scsi/qla2xxx/qla_mr.c:3241:17:    got void [noderef]
><asn:2>*<noident>
>drivers/scsi/qla2xxx/qla_mr.c:3257:25: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3257:25:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] handle
>drivers/scsi/qla2xxx/qla_mr.c:3257:25:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3258:31: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3258:31:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] abort_handle
>drivers/scsi/qla2xxx/qla_mr.c:3258:31:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3260:29: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3260:29:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] tgt_id_sts
>drivers/scsi/qla2xxx/qla_mr.c:3260:29:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3261:29: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3261:29:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] req_que_no
>drivers/scsi/qla2xxx/qla_mr.c:3261:29:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3263:17: warning: incorrect type in
>argument 1 (different address spaces)
>drivers/scsi/qla2xxx/qla_mr.c:3263:17:    expected void *to
>drivers/scsi/qla2xxx/qla_mr.c:3263:17:    got void [noderef]
><asn:2>*<noident>
>drivers/scsi/qla2xxx/qla_mr.c:3279:24: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3279:24:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] handle
>drivers/scsi/qla2xxx/qla_mr.c:3279:24:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3283:34: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3283:34:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] func_num
>drivers/scsi/qla2xxx/qla_mr.c:3283:34:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3285:32: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3285:32:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] adapid
>drivers/scsi/qla2xxx/qla_mr.c:3285:32:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3286:35: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3286:35:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] adapid_hi
>drivers/scsi/qla2xxx/qla_mr.c:3286:35:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3287:36: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3287:36:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] reserved_0
>drivers/scsi/qla2xxx/qla_mr.c:3287:36:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3288:36: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3288:36:    expected unsigned char
>[unsigned] [addressable] [assigned] [usertype] reserved_1
>drivers/scsi/qla2xxx/qla_mr.c:3288:36:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3289:40: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3289:40:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] dataword_extra
>drivers/scsi/qla2xxx/qla_mr.c:3289:40:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3293:44: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3293:44:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] req_dsdcnt
>drivers/scsi/qla2xxx/qla_mr.c:3293:44:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3294:44: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3294:44:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] req_xfrcnt
>drivers/scsi/qla2xxx/qla_mr.c:3294:44:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3296:52: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3296:52:    expected unsigned int
>[unsigned] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3296:52:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3298:52: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3298:52:    expected unsigned int
>[unsigned] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3298:52:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3300:45: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3300:45:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] dseg_rq_len
>drivers/scsi/qla2xxx/qla_mr.c:3300:45:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3305:44: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3305:44:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] rsp_dsdcnt
>drivers/scsi/qla2xxx/qla_mr.c:3305:44:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3306:44: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3306:44:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] rsp_xfrcnt
>drivers/scsi/qla2xxx/qla_mr.c:3306:44:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3308:53: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3308:53:    expected unsigned int
>[unsigned] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3308:53:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3310:53: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3310:53:    expected unsigned int
>[unsigned] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3310:53:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3312:46: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3312:46:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] dseg_rsp_len
>drivers/scsi/qla2xxx/qla_mr.c:3312:46:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3317:42: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3317:42:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] dataword
>drivers/scsi/qla2xxx/qla_mr.c:3317:42:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3334:36: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3334:36:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] req_xfrcnt
>drivers/scsi/qla2xxx/qla_mr.c:3334:36:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3335:36: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3335:36:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] rsp_xfrcnt
>drivers/scsi/qla2xxx/qla_mr.c:3335:36:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3344:44: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3344:44:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] req_dsdcnt
>drivers/scsi/qla2xxx/qla_mr.c:3344:44:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3346:34: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3346:34:    expected int [signed] tot_dsds
>drivers/scsi/qla2xxx/qla_mr.c:3346:34:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:2967:49: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:2967:49:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:2967:49:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3374:46: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3374:46:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3374:46:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3375:46: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3375:46:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3375:46:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3376:46: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3376:46:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3376:46:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3407:44: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3407:44:    expected unsigned short
>[unsigned] [addressable] [assigned] [usertype] rsp_dsdcnt
>drivers/scsi/qla2xxx/qla_mr.c:3407:44:    got restricted __le16
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3409:34: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3409:34:    expected int [signed] tot_dsds
>drivers/scsi/qla2xxx/qla_mr.c:3409:34:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:2967:49: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:2967:49:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:2967:49:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3437:46: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3437:46:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3437:46:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3438:46: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3438:46:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3438:46:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3439:46: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3439:46:    expected unsigned int
>[unsigned] [usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3439:46:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3464:42: warning: incorrect type in
>assignment (different base types)
>drivers/scsi/qla2xxx/qla_mr.c:3464:42:    expected unsigned int
>[unsigned] [addressable] [assigned] [usertype] dataword
>drivers/scsi/qla2xxx/qla_mr.c:3464:42:    got restricted __le32
>[usertype] <noident>
>drivers/scsi/qla2xxx/qla_mr.c:3473:17: warning: incorrect type in
>argument 1 (different address spaces)
>drivers/scsi/qla2xxx/qla_mr.c:3473:17:    expected void *to
>drivers/scsi/qla2xxx/qla_mr.c:3473:17:    got void [noderef]
><asn:2>*<noident>
>
>


