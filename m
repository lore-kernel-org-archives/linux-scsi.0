From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage driver
 out of the staging area
Date: Tue, 20 Dec 2011 15:06:28 -0800
Message-ID: <CAA9_cmf2RQapBD3th-RAhhTBB64N9ChKNFNXz0PEZJexeQUoqw@mail.gmail.com>
References: <1324407064-16875-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324407064-16875-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, James.Bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 20, 2011 at 10:51 AM, K. Y. Srinivasan <kys@microsoft.com> =
wrote:
> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in t=
he
> staging tree for a while and this patch moves it out of the staging a=
rea.
> As per Greg's recommendation, this patch makes no changes to the stag=
ing/hv
> directory. Once the driver moves out of staging, we will cleanup the
> staging/hv directory.
>
> This patch includes all the patches that I have sent against the stag=
ing/hv
> tree to address the comments I have gotten to date on this storage dr=
iver.
> Greg has already applied all these patches to the staging tree.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
> =A0drivers/scsi/Kconfig =A0 =A0 =A0 | =A0 =A07 +
> =A0drivers/scsi/Makefile =A0 =A0 =A0| =A0 =A03 +
> =A0drivers/scsi/storvsc_drv.c | 1586 ++++++++++++++++++++++++++++++++=
++++++++++++
> =A03 files changed, 1596 insertions(+), 0 deletions(-)
> =A0create mode 100644 drivers/scsi/storvsc_drv.c

Shouldn't this diffstat be something like the following?

 drivers/scsi/Kconfig                       |    7 +
 drivers/scsi/Makefile                      |    3 +
 drivers/{staging/hv =3D> scsi}/storvsc_drv.c |  310 ++++++++++++++++++=
+---------
 3 files changed, 218 insertions(+), 102 deletions(-)
 rename drivers/{staging/hv =3D> scsi}/storvsc_drv.c (87%)
