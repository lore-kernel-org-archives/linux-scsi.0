From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [PATCH 1/1] libiscsi regression in 2.6.25: fix setting of recv timer
Date: Fri, 9 May 2008 16:57:41 +0200
Message-ID: <e2e108260805090757s4ed00c29w21da11a38515ab57@mail.gmail.com>
References: <1210295734-6278-1-git-send-email-michaelc@cs.wisc.edu>
	 <1210295734-6278-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:42756 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYEIO5n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 10:57:43 -0400
Received: by fg-out-1718.google.com with SMTP id 19so854150fgg.17
        for <linux-scsi@vger.kernel.org>; Fri, 09 May 2008 07:57:41 -0700 (PDT)
In-Reply-To: <1210295734-6278-2-git-send-email-michaelc@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Fri, May 9, 2008 at 3:15 AM,  <michaelc@cs.wisc.edu> wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> If the ping tmo is longer than the recv tmo then we could miss a window
> where we were supposed to check the recv tmo. This happens because
> the ping code will set the next timeout for the ping timeout, and if the
> ping executes quickly there will be a long chunk of time before the
> timer wakes up again.
>
> This patch has the ping processing code kick off a recv
> tmo check when getting a nop in response to our ping.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Hello Mike,

Did you already consider to submit this patch for inclusion in a
2.6.25.x stable release ? See also
Documentation/stable_kernel_rules.txt for the details.

Bart.
