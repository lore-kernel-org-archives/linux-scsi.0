From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Set response format in INQUIRY response
Date: Tue, 06 Dec 2011 18:01:22 -0800
Message-ID: <1323223282.25982.120.camel@haakon2.linux-iscsi.org>
References: <1323194529-17886-1-git-send-email-roland@kernel.org>
	 <1323214727.25982.57.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDWqpLUKuCKeYwZKGbcc+7REtGJycq+g8i16-UCB4-GH=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDWqpLUKuCKeYwZKGbcc+7REtGJycq+g8i16-UCB4-GH=Q@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-12-06 at 17:36 -0800, Roland Dreier wrote:
> On Tue, Dec 6, 2011 at 3:38 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > Out of curiosity, does this fix an bug in actual client usage..?
> 
> I think it was flagged by our analyzer software...

Ok, thanks for the extra clarification.

In that case I'll likely add it to target-pending.git/3.2-rc-fixes for a
follow-up series after Linus pulls the current series of outstanding
target patches for v3.2-rc.

Thanks,

--nab
