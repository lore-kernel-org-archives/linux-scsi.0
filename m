From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 68/77] ncr5380: Fix whitespace issues using regexp
Date: Tue, 22 Dec 2015 06:46:55 -0800
Message-ID: <1450795615.21677.10.camel@perches.com>
References: <20151222011737.980475848@telegraphics.com.au>
	 <20151222011756.506380156@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011756.506380156@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-12-22 at 12:18 +1100, Finn Thain wrote:
> This patch is just the result of two substitutions. The first removes=
 any
> tabs and spaces at the end of the line. The second replaces runs of
> tabs and spaces at the beginning of comment lines with a single space=
=2E

I think the second of these isn't done well.
Many of these comments post reformatting are
much worse to read because of lost alignment.

=46or instance:

> +/*
> =A0 * Function : int NCR5380_select(struct Scsi_Host *instance,
> - *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0struct scsi_cmnd *cmd)
> + * struct scsi_cmnd *cmd)
> =A0 *
> =A0 * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existin=
g command,
> - *=A0=A0=A0=A0=A0=A0including ARBITRATION, SELECTION, and initial me=
ssage out for=A0
> - *=A0=A0=A0=A0=A0=A0IDENTIFY and queue messages.=A0
> + * including ARBITRATION, SELECTION, and initial message out for
> + * IDENTIFY and queue messages.
