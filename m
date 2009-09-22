From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] be2iscsi: Moving to pci_pools v2
Date: Mon, 21 Sep 2009 21:15:21 -0500
Message-ID: <4AB83339.2020907@cs.wisc.edu>
References: <20090922015657.GA16231@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50357 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZIVCP3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Sep 2009 22:15:29 -0400
In-Reply-To: <20090922015657.GA16231@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

Jayamohan Kallickal wrote:
>  /**
> @@ -108,15 +101,9 @@ void beiscsi_session_destroy(struct iscsi_cls_se=
ssion *cls_session)
>  	struct iscsi_task *task;
>  	struct beiscsi_io_task *io_task;
>  	struct iscsi_session *sess =3D cls_session->dd_data;

Sorry to do this to you again.

I was compiling the patch and got this:
drivers/scsi/be2iscsi/be_iscsi.c: In function =91beiscsi_session_destro=
y=92:
drivers/scsi/be2iscsi/be_iscsi.c:102: warning: unused variable =91io_ta=
sk=92
drivers/scsi/be2iscsi/be_iscsi.c:101: warning: unused variable =91task=92

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
