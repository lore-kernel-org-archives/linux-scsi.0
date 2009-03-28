From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: Dereferencing freed memory bugs
Date: Sat, 28 Mar 2009 19:50:09 +0100
Message-ID: <49CE7161.9000400@gmail.com>
References: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756799AbZC1Suj@vger.kernel.org>
In-Reply-To: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, eteo@redhat.com, aacraid@adaptec.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dan Carpenter wrote:
> I added a check to smatch (http://repo.or.cz/w/smatch.git/) to check
> for when we dereference
> freed memory.
> 
> (...)
> drivers/scsi/dpt_i2o.c +246 adpt_detect(58) 'pHba'
> drivers/scsi/dpt_i2o.c +266 adpt_detect(78) 'pHba'
> drivers/scsi/dpt_i2o.c +1236 adpt_i2o_delete_hba(78) 'pHba'
> (...)

Very old bug - it predates git import (2.6.12-rc2).

Adding CCs.
