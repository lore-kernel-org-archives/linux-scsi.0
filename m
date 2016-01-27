From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/15] megaraid_sas: Dual Queue depth support
Date: Tue, 26 Jan 2016 21:02:03 -0500
Message-ID: <yq1k2mvixus.fsf@sermon.lab.mkp.net>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
	<1450445228-26571-10-git-send-email-Sumit.Saxena@avagotech.com>
	<569E3B51.9070103@redhat.com>
	<54361777a29aaf5a2c81a5456da0de50@mail.gmail.com>
	<569F91D3.6020309@redhat.com>
	<c7c1d7ab31105f2bf57fe20b326d2a5e@mail.gmail.com>
	<569F96A5.3080001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48787 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbcA0CCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 21:02:43 -0500
In-Reply-To: <569F96A5.3080001@redhat.com> (Tomas Henzl's message of "Wed, 20
	Jan 2016 15:16:05 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@avagotech.com>

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

>> Yes this is already covered internally, there would be perf penalty
>> with VDs in configuration but this feature will be turned on based on
>> firmware settings and that specific firmware deployment has primary
>> purpose of increasing JBOD performance. This focuses on firmware
>> deployment with less VDs(or no) and more JBODs in configuration.

Tomas> OK, so it is switched off by default in the firmware and the user
Tomas> and an educated user can switch it on ? if so, it's fine for me.

Sumit?

-- 
Martin K. Petersen	Oracle Linux Engineering
