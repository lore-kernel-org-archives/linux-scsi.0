From: James Smart <james.smart@emulex.com>
Subject: Re: lpfc_debugfs_dumpHBASlim_data() stack space use
Date: Tue, 12 Jul 2011 22:26:21 -0400
Message-ID: <4E1D024D.3090205@emulex.com>
References: <4E1CA720.1040602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56725 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756693Ab1GMC0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 22:26:41 -0400
In-Reply-To: <4E1CA720.1040602@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

yes - something popped up with a recent change in the compiler.

The following patch addressed this issue.
http://marc.info/?l=linux-scsi&m=130655514918715&w=2

-- james s


On 7/12/2011 3:57 PM, Rob Evers wrote:
>    Hi James S.
>
> I noticed:
>
> static int
> lpfc_debugfs_dumpHBASlim_data(struct lpfc_hba *phba, char *buf, int size)
> {
>           int len = 0;
>           int i, off;
>           uint32_t *ptr;
>           char buffer[1024];
>
>
> Would 'char *buffer=kmalloc()' be more appropriate here?
>
> Rob
>
