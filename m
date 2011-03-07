From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Date: Mon, 7 Mar 2011 15:54:35 -0800
Message-ID: <1299542075.5232.5.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
 <20110307201610.GA9032@mako-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=cp1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110307201610.GA9032@mako-laptop>
Sender: linux-next-owner@vger.kernel.org
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-03-07 at 12:16 -0800, Mariusz Kozlowski wrote:=20
> On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski wrote:
> > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing pointe=
r to incomplete type
> > drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: =91MODULE_STATE_LIVE=
=92 undeclared (first use in this function)
>=20
> Hm. Still there in next-20110307. Is this patch wrong or..?
>=20

James,

Here is my ack for this patch.

Thanks,
Bhanu
