From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: bidi support: FC transport layer...
Date: Sun, 13 Jul 2008 12:15:32 +0300
Message-ID: <4879C7B4.8000609@panasas.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com> <48762B07.703@panasas.com> <4414E10D-6015-4768-BD97-D4A51E439573@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27476 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750864AbYGMJPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2008 05:15:52 -0400
In-Reply-To: <4414E10D-6015-4768-BD97-D4A51E439573@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

Seokmann Ju wrote:
<snip>
> FC-CT and ELS are FC specifics.
> So, as far as I understood, the idea is to control and manage the  
> given FC layout via those frames without having any subsystem  
> interventions.
> One of the goal of the implementation is to provide pipe line in  
> between the application and the target devices under the given layout.
> Is the bidi tightly coupled with the SCSI CDB, or it can transport any  
> packet regardless its contents?
> 

There is *no* restrictions or filtering what so ever. You can send any 
kind of CDB with any kind of buffers as BIOs. Even better, the scsi
midlayer is very careful to immediately fail a bidi command and not 
try any kind of reties or error handling. So yes if you are emulating 
a command execution in SW you should be safe. What I said is true at 
scsi level, at block level of course there is no restrictions for 
any command.

<snip>

Boaz

