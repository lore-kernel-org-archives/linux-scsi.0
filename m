From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Tue, 26 Apr 2016 20:44:59 -0400
Message-ID: <yq1bn4vg9ro.fsf@sermon.lab.mkp.net>
References: <20160419085221.GA29087@gmail.com> <5249561.9VpAPLD61M@wuerfel>
	<yq14maoh635.fsf@sermon.lab.mkp.net> <5298237.1Guzp0G04x@wuerfel>
	<1461710218.2348.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbcD0AqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2016 20:46:18 -0400
In-Reply-To: <1461710218.2348.27.camel@HansenPartnership.com> (James
	Bottomley's message of "Tue, 26 Apr 2016 15:36:58 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

>> The last point is what Denys introduced in the kernel with
>> bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of
>> some byteswap operations"). So maybe it's better after all to revert
>> that patch, to have a higher confidence in the same bug not appearing
>> elsewhere. It's also really a workaround for another quirk of the
>> compiler, but that one only results in duplicated functions in object
>> code rather than functions that end in the middle.

James> Yes, I think this is my preferred option.

Same here.

-- 
Martin K. Petersen	Oracle Linux Engineering
