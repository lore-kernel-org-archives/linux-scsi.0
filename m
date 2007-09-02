From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH -mm] IPS SCSI driver: Check return of scsi_add_host()
Date: Sun, 2 Sep 2007 22:03:39 +0200
Message-ID: <200709022203.39922.jesper.juhl@gmail.com>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:16942 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXIBUG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Sep 2007 16:06:58 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1181878fkz
        for <linux-scsi@vger.kernel.org>; Sun, 02 Sep 2007 13:06:57 -0700 (PDT)
In-Reply-To: <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>, aacraid@adaptec.com, linux-scsi@vger.kernel.org

On Sunday 02 September 2007 22:13:49 Satyam Sharma wrote:
>=20
> drivers/scsi/ips.c: In function =E2=80=98ips_register_scsi=E2=80=99:
> drivers/scsi/ips.c:6869:
> warning: ignoring return value of =E2=80=98scsi_add_host=E2=80=99, de=
clared with attribute warn_unused_result
>=20
> scsi_add_host() is __must_check, so let's check it's return and clean=
up
> appropriately on errors.
>=20
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
>=20
[snip]

Something seems to be wrong either at your end or mine
> +		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to add SCSI host=C2=A5=
n");

This should end with a newline  "\n"  but I'm seeing "=C2=A5n" ...


/Jesper

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
