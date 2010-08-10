From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
Date: Tue, 10 Aug 2010 09:43:17 -0700
Message-ID: <1281458597.5745.255.camel@groeck-laptop>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
	<AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
	<20100802233128.GA21286@kroah.com>
	<20100810154337.006a0df9@hyperion.delvare>
	<20100811011733.16243ddb.sfr@canb.auug.org.au>
	<20100811012001.6fb50655.sfr@canb.auug.org.au>
Reply-To: guenter.roeck@ericsson.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20100811012001.6fb50655.sfr@canb.auug.org.au>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, David Woodhouse <David.Woodhouse@intel.com>, James Smart <james.smart@emulex.com>, Greg KH <greg@kroah.com>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Paul Mackerras <paulus@samba.org>, Nick Cheng <nick.cheng@areca.com.tw>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Eric Biederman <ebiederm@aristanetworks.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, Benjamin Thery <benjamin.thery@bull.net>, Chris Wright <chrisw@sous-sol.org>, Tejun Heo <tj@kernel.org>, Liam Girdwood <lrg@slimlogic.co.uk>, Linus Walleij <linus.walleij@stericsson.com>, Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Richard Purdie <rpurdie@rpsys.net>, Jani Nikula <ext-jani.1.nikula@nokia.c>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-08-10 at 11:20 -0400, Stephen Rothwell wrote:
> Hi Jean,
> 
> On Wed, 11 Aug 2010 01:17:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Tue, 10 Aug 2010 15:43:37 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> > >
> > > Related bug?
> > > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=16544
> > 
> > Yep, fixed in linux-next today - hopefully the fix is on its way to Linus.
> 
> Sorry, more info:
> 
> Fixed by commit 690e85a3957291f4cfe0cac22d97994ec7e5ee45 ("olpc_battery:
> Fix build failure caused by sysfs changes") from the battery tree.

Excellent. Guess the patch I sent out earlier today to fix the problem
wasn't needed then.

Guenter
