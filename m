From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/10] qla2xxx: Reduce the number of Coverity warnings
Date: Sat, 08 Jun 2013 10:27:10 +0200
Message-ID: <51B2EADE.30500@acm.org>
References: <F5D084D6342F9B479C34599BB0A03E4D35390335@AVMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:43776 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3FHIcZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jun 2013 04:32:25 -0400
In-Reply-To: <F5D084D6342F9B479C34599BB0A03E4D35390335@AVMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>

On 06/07/13 21:06, Saurav Kashyap wrote:
> Thanks for the patches. Please share the warnings reported by Coverity, so
> that its easy for us to review the patches.

Hello Saurav,

The Coverity warnings that led me to developing this patch series are as 
follows:
- For patches 1, 2, 3, 8: Logically dead code - execution cannot reach 
this statement.
- For patch 4: Array compared against 0 (NO_EFFECT) array_null: 
Comparing an array to null is not useful: "ha->model_desc".
- For patch 5, 6 and 9: Unused pointer value.
- For patch 7: Overrunning struct type ct_sns_req of 1228 bytes by 
passing it to a function which accesses it at byte offset 8207.
- For patch 10: Resource leak (RESOURCE_LEAK) leaked_storage: Variable 
"fcport" going out of scope leaks the storage it points to.

Hope this helps,

Bart.
