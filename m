From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Thu, 13 Nov 2008 14:22:56 -0600
Message-ID: <1226607776.3537.22.camel@localhost.localdomain>
References: <20081113201216.BB3A911D107@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48479 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbYKMUXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 15:23:02 -0500
In-Reply-To: <20081113201216.BB3A911D107@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-11-13 at 12:12 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> While we are at this function, could you please check 
> 
>         if (eh_timed_out)
>                 rtn = eh_timed_out(scmd);
>                 switch (rtn) {
>                 case BLK_EH_NOT_HANDLED:
>                         break;
>                 default:
>                         return rtn;
>                 }
> 
> 
> Is the indentation wrong or are there missing if-braces?

It's not as intended, but harmless:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=6ec39f02cf48df89c3cbab4aeef521569fec00e4

James


