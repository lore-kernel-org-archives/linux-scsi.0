From: Andrew Morton <akpm@digeo.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue
 reached
Date: Mon, 3 Mar 2003 17:11:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030303171116.0ca432a0.akpm@digeo.com>
References: <20030228111924.A32018@beaverton.ibm.com>
	<20030302085728.A11407@infradead.org>
	<3E639C1E.7060000@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id RAA13572
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2003 17:15:07 -0800 (PST)
In-Reply-To: <3E639C1E.7060000@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: hch@infradead.org, patmans@us.ibm.com, linux-scsi@vger.kernel.org

Luben Tuikov <luben@splentec.com> wrote:
>
> > Linux codingstyle sais the && should be before the line break.
> 
> Actually there's a point to this.
> 

Sorry, but tough luck.

The advantages of everyone using the same coding style outweigh the arguable
marginal benefits of introducing local inconsistencies.

I was a braces-on-a-new-line guy for nearly 20 years, but I knuckled under
and learnt to use Linus-style for this reason.  I'm sure others can manage
this.

