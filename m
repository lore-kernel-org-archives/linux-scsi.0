From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: avoid oops when destroying unbound connection
Date: Mon, 30 Oct 2006 13:30:12 -0600
Message-ID: <454652C4.5040806@cs.wisc.edu>
References: <20061030012912.GA12233@osc.edu> <45463E29.2070204@cs.wisc.edu> <20061030191752.GA13857@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:20655 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030405AbWJ3TaT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 14:30:19 -0500
In-Reply-To: <20061030191752.GA13857@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: linux-scsi@vger.kernel.org

Pete Wyckoff wrote:
> michaelc@cs.wisc.edu wrote on Mon, 30 Oct 2006 12:02 -0600:
>> Thanks for the patch. We actually already fixed this by just removing
>> that list. It was not being used for what it was originally intended and
>> was getting in the way.
>>
>> The fix should be in 2.6.19-rc4 when it comes out.
> 
> That's even better.  For future reference, where is the SCSI or
> iSCSI development tree?  I had guessed it might be jejb's
> scsi-misc-2.6 git, but that still has conn->item, as does your
> linux-2.6-iscsi git.  If I can check for fixes before sending off a

You have to checkout the iscsi branch (git checkout iscsi) after you
have downloaded the linux-2.6-iscsi.git tree.

> patch, it will save us all some time.
> 

James switches from scsi-misc to scsi-rc fixes depending on the timing
(rc4 vs not even rc1) and patch type (fix vs feature). This patch was
put in scsi-rc-fixes here

http://kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=98644047916c24258fb47c3dab2bed8a44f53b83

and sent to upwards with his last patchset.
