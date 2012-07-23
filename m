From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib: add NULL check to scsi_setup_blk_pc_cmnd
Date: Mon, 23 Jul 2012 23:45:55 +0400
Message-ID: <1343072755.5865.1.camel@dabdike>
References: <20120723173220.GA17767@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41794 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364Ab2GWTp7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jul 2012 15:45:59 -0400
In-Reply-To: <20120723173220.GA17767@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2012-07-23 at 13:32 -0400, J=C3=B6rn Engel wrote:
> At least two slightly different paths can lead to a NULL pointer
> dereference in scsi_prep_state_check and have been hit in practice.

Have you checked this with the patches in scsi-misc?  There's a series
of patches in there that alters the way sdev handling is done.

James




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
