From: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Wed, 12 Jan 2011 12:01:56 -0800
Message-ID: <AANLkTikEusD_CvkOERsr_wr7T70g1kuU=JnBJm5ur5Wg@mail.gmail.com>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com>
	<20110112112142.GA9610@mtj.dyndns.org>
	<4D2DF45B.5010101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60894 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1ALUB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jan 2011 15:01:57 -0500
Received: by iwn9 with SMTP id 9so879853iwn.19
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2011 12:01:56 -0800 (PST)
In-Reply-To: <4D2DF45B.5010101@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org

>
> The bottom line is that this patch simply wants to trigger an ATA com=
mand,
> and return immediately, discarding the command results. =A0I'm not ev=
en sure a
> "run this command in background, and discard results" facility requir=
es the
> EH.
>

This is why I was asking if using a workqueue instead of EH might be a
better idea.
EH looks like an overkill here.

Maksim.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
