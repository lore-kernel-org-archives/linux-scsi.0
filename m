From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: DPC vs tasklet
Date: Thu, 20 May 2004 17:36:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD20B05A9.954B29CD-ON85256E9B.0002C560-88256E9B.000355CC@us.ibm.com>
References: <40ACE612.8020800@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:44216 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265326AbUEUAg3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 20:36:29 -0400
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e1.ny.us.ibm.com (8.12.10/NS PXFA) with ESMTP id i4L0aSV8430782
	for <linux-scsi@vger.kernel.org>; Thu, 20 May 2004 20:36:28 -0400
Received: from d01ml604.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i4L0b4qH100742
	for <linux-scsi@vger.kernel.org>; Thu, 20 May 2004 20:37:05 -0400
In-Reply-To: <40ACE612.8020800@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> Some
> of the LINUX documentation I've read states "tasklets are the preferred
> mechanism with which to implement your bottom half for a normal hardware
> device".

In all the great answers about why other things are better than tasklets, 
the basic question of why this documentation doesn't agree isn't 
addressed.  Let me try:  I believe the context of this statement is a 
comparison to the more traditional Unix method of implementing the bottom 
half in the interrupt handler.  The statement is saying that a tasklet is 
normally preferred to putting the same processing right in the interrupt 
handler.

But in at least some cases, a kernel thread is better than either of 
those.

