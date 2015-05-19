From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 4/18] megaraid_sas : Move controller's queue depth
 calculation in adapter specific function
Date: Mon, 18 May 2015 23:22:27 -0700
Message-ID: <1432016547.4337.61.camel@HansenPartnership.com>
References: <201504231103.t3NB3Ajm029643@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59860 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbbESGWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 02:22:30 -0400
In-Reply-To: <201504231103.t3NB3Ajm029643@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, kashyap.desai@avagotech.com

On Thu, 2015-04-23 at 16:30 +0530, Sumit.Saxena@avagotech.com wrote:
> This patch will move internal commands and SCSI commands reservation
> in adapter's sepcific functions.

Commit messages like this aren't useful.  It's just the subject with
"This patch will" added.  The ideal is that you describe what's going on
at greater length in the commit message.  However, if the subject says
it all, just leave the message blank rather than repeating the subject
(and making me excise it again).

James


