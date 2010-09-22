From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] drivers: scsi: remove private hex_to_bin() implementation
Date: Wed, 22 Sep 2010 11:41:15 +0300
Message-ID: <AANLkTin8C-3ktNzDc1dz0wTrq0915BibZRdNR7O4L9fw@mail.gmail.com>
References: <1284212280-25944-1-git-send-email-andy.shevchenko@gmail.com>
	<1284213395.2986.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284213395.2986.9.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 11, 2010 at 4:56 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> the hex_to_bin() is really to prevent open coded mistakes. =C2=A0When=
 the
> open coding pre-dates the hex_to_bin macro, I'm inclined to leave it
> alone unless it contains an actual bug.
It's also a matter of speed/size optimization. Nevertheless SCSI
subsystem already has such clean up.

--=20
With Best Regards,
Andy Shevchenko
