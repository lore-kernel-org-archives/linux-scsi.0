From: Phil Brutsche <phil@brutsche.us>
Subject: Re: aacraid, seagate and adaptec issues [Was: Re: Fw: [Bugme-new]
 [Bug 3651] New: dell poweredge 4600 aacraid PERC 3/Di Container goes offline]
Date: Wed, 10 Nov 2004 14:33:19 -0600
Message-ID: <41927B0F.6000902@brutsche.us>
References: <20041028005302.753a2d52.akpm@osdl.org> <418138B6.2010104@brutsche.us> <1100031774.24635.157.camel@ryan2.internal.autoweb.net> <20041109213215.GA4047@guug.org> <20041110174346.GA8047@guug.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.optimumdata.com ([216.40.3.146]:31914 "EHLO
	mail.optimumdata.com") by vger.kernel.org with ESMTP
	id S262120AbUKJUd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 15:33:28 -0500
In-Reply-To: <20041110174346.GA8047@guug.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Otto Solares <solca@guug.org>
Cc: linux-scsi@vger.kernel.org

Otto Solares wrote:

> A seagate time-out issue with exactly my disks:
> 
> http://www.seagate.com/support/disc/u320_firmware.html

[...]

> Does anybody have this seagate firmware updates?

I have a pair of RAID5s with these Seagate drives; I have flashed the
firmware on the affected drives to the latest 0006 rev (they are 15k RPM
drives).

I *do not* have a problem with aacraid under vanilla 2.4.x and the
included aacraid driver.  The machine using these drives in a RAID5 with
an Adaptec controller has had uptimes of 4 months (or longer) without
any problems.

I *do* have a problem (check the archives for the error messages) with
2.6.9 and the included aacraid driver.

-- 

Phil Brutsche
phil@brutsche.us
