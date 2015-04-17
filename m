From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 25/43] hpsa: do not print ioaccel2 warning messages
 about unusual completions.
Date: Fri, 17 Apr 2015 15:40:36 +0200
Message-ID: <55310D54.3020101@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134859.30238.19745.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118AbbDQNlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:41:02 -0400
In-Reply-To: <20150416134859.30238.19745.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:48 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> The SCSI midlayer already prints more detail about completions,
> and has logging level options to filter them if not wanted.
> These just slow down the system if a lot of errors occur,
> stressing error handling even more.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


