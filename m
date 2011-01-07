From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] first set of SCSI patches for the 2.6.38 merge window
Date: Fri, 7 Jan 2011 12:49:40 -0800
Message-ID: <AANLkTi=GhdvQUgZh56XRx95+ZwiqaiJTw8ti-403Gse2@mail.gmail.com>
References: <1294345782.22825.341.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294345782.22825.341.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 6, 2011 at 12:29 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> ..
> =A0include/scsi/libsas.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
| =A0 =A02
> =A0include/scsi/scsi.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 | =A0 28
> =A0162 files changed, 16069 insertions(+), 12242 deletions(-)

You're missing a -M and a --summary. That should look like this:

  ...
  include/scsi/libsas.h                              |    2 +
  include/scsi/scsi.h                                |   28 +
  161 files changed, 11139 insertions(+), 7312 deletions(-)
  delete mode 100644 drivers/scsi/bfa/bfa_cb_ioim.h
  delete mode 100644 drivers/scsi/bfa/bfa_drv.c
  delete mode 100644 drivers/scsi/bfa/bfa_os_inc.h
  rename drivers/scsi/megaraid/{megaraid_sas.c =3D> megaraid_sas_base.c=
} (90%)
  create mode 100644 drivers/scsi/megaraid/megaraid_sas_fp.c
  create mode 100644 drivers/scsi/megaraid/megaraid_sas_fusion.c
  create mode 100644 drivers/scsi/megaraid/megaraid_sas_fusion.h

which makes those line numbers look at least a _bit_ better, since
that megaraid_sas_base.c file is pretty big.

                         Linus
