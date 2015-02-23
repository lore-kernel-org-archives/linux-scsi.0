From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 3/4] scsi: ufs: add trace events and dump prints for
 debug
Date: Mon, 23 Feb 2015 06:51:02 -0500
Message-ID: <20150223065102.53c531a1@gandalf.local.home>
References: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
	<1424678898-3723-4-git-send-email-gbroner@codeaurora.org>
	<df4c1939ba0424539166b490f1d4a1f6.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <df4c1939ba0424539166b490f1d4a1f6.squirrel@www.codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dov Levenglick <dovl@codeaurora.org>
Cc: Gilad Broner <gbroner@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 23 Feb 2015 09:15:15 -0000
"Dov Levenglick" <dovl@codeaurora.org> wrote:

[ Cut's a 1000 lines of unneeded patch ]

> > +#endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ)
> > */
> > +
> > +/* This part must be outside protection */
> > +#include <trace/define_trace.h>
> > --
> > Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
> > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> > a Linux Foundation Collaborative Project
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Reviewed-by: Dov Levenglick <dovl@codeaurora.org>

Please, when you add a tag, do it just under the change log, not the
bottom of the patch. And cut out most of the text that people can read
your email on a single page.

It is extremely annoying to scroll down a 1000 lines to find no
comments and just someone giving their "Reviewed-by" tag.

-- Steve

> 
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
