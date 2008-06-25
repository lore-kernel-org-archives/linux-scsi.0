From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Tue, 24 Jun 2008 22:06:43 -0400
Message-ID: <yq13an28dzg.fsf@sermon.lab.mkp.net>
References: <20080619160342.GJ4392@parisc-linux.org>
	<1214141931.4047.5.camel@localhost.localdomain>
	<20080622140323.GZ4392@parisc-linux.org>
	<yq14p7lttuo.fsf@sermon.lab.mkp.net>
	<20080622184435.GB4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:32817 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYFYCIj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2008 22:08:39 -0400
In-Reply-To: <20080622184435.GB4392@parisc-linux.org> (Matthew Wilcox's message of "Sun\, 22 Jun 2008 12\:44\:36 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> On Sun, Jun 22, 2008 at 10:41:35AM -0400, Martin K. Petersen wrote:
>> + memset(cmd, 0, 16); + cmd[0] = INQUIRY; + cmd[1] = 1; /* EVPD */
>> + cmd[2] = page; /* VPD page */ + cmd[3] = len;

Matthew> This looks like a bug to me.

Yeah, what I meant was cmd[4] = len;


Matthew> This isn't true for all pages.  For example, 0x83 and 0x85
Matthew> have a length in buffer[2] and [3].  

Fair enough.  I only looked at b0 and b1.

-- 
Martin K. Petersen	Oracle Linux Engineering

