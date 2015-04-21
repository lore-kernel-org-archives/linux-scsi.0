From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 8/18] megaraid_sas : Add release date and update
 driver version
Date: Tue, 21 Apr 2015 13:57:55 +0200
Message-ID: <55363B43.7070409@redhat.com>
References: <201504201235.t3KCZqwd016586@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbbDUL6Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 07:58:24 -0400
In-Reply-To: <201504201235.t3KCZqwd016586@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
> This patch will upgrade the driver version and add back the release date and sysfs hook for the same.
> Some internal applications uses sysfs parameter for release date, so they were broken because of removal
> of release date from sysfs.
>  
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

