From: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: Re: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Date: Mon, 7 Mar 2011 21:16:10 +0100
Message-ID: <20110307201610.GA9032@mako-laptop>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski wrote:
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing pointer =
to incomplete type
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: =E2=80=98MODULE_STATE_=
LIVE=E2=80=99 undeclared (first use in this function)

Hm. Still there in next-20110307. Is this patch wrong or..?

--=20
Mariusz Kozlowski
