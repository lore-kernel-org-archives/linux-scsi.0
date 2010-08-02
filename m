From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
Date: Mon, 2 Aug 2010 16:31:28 -0700
Message-ID: <20100802233128.GA21286@kroah.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
 <AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biederman <ebiederm@aristanetworks.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Richard Purdie <rpurdie@rpsys.net>, Greg Kroah-Hartman <gregkh@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>, Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Jani Nikula <ext-jani.1.nikula@nokia.com>, Linus Walleij <linus.walleij@stericsson.com>, Chris Wright <chrisw@sous-sol.org>, Nick Cheng <nick.cheng@areca.com.tw>, James Smart <james.smart@emulex.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 28, 2010 at 11:16:35PM -0700, Eric Biederman wrote:
> On Wed, Jul 28, 2010 at 10:09 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > The following comment is found in include/linux/sysfs.h:
> >
> > =A0 /* FIXME
> > =A0 =A0* The *owner field is no longer used.
> > =A0 =A0* x86 tree has been cleaned up. The owner
> > =A0 =A0* attribute is still left for other arches.
> > =A0 =A0*/
> >
> > As it turns out, the *owner field is (again?) initialized in severa=
l modules,
> > suggesting that such initialization may be creeping back into the c=
ode.
> >
> > This patch set removes the above comment, the *owner field, and eac=
h instance
> > in the code where it was found to be initialized.
> >
> > Compiled with x86 allmodconfig as well as with all alpha, arm, mips=
, powerpc,
> > and sparc defconfig builds.
>=20
> This seems reasonable to me.  Can we get this in linux-next?

It will show up in linux-next tomorrow.

thanks,

greg k-h
