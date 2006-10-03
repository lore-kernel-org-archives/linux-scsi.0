From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport
 is blocked.
Date: Tue, 03 Oct 2006 10:24:11 -0400
Message-ID: <4522728B.5000800@emulex.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511007-git-send-email-andrew.vasquez@qlogic.com> <452167C8.3010401@emulex.com> <20061002221424.GP16272@parisc-linux.org> <20061002230531.GB27360@us.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44744 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932251AbWJCOYe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Oct 2006 10:24:34 -0400
In-Reply-To: <20061002230531.GB27360@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

Read the following:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115583213624803&w=2

It explains the error window....

-- james

Mike Anderson wrote:
> Matthew Wilcox <matthew@wil.cx> wrote:
>> On Mon, Oct 02, 2006 at 03:26:00PM -0400, James Smart wrote:
>>> - Fix the error handler. (but we all know this is a lot of work,
>>>     of which none of us have the time to do, nor expect it to
>>>     be complete in time for our next distro delivery).
>> Can't you fix this in the driver instead?  Seems to me that
>> .eh_timed_out in the SHT would be enough to fix this case.  Just keep
>> returning EH_RESET_TIMER until the condition expires.
> 
> This is already done in fc_timed_out.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
