From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: be2iscsi: Adding features to be2iscsi -V2
Date: Tue, 13 Jul 2010 11:26:22 -0700
Message-ID: <20100713182622.88dd703d@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:35213 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0GMS2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2010 14:28:49 -0400
In-Reply-To: 4C3C1516.4000708@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de



  _____  
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Sent: Tue, 13 Jul 2010 00:26:14 -0700
Subject: Re: be2iscsi: Adding features to be2iscsi -V2

On 07/12/2010 12:47 PM, Jayamohan Kallickal wrote:
> Hi
>
>    	These set of patches have been made on
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git
>

You should not make the patches over that tree, because it is missing 
some be2iscsi patches. You should have just brought the needed boot 
patches into scsi-misc or linus's tree or scsi-rc-fixes. The first 
couple of patches do not apply.


 I was following a request to base it on the ibft-2.6 for iscsi_boot
 purposes.  I need to pull in the iscsi boot changes from ibft tree 
and merge with my changes and submit like the previous submission.


I will rebase on top of the latest scsi-misc.



___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

