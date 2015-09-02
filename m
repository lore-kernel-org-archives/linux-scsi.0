From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] SCSI: mvsas: Fix NULL pointer dereference in
 mvs_slot_task_free
Date: Wed, 2 Sep 2015 14:08:19 +0200
Message-ID: <55E6E6B3.5070900@redhat.com>
References: <1440131362-18605-1-git-send-email-davispuh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbbIBMIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Sep 2015 08:08:21 -0400
In-Reply-To: <1440131362-18605-1-git-send-email-davispuh@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org

On 21.8.2015 06:29, D=C4=81vis Mos=C4=81ns wrote:
> When pci_pool_alloc fails in mvs_task_prep then task->lldd_task stays
> NULL but it's later used in mvs_abort_task as slot which is passed
> to mvs_slot_task_free causing NULL pointer dereference.
>
> Just return from mvs_slot_task_free when passed with NULL slot.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D101891
> Signed-off-by: D=C4=81vis Mos=C4=81ns <davispuh@gmail.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Cheers,
Tomas

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
