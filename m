From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 10/10] qla2xxx: Avoid that sparse complains about
 context imbalances
Date: Wed, 26 Aug 2015 10:48:07 -0700
Message-ID: <1440611287.2196.56.camel@HansenPartnership.com>
References: <559E8382.6030803@sandisk.com> <559E846A.20605@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49087 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbbHZRsI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 13:48:08 -0400
In-Reply-To: <559E846A.20605@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2015-07-09 at 07:25 -0700, Bart Van Assche wrote:
> Surround conditional locking statements with "#ifndef __CHECKER__" /
> "#endif" to hide these for the sparse static source code analysis
> tool.

Thanks!  I know I whine alot about checkpatch but having drivers sparse
clean like this one now is really helps in the compile phase of patch
checking.

James


