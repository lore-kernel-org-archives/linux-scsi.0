From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Tue, 24 May 2005 12:09:58 -0500
Message-ID: <1116954598.5897.12.camel@mulgrave>
References: <1116711588.6289.32.camel@mina>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5592 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261901AbVEXRKH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 13:10:07 -0400
In-Reply-To: <1116711588.6289.32.camel@mina>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi <open-iscsi@googlegroups.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-05-21 at 14:39 -0700, Mike Christie wrote:
> `-- session1
>     |-- connection1:0
>     `-- target1:0:0
>         |-- 1:0:0:0

I understand that session1 represents the physical connection between
the target and the initiator, but what's connection1:0?

James


