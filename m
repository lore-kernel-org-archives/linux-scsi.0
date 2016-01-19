From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 14/15] megaraid_sas: SPERC OCR changes
Date: Tue, 19 Jan 2016 16:14:57 +0100
Message-ID: <569E52F1.2080006@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-15-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbcASPPA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 10:15:00 -0500
In-Reply-To: <1450445228-26571-15-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, Uday Lingala <uday.lingala@avagotech.com>

On 18.12.2015 14:27, Sumit Saxena wrote:
> This patch will do some fixes in OCR path of SRIOV enabled series of Avago controllers.
>
> 1)Removing late detection HB. 
> 2)Change in the behavior if the FW found in READY/OPERAETIONAL state.
>
> Signed-off-by: Uday Lingala <uday.lingala@avagotech.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

