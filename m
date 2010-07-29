From: Eric Biederman <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
Date: Wed, 28 Jul 2010 23:16:35 -0700
Message-ID: <AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50702 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0G2GQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2010 02:16:36 -0400
In-Reply-To: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Richard Purdie <rpurdie@rpsys.net>, Greg Kroah-Hartman <gregkh@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>, Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Jani Nikula <ext-jani.1.nikula@nokia.com>, Linus Walleij <linus.walleij@stericsson.com>, Chris Wright <chrisw@sous-sol.org>, Nick Cheng <nick.cheng@areca.com.tw>, James Smart <james.smart@emulex.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org

On Wed, Jul 28, 2010 at 10:09 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> The following comment is found in include/linux/sysfs.h:
>
> =A0 /* FIXME
> =A0 =A0* The *owner field is no longer used.
> =A0 =A0* x86 tree has been cleaned up. The owner
> =A0 =A0* attribute is still left for other arches.
> =A0 =A0*/
>
> As it turns out, the *owner field is (again?) initialized in several =
modules,
> suggesting that such initialization may be creeping back into the cod=
e.
>
> This patch set removes the above comment, the *owner field, and each =
instance
> in the code where it was found to be initialized.
>
> Compiled with x86 allmodconfig as well as with all alpha, arm, mips, =
powerpc,
> and sparc defconfig builds.

This seems reasonable to me.  Can we get this in linux-next?

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
