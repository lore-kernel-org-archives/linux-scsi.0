From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: TASK Vs TASK_SET
Date: Tue, 19 Jan 2010 11:11:02 -0500
Message-ID: <4B55D996.4000603@interlog.com>
References: <ac9fc6791001182248j3e523641i6c9d5a29dab088d2@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37741 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0ASQLI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2010 11:11:08 -0500
In-Reply-To: <ac9fc6791001182248j3e523641i6c9d5a29dab088d2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yukta eswar <yukta.eswar@gmail.com>
Cc: linux-scsi@vger.kernel.org

yukta eswar wrote:
> Dear All,
> 
> I am a newbie in SCSI task management.
> When I read the sam-4 document, I got confusion about TASK and TASK_SET.
> Can anyone let me know the difference.

I think George Penokie (SAM-5 editor) is going through the
SAM-5 (draft) and changing many usages of "TASK" to "COMMAND".
So a TASK is usually a single SCSI command that is being
processed by a logical unit. A TASK_SET is a set of SCSI
commands that are being processed by a logical unit at a point
of time.

Notice that a task management function like ABORT TASK
takes a I_T_L_Q nexus (identifying a command identifier within
a logical unit) while ABORT TASK SET takes a I_T_L nexus
(identifying a logical unit).

Doug Gilbert



