From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 09/15] megaraid_sas: Dual Queue depth support
Date: Wed, 27 Jan 2016 12:39:40 +0530
Message-ID: <621bde6eaedf5577d81013b828222cb9@mail.gmail.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
	<1450445228-26571-10-git-send-email-Sumit.Saxena@avagotech.com>
	<569E3B51.9070103@redhat.com>	<54361777a29aaf5a2c81a5456da0de50@mail.gmail.com>
	<569F91D3.6020309@redhat.com>	<c7c1d7ab31105f2bf57fe20b326d2a5e@mail.gmail.com>
	<569F96A5.3080001@redhat.com> <yq1k2mvixus.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35302 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbcA0HJn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2016 02:09:43 -0500
Received: by mail-lb0-f181.google.com with SMTP id bc4so105340779lbc.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2016 23:09:42 -0800 (PST)
In-Reply-To: <yq1k2mvixus.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>
Cc: jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@avagotech.com>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, January 27, 2016 7:32 AM
> To: Tomas Henzl
> Cc: Sumit Saxena; jbottomley@parallels.com; hch@infradead.org;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org; Kashyap Desai
> Subject: Re: [PATCH 09/15] megaraid_sas: Dual Queue depth support
>
> >>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:
>
> >> Yes this is already covered internally, there would be perf penalty
> >> with VDs in configuration but this feature will be turned on based on
> >> firmware settings and that specific firmware deployment has primary
> >> purpose of increasing JBOD performance. This focuses on firmware
> >> deployment with less VDs(or no) and more JBODs in configuration.
>
> Tomas> OK, so it is switched off by default in the firmware and the user
> Tomas> and an educated user can switch it on ? if so, it's fine for me.
>
> Sumit?

Yes, this feature will be enabled for specific firmware only. On rest of
firmware types, it will be disabled(not supported).

Thanks,
Sumit
>
> --
> Martin K. Petersen	Oracle Linux Engineering
