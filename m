From: David Binderman <dcb314@hotmail.com>
Subject: scsi_debug.c:1626: possible bad test ?
Date: Mon, 22 Dec 2014 10:33:00 +0000
Message-ID: <DUB128-W80F644976824C7B223344C9C560@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dub004-omc4s24.hotmail.com ([157.55.2.99]:49711 "EHLO
	DUB004-OMC4S24.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193AbaLVKiL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2014 05:38:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello there,

drivers/scsi/scsi_debug.c:1626:20: warning: logical =91and=92 of mutual=
ly exclusive tests is always false [-Wlogical-op]

Source code is

=A0=A0=A0 if (alloc_len < 4 && alloc_len> 0xffff) {

Suggest swap && for ||. Adding -Wlogical-op to the build might also hel=
p

Regards

David Binderman

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
