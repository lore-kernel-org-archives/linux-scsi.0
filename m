From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and	scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 17:20:42 +0900
Message-ID: <43D491DA.4020603@gmail.com>
References: <11379893764141-git-send-email-htejun@gmail.com> <1138001160.2977.14.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1138001160.2977.14.camel@laptopd505.fenrus.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 2006-01-23 at 13:09 +0900, Tejun Heo wrote:
> 
>>Export two SCSI EH command handling functions.  To be used by libata EH.
> 
> since these are pretty much internal, can we make these _GPL exports?
> 

It's SCSI developers' decision.  I chose EXPORT_SYMBOL because all other
exported symbols in scsi_error.c were using it.  James?

-- 
tejun
