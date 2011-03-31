From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: caviar black + mpt2sas horrific performance
Date: Thu, 31 Mar 2011 09:07:05 -0600
Message-ID: <4565AEA676113A449269C2F3A549520F808648E9@cosmail03.lsi.com>
References: <20110330080114.GA5066@apartia.fr>
 <4565AEA676113A449269C2F3A549520F8086471A@cosmail03.lsi.com>
 <20110330201700.GA6775@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:35500 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278Ab1CaPFv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2011 11:05:51 -0400
In-Reply-To: <20110330201700.GA6775@apartia.fr>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wednesday, March 30, 2011 2:17 PM, Louis-David Mitterrand wrote:
> On Wed, Mar 30, 2011 at 02:02:12PM -0600, Moore, Eric wrote:
> > Hi Louis, can you send me your /var/log/messages and dmesg output?
> > Please capture after you've run your test.
> 
> Hi,
> 
> My test produces no specific output through dmesg or /var/log/messages
> as there is no apparent error from the controller.
> 
> However I can send you the syslog startup output. Let me know if I can
> run any further tests or provide more information.
> 

need you to set the mpt2sas logging level to 0x310 just before you run you test, then capture the logs after.  
Please make sure your syslog level is set to capture all KERN_XXX levels to include KERN_DEBUG.

Example:
# echo 0x310 > /sys/module/mpt2sas/parameters/logging_level
