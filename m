From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Mon, 4 Feb 2008 16:32:18 -0800 (PST)
Message-ID: <50030.21278.qm@web31808.mail.mud.yahoo.com>
References: <1202074856.3318.111.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1202074856.3318.111.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
List-Id: linux-scsi@vger.kernel.org

--- On Sun, 2/3/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> The enclosure misc device is really just a library providing
> sysfs
> support for physical enclosure devices and their
> components.

Who is the target audience/user of those facilities?
a) The kernel itself needing to read/write SES pages?
b) A user space application using sysfs to read/write
   SES pages?

At the moment SES device management is done via
an application (user-space) and a user-space library
used by the application and /dev/sgX to send SCSI
commands to the SES device.

One could have a very good argument to not bloat
the kernel with this but leave it to a user-space
application and a library to do all this and
communicate with the SES device via the kernel's /dev/sgX.

   Luben

