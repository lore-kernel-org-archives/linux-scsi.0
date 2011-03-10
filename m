From: va stg2010 <va.storage2010@gmail.com>
Subject: Calling scsi_add_host multiple times for concurency
Date: Thu, 10 Mar 2011 08:35:34 -0800
Message-ID: <AANLkTikKbsoSmfoW9Ma7agW4SFBPEFPPPp7QeB_+9i0H@mail.gmail.com>
References: <AANLkTinKxORC1P0zY6LUupUU89WTAsN_FQ+dPhjtw6EW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59989 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1CJQff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2011 11:35:35 -0500
Received: by yxs7 with SMTP id 7so732398yxs.19
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2011 08:35:35 -0800 (PST)
In-Reply-To: <AANLkTinKxORC1P0zY6LUupUU89WTAsN_FQ+dPhjtw6EW@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi
My initiator HBA=A0 has 4 ports. Right now=A0 I call scsi_add_host() on=
ly once.
Currently I have single queue for all 4 ports where=A0 pending scsi
commands wait till interrupt handler posts response.=A0 I am trying to
add more queue (one per port) to reduce some locking contention.

Can I expect higher concurrency if I call scsi_add_host 4 times , one
for each port. ?
Is it going to work if I call scsi_add_host=A0 4 times and=A0 will
allocate queue (for pending scsi commands) for each scsi host I
registered?
What performance benefits can I expect, if any?

There can be multiple initiators doing I/O=A0 via=A0 my 4 port initiato=
r=A0 HBA.

thankyou
vks
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
