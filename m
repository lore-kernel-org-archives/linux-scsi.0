From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: Several Misc SCSI updates...
Date: Sun, 17 Nov 2002 12:29:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211171228350.1370-100000@home.transmeta.com>
References: <20021117202826.GE3280@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20021117202826.GE3280@redhat.com>
To: Doug Ledford <dledford@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Sun, 17 Nov 2002, Doug Ledford wrote:
>
> These bring the scsi subsys up to the new module loader semantics.  There 
> is more work to be done on inter-module locking here, but we need to solve 
> the whole module->live is 0 during init problem first or else it's a waste 
> of time.

Hey, just remove the "live" test, I think it's over-eager and likely to 
just cause extra code to work around it rather than fix anything.

		Linus
