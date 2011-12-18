From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 14/24] libsas: prevent double completion of scmds from eh
Date: Sun, 18 Dec 2011 11:19:27 -0800
Message-ID: <CAA9_cmc4KdbVzr-sccxmF_pRQA++NB0ZK68J2HRo9jHeMgO0fQ@mail.gmail.com>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
	<20111217023420.15036.51486.stgit@localhost6.localdomain6>
	<4EEC9442.8090300@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47422 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1LRTT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2011 14:19:28 -0500
In-Reply-To: <4EEC9442.8090300@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sat, Dec 17, 2011 at 5:08 AM, Sergei Shtylyov <sshtylyov@mvista.com>=
 wrote:
>> + =A0 =A0 =A0 ASSIGN_SAS_TASK(sc, NULL);
>
>
> =A0 Why do it twice -- once here and then in sas_end_task()?

=2E..for the sas_eh_finish_cmd() case where eh has taken responsibility
for cleanup and the sas_scsi_task_done() path has been disabled.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
