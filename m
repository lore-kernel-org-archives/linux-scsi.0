From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] softirq queue is now list_head, eliminate bh_next]
Date: Sat, 8 Mar 2003 18:08:19 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030308180819.A30285@infradead.org>
References: <3E6A2EBE.5050508@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E6A2EBE.5050508@splentec.com>; from luben@splentec.com on Sat, Mar 08, 2003 at 12:56:14PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On Sat, Mar 08, 2003 at 12:56:14PM -0500, Luben Tuikov wrote:
> The only comment I put after a closing brace of a function
> definition is /* end of fn_name() */ so that one can see
> which function ends if its definition (code) is only partly
> shown in one's screen.
> I hope that's ok with everyone?  If not, flame me now.

No need for a flame, but please remove the comment, there is a strong
tendency against this style of commenting in the core kernel code.

A related note from the CondingStyle document:

	Functions should be short and sweet, and do just one thing.  They should
	fit on one or two screenfuls of text (the ISO/ANSI screen size is 80x24,
	as we all know), and do one thing and do that well.

You're _code_ is actually fine regarding to that so you shouldn't need the
comments :)

