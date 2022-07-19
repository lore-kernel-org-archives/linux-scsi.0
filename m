Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D97C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 22:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbiGSWKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238012AbiGSWKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 18:10:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ED6E0C
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 15:10:06 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JJf6lt009918;
        Tue, 19 Jul 2022 15:10:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=7WF74ICEuNW4biZDK44sl6oW9MFuYblnRVYWaCdWDm0=;
 b=Bs9xDf1nPf74941yzAQz2PwB9ui7oMIaX9kQyOFflJopViJLM3gwyi4MbC5y84ezIJ78
 HRFwtgo6LOuVLCG3zygfe1CF+6Ykis/jnxN6TFAXaHdZDsRqcSVJ+dAP339N+SeiMqJc
 W3/n0bhAuAElJvT1voKkP09fMwczcwkvFI62vSrGwB3DBzttcTkgFHsHkKMF6fNQgSxB
 eyfesGRXAndRbmqmgLNC4FPPZ0efGF2G5BphqdGAjGxZBSYMpyai0NgvLC+93hGIc/Al
 BYMIPlCasszfIA1AX5edPpP1aQZ0QqFsd1cuJKcSz+Dfowsepq8RxHZNFVY66ElM7zUD TA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hbvumvk04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 15:10:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jul
 2022 15:09:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 19 Jul 2022 15:09:59 -0700
Received: from mvluser05.qlc.com (unknown [10.112.10.135])
        by maili.marvell.com (Postfix) with ESMTP id A97CD3F7103;
        Tue, 19 Jul 2022 15:09:31 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by mvluser05.qlc.com (8.14.4/8.14.4/Submit) with ESMTP id 26JM9UU0030381;
        Tue, 19 Jul 2022 15:09:31 -0700
X-Authentication-Warning: mvluser05.qlc.com: aeasi owned process doing -bs
Date:   Tue, 19 Jul 2022 15:09:30 -0700
From:   Arun Easi <aeasi@marvell.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: Re: [EXT] Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
In-Reply-To: <20220719174056.56d39d87@gandalf.local.home>
Message-ID: <782837dd-5eb2-c7dd-7cc1-25ca97806830@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
 <20220715060227.23923-3-njavali@marvell.com>
 <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
 <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
 <20220718152243.21ad13e7@gandalf.local.home>
 <259d53a5-958e-6508-4e45-74dba2821242@marvell.com>
 <20220719174056.56d39d87@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="1879738122-475297684-1658268571=:3483"
X-Proofpoint-GUID: 7DbwB8FvoKEuvb2ShQyZSit4W67a0Szw
X-Proofpoint-ORIG-GUID: 7DbwB8FvoKEuvb2ShQyZSit4W67a0Szw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_08,2022-07-19_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--1879738122-475297684-1658268571=:3483
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT

On Tue, 19 Jul 2022, 2:40pm, Steven Rostedt wrote:

> On Tue, 19 Jul 2022 14:06:11 -0700
> Arun Easi <aeasi@marvell.com> wrote:
> 
> > It appears by calling the above two interfaces, I get a separate instance 
> > of "qla" only traces, but with only the "qla"-only instance being enabled, 
> > leaving the main (/sys/kernel/tracing/events/qla/enable) one disabled. No 
> > issues there, but when I enable both of them, I get garbage values on one.
> > 
> > /sys/kernel/tracing/instances/qla2xxx/trace:
> >              cat-56106   [012] ..... 2419873.470098: ql_dbg_log: qla2xxx [0000:05:00.0]-1054:14:  Entered (null).
> >              cat-56106   [012] ..... 2419873.470101: ql_dbg_log: qla2xxx [0000:05:00.0]-1000:14:  Entered ×+<96>²Ü<98>^H.
> >              cat-56106   [012] ..... 2419873.470102: ql_dbg_log: qla2xxx [0000:05:00.0]-1006:14:  Prepare to issue mbox cmd=0xde589000.
> > 
> > /sys/kernel/tracing/trace:
> >              cat-56106   [012] ..... 2419873.470097: ql_dbg_log: qla2xxx [0000:05:00.0]-1054:14:  Entered qla2x00_get_firmware_state.
> >              cat-56106   [012] ..... 2419873.470100: ql_dbg_log: qla2xxx [0000:05:00.0]-1000:14:  Entered qla2x00_mailbox_command.
> >              cat-56106   [012] ..... 2419873.470102: ql_dbg_log: qla2xxx [0000:05:00.0]-1006:14:  Prepare to issue mbox cmd=0x69.
> > 
> > It appears that only one should be enabled at a time. Per my read of 
> > Documentation/trace/ftrace.rst, the main directory and instances have 
> > separate trace buffers, so I am a bit confused with the above output.
> 
> That's because it uses va_list, and va_list can only be used once.

Ah, that makes sense.

> 
> I just added helpers for va_list use cases:
> 
>    https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_20220705224453.120955146-40goodmis.org_&d=DwIFaQ&c=nKjWec2b6R0mOyPaz7xtfQ&r=P-q_Qkt75qFy33SvdD2nAxAyN87eO1d-mFO-lqNOomw&m=cDBXba_lNDGk7c1Qm4elDe1Co-RV8zR-c1A9xV7vc4nMcQO7iRle72qNxljHsDNA&s=74PzgMj6nmfRCLXd3oMIqt-_DZbQeukUl0nK7MzfUjs&e= 
> 
> But it will likely suffer the same issue, but I can easily fix that with
> this on top:
> 
> Not even compiled tested:
> 
> -- Steve
> 
> diff --git a/include/trace/stages/stage6_event_callback.h b/include/trace/stages/stage6_event_callback.h
> index 0f51f6b3ab70..3c554a585320 100644
> --- a/include/trace/stages/stage6_event_callback.h
> +++ b/include/trace/stages/stage6_event_callback.h
> @@ -40,7 +40,12 @@
>  
>  #undef __assign_vstr
>  #define __assign_vstr(dst, fmt, va)					\
> -	vsnprintf(__get_str(dst), TRACE_EVENT_STR_MAX, fmt, *(va))
> +	do {								\
> +		va_list __cp_va;					\
> +		va_copy(__cp_va, *(va));				\
> +		vsnprintf(__get_str(dst), TRACE_EVENT_STR_MAX, fmt, __cp_va); \
> +		va_end(__cp_va);					\
> +	} while (0)
>  
>  #undef __bitmask
>  #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
> 

This will be nice.

Thanks for your help, Steve.

Regards,
-Arun
--1879738122-475297684-1658268571=:3483--
