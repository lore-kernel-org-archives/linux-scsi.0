From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] arcmsr: Modify maxium outstanding command
Date: Fri, 23 Aug 2013 13:31:04 -0400
Message-ID: <1377279064.4147.51.camel@dabdike>
References: <1068BE1DEB04498495FD7913A7B2CA53@chingDT>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1068BE1DEB04498495FD7913A7B2CA53@chingDT>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?=E9=BB=83=E6=B8=85=E9=9A=86?= <ching2048@areca.com.tw>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, ching2048@gmai.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-07-17 at 10:52 +0800, =E9=BB=83=E6=B8=85=E9=9A=86 wrote:
> From: Ching<ching2048@areca.com.tw>
>=20
> Modify maximum outstanding command number, notify command complete wi=
th auto=20
> request sense, reassign ARC12x4 series to SATA type adapter
> Signed-off-by: Chingching2048@areca.com.tw

That should be

Signed-off-by: Ching <ching2048@areca.com.tw>

Shouldn't it?

Also, this patch doesn't apply; it doesn't look to be constructed
against an upstream version of the driver:
patching file drivers/scsi/arcmsr/arcmsr.h
Hunk #1 FAILED at 51.
Hunk #2 FAILED at 705.
2 out of 2 hunks FAILED -- saving rejects to file
drivers/scsi/arcmsr/arcmsr.h.rej
patching file drivers/scsi/arcmsr/arcmsr_hba.c
Hunk #2 FAILED at 71.
Hunk #3 FAILED at 1329.
Hunk #4 FAILED at 3313.
Hunk #5 succeeded at 3040 with fuzz 2 (offset -670 lines).
Hunk #6 succeeded at 3106 (offset -1780 lines).
Hunk #7 FAILED at 4894.
4 out of 7 hunks FAILED -- saving rejects to file
drivers/scsi/arcmsr/arcmsr_hba.c.rej

James
