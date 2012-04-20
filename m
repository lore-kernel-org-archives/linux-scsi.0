From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Fri, 20 Apr 2012 21:41:20 +0100
Message-ID: <20120420214120.159e2690@pyramind.ukuu.org.uk>
References: <20111215214440.GA17677@redhat.com>
	<4EF039D5.5010201@suse.de>
	<20120405144721.GA18437@redhat.com>
	<20120420144538.GB8155@redhat.com>
	<20120420173405.GA8846@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420173405.GA8846@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 20 Apr 2012 13:34:05 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> Allow a proprietary non-GPL multipath driver, like EMC PowerPath, to
> detach a scsi_dh using scsi_dh_detach. 

That I doubt somehow. The GPL covers *all* derivative works.
EXPORT_SYMBOL doesn't magically make code non-derivative. If you need to
modify the kernel to make your driver work *and* you want to claim it is
not derivative then I hope there are good lawyers involved 8-)

The kernel is GPL, all derived works of a GPL codebase are required to be
GPL. There is no magic rule about modules. I've stated that repeatedly
for anything containing a line of code I own. GregKH has made it very
clear for his code, and so it goes on.

> End result is Linux and PowerPath can coexist without compromising
> Linux's default handling of multipath LUNs.

So your specific purpose seems to me to be to enable a third party piece
of non-free code to hook into a piece of GPL code that it needs (which to
me implies it is derivative if it does). There is an offence of
"conspiracy to commit copyright infringement" so merely grinning and
saying its for a third party doesn't let your company off the hook either.

You should probably forward it to your legal teams before taking any
other action. Deleting it won't make it go away. It's up to them to
decide if they think they can argue properly that the work is not
derivative. I shall be most intrigued to see anyone make that argument,
but hey I'm not a lawyer.

I'm dying to see anyone make the moral argument for it too.

Alan
