From: Greg KH <greg@kroah.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 6 Sep 2010 14:16:03 -0700
Message-ID: <20100906211603.GD5863@kroah.com>
References: <4C76CA57.3050405@vlnb.net> <1282857806.32007.175.camel@haakon2.linux-iscsi.org> <4C79484B.3090607@vlnb.net> <1283028468.32007.357.camel@haakon2.linux-iscsi.org> <4C7C18CE.5020103@vlnb.net> <1283204792.32007.448.camel@haakon2.linux-iscsi.org> <4C7FFD1A.8090509@vlnb.net> <1283459158.5598.143.camel@haakon2.linux-iscsi.org> <20100905201802.GC18411@core.coreip.homeip.net> <1283723447.556.133.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283723447.556.133.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 05, 2010 at 02:50:47PM -0700, Nicholas A. Bellinger wrote:
> So as to the specifics about why git is really the only right SCM choice
> for mainline target mode maintainership, it really all comes down to
> workflow.  Does your SCM allow other people to easily and without-pain
> track your upstream subsystem tree changes and 'rebase' as necessary for
> their patch series you make improvements..?   If we are talking about
> say, a single standalone driver being developed against mainline, then
> sure using a SCM like CVS or SVN is perfectly acceptable when you push
> to someone upstream like gregkh or akpm via email patch attachments.

I actually use git to manage my quilt patch tree so that others can work
with me.  Don't confuse a scm with a patch management tool, they are two
vastly different things and have no relation to each other here.

And this sub-topic has NOTHING to do with the main issue here, so I
don't know why you are arguing over it.  Please take it elsewhere.

thanks,

greg k-h
