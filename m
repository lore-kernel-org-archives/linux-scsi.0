From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_error thread exits in TASK_INTERRUPTIBLE state.
Date: Wed, 19 Oct 2005 12:31:31 +0100
Message-ID: <20051019113131.GA30553@infradead.org>
References: <5bdc1c8b0510181402o2d9badb0sd18012cf7ff2a329@mail.gmail.com> <1129693423.8910.54.camel@mindpipe> <1129695564.8910.64.camel@mindpipe> <Pine.LNX.4.58.0510190300010.20634@localhost.localdomain> <Pine.LNX.4.58.0510190349590.20634@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750779AbVJSLbm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0510190349590.20634@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lee Revell <rlrevell@joe-job.com>, Mark Knecht <markknecht@gmail.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, rmk@arm.linux.org.uk, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, andmike@us.ibm.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +	/*
> +	 * There's a good chance that the loop will exit in the
> +	 * TASK_INTERRUPTIBLE state.
> +	 */
> +	__set_current_state(TASK_RUNNING);

no need to comment the obvious.
