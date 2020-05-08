Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0231EC38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 21:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F34218AC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 21:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgEHVZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 17:25:27 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:38713 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEHVZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 17:25:26 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MVdUQ-1jepSZ2p2i-00RXTE for <linux-scsi@vger.kernel.org>; Fri, 08 May
 2020 23:25:23 +0200
Received: by mail-lf1-f47.google.com with SMTP id b26so2555623lfa.5
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 14:25:23 -0700 (PDT)
X-Gm-Message-State: AOAM533JEE7B7LboDC3rDOlepVXUau9WCHhKpUMeJCnVjMXHDsdGtjmo
        P65FY4S7gyj/yXOamgJgATSZ0QzczbJmY+tQnaw=
X-Google-Smtp-Source: ABdhPJwSbUdjB9DO/G+19w5aRs7LQT+CAlyjKWm6agIZLUYuzztH5C96+Kzj7mrekg3JtrK5uDCrZTgLgP2bIRx7Hl8=
X-Received: by 2002:ac2:5df9:: with SMTP id z25mr3212534lfq.125.1588973123154;
 Fri, 08 May 2020 14:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200507042835.9135-3-bvanassche@acm.org> <202005080353.y49Uwj18%lkp@intel.com>
 <CAKwvOdnuXX2xpsz6fxV-qfvj1AqN3V7qyOwtwtCG4NWq+HzfAw@mail.gmail.com> <86bcf088-a35d-0a0f-0ba4-5883b1f2d6cb@acm.org>
In-Reply-To: <86bcf088-a35d-0a0f-0ba4-5883b1f2d6cb@acm.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 8 May 2020 23:25:06 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3PA25WUJp73Yea9xq_ca3uXA9Vz2U=UmHiDhg8FmGiNw@mail.gmail.com>
Message-ID: <CAK8P3a3PA25WUJp73Yea9xq_ca3uXA9Vz2U=UmHiDhg8FmGiNw@mail.gmail.com>
Subject: Re: [PATCH v5 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        kbuild test robot <lkp@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:rhqFf4z49bKgAv1XPzucT/jg7B5rmMAAt/jOUw4XucpjnLvYIVM
 vO9lchKr+w4WpQMaH2ZFcsY9Ns4UGYT2evWZVC95kmSpmwpI26lH4eFzAUTGEGo9WLL1fhy
 RtGIrdeU9XnRn6hXvqaSmPsY5AnxvVsJuLZqZ9ronnCgZcycqA/o0J0ATW+Ebux5VVmSZgE
 a4rQEKcwbBqh2vEcYs/Eg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/xUQQhvPPwM=:uldB+1mctnl3o+47HyY5K+
 PtI9fEZHBUPj4e9gABItt2f7zmmJcM8x8UW7FpAE4cSiouRM97iWAWnO16HXSy4aKop63Mcv9
 nsSzvGghEs/i+mKpY71UUzQQYncPuDdB1PQ6pYhenYlpacDyLr2yocHCegskl+QwcQJycwWaG
 R1D7xFJUOXBLWLXr4CUiilPoG47uZJ7Q9swO5CBf8uhpqOR2OCGmsbSn4kmOftG8Q/th3Uu/H
 3DkGMPJuguyIj4mVtZ8QmdbnMDwv2sbQQEIssCluOrb6YX2sofycZkZbsIjbJNkDBgooCgCQ6
 hlgTL/higUmhjrJT0vDmeL5TGvEOA//6qqSbB2QzG7AN5+gdkMsGaZzPnEfZusFArqJ0mmgnS
 rFx+2XAhCtNvEFDra5UZD6vLa+2TyF1+K7+OO0g8RDa7xExklDgnjIVswNGW99vhS7wsXIV+K
 aASlNC49VB/sEmJaPUIFv16Z193CMjVS4CbCY8rhAJjONxjF/rTSgPXydWFlN/fUu9Y/PTjms
 /P6bHlM20XlrOc5aVGy8SmPF5rF0kFHLkoeOsdgub5+I8ZqXXUeLFaEdypWUhqWTkSVhdr/Lk
 08JmwM3TGmFuv0Irs+ACVRxZ1XbAX3lt7cQgRmc1bBaVOanCfx8T1ay5j5eEAfzcA6ii8FvMq
 Yy8idcTrR8HIV94d8nr1h14YpuHbn9g+9sN8u62rlAEbaioZrPd2rsjEympmxk33MIbfiW1yH
 +W7KJ+qfG1d9UP/DJgVXUyak4Z7O2GIfB70xuQeLv3+fqwSjmXS00unPpKOseZfrLRr3OPYQe
 GcJBMh5+vLbxKrGhTnTTDuoFJwlWfXhmXRU5bSgZS1VCVMOOLQ=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 8, 2020 at 1:16 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2020-05-07 15:00, Nick Desaulniers wrote:
> > On Thu, May 7, 2020 at 12:18 PM kbuild test robot <lkp@intel.com> wrote:
> >> All errors (new ones prefixed by >>):
> >>
> >>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
> >>>> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
> >>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
> >>                                   ^
> >
> > Hi Bart,
> > These compiler specific pragma's are not toolchain portable.  You'll
> > need to wrap them in:
> > #ifndef __clang__
> > preprocessor macros, or I think we have a pragma helper in tree that
> > helps with compiler specific pragmas.  IIRC it uses _Pragma to define
> > pragmas in macros.
> Hi Nick,
>
> Thanks for the feedback. I will have a look at _Pragma() and see what
> the best way is to suppress this warning.

The __diag_ignore() macro in linux/compiler.h should work for this.

       Arnd
