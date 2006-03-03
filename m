From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: qla4xxx : Driver v5.00.05b4-k - RFC requested!!!
Date: Fri, 3 Mar 2006 15:10:40 -0800
Message-ID: <3679966B84813344B908D418BA3F6A4A06EE4448@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:65387 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751653AbWCCXKk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 18:10:40 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>>On Thu, 2006-03-02 at 14:52 -0800, Arjan wrote:
>On Thu, 2006-03-02 at 14:52 -0800, Ravi Anand wrote:
> All,
> 
> For the upstream inclusion of qla4xxx driver, following files :


> - Updated driver source (qla4xxx-src-v5.00.05b4-k_submit.tar.bz2)


>>another thing:

+               set_current_state(TASK_UNINTERRUPTIBLE);
+               schedule_timeout(10);


>>this is obviously a bug.. for which HZ value is that 10?


>>I think you really want to use msleep() instead here, which uses
>>wallclock time units, and does the state setting for you as well.
>>(and is generally a nicer albeit simpler API than schedule_timeout() )

Agreed. We will switch to msleep().

Ravi

