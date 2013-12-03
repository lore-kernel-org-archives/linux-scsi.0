From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [SCSI] qla2xxx: Question about out-of-order SCSI command processing
Date: Tue, 03 Dec 2013 13:09:35 +0100
Message-ID: <529DC9FF.6030109@acm.org>
References: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 87.238.162.66 ([87.238.162.66]:39441 "EHLO smtpgw.stone-is.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab3LCMiW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Dec 2013 07:38:22 -0500
In-Reply-To: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, Jerry Fredin <jerry.fredin@netapp.com>

On 12/02/13 23:12, Alireza Haghdoost wrote:
> Note that we are using kernel 3.11 and libaio to perform async IO.

I think libaio can reorder commands before these reach the SCSI core.

Bart.

