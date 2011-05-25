From: Peter Chang <dpf@google.com>
Subject: Re: Question about aborting commands
Date: Wed, 25 May 2011 11:57:41 -0700
Message-ID: <BANLkTi=+MKXWGb=RFOQXvmEOh_QUa3CzPg@mail.gmail.com>
References: <20110525135035.GK26570@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:28992 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1EYS6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2011 14:58:06 -0400
Received: from hpaq13.eem.corp.google.com (hpaq13.eem.corp.google.com [172.25.149.13])
	by smtp-out.google.com with ESMTP id p4PIw46U014719
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 11:58:04 -0700
Received: from pwi15 (pwi15.prod.google.com [10.241.219.15])
	by hpaq13.eem.corp.google.com with ESMTP id p4PIw1EA014289
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 11:58:03 -0700
Received: by pwi15 with SMTP id 15so20411pwi.33
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 11:58:01 -0700 (PDT)
In-Reply-To: <20110525135035.GK26570@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Le 25 mai 2011 06:50,  <scameron@beardog.cce.hp.com> a =E9crit :
> Or, maybe I should be reporting the CMD_ABORTED case back as
>
> =A0 =A0 =A0 =A0cmd->result =3D DID_SOFT_ERROR << 16;

look at scsi_error.c:scsi_decide_disposition(). DID_SOFT_ERROR
triggers retry handling while DID_ABORT does not (at least in the tree
that i'm looking at).

\p
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
