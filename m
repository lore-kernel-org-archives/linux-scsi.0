From: Stephen Cameron <stephenmcameron@gmail.com>
Subject: Re: [PATCH] hpsa: do not attempt to read from a write-only register
Date: Thu, 21 Jul 2011 13:17:58 -0500
Message-ID: <CADzpL0Tfng4=k4wnewi=N2tVQdi5-9PXBcrzCL0sAONF+fdmEQ@mail.gmail.com>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 21, 2011 at 1:16 PM, Stephen M. Cameron
<scameron@beardog.cce.hp.com> wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Most smartarrays tolerate it, but a few new ones don't.
> Without this change some newer Smart Arrays will lock up
> and i/o will grind to a halt.


Noticed this wasn't in Linus's git tree yet, so resent it.

-- steve
