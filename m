From: "Grant Grundler" <grundler@google.com>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Wed, 26 Mar 2008 10:03:08 -0700
Message-ID: <da824cf30803261003i690f108dh86ff846e4f5fd2fa@mail.gmail.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	 <1204848652.3062.100.camel@localhost.localdomain>
	 <200803101519.m2AFJCJS032509@colby.verdasys.com>
	 <1205163386.2941.14.camel@localhost.localdomain>
	 <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
	 <200803252343.m2PNh8kl020506@colby.verdasys.com>
	 <da824cf30803251712t801fdaexc19ba4fe8130ee2e@mail.gmail.com>
	 <200803260217.m2Q2HsiU023202@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:57356 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbYCZRDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Mar 2008 13:03:16 -0400
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id m2QH39qi021133
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2008 10:03:09 -0700
Received: from el-out-1112.google.com (elev27.prod.google.com [10.126.173.27])
	by zps35.corp.google.com with ESMTP id m2QH1nvk010336
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2008 10:03:09 -0700
Received: by el-out-1112.google.com with SMTP id v27so2059430ele.12
        for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2008 10:03:08 -0700 (PDT)
In-Reply-To: <200803260217.m2Q2HsiU023202@colby.verdasys.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Bejarano <beej@alum.mit.edu>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Mar 25, 2008 at 7:17 PM, Marc Bejarano <beej@alum.mit.edu> wrote:
> At 20:12 3/25/2008, Grant Grundler wrote:
>   >On Tue, Mar 25, 2008 at 4:43 PM, Marc Bejarano <beej@alum.mit.edu> wrote:
>
>  >>  having never played with blocktrace, i have no idea what it's
>   >>  capabilities are.  can it be used to record not just the IOs, but
>   >>  also their timings?  any other ideas?  i'm at a loss for how to turn
>   >>  my reproducible test case into something i can send to seagate for
>   >>  investigation.
>   >
>   >Yes and yes (I think). But by itself, it won't help since block
>   >trace tools don't generally do any data validation.
>
>  we've been successfully using md's mirror consistency-checking
>  capabilities to spot the corruption.

Oh? Have you been running disktest on the mirrors or the individual disks?
I was expecting the latter but wonder now.

>  if we can get an IO pattern
>  that reproduces the issue, we're golden.  if only we didn't other
>  things to do with our time that were actually productive for us
>  ;)  hopefully we'll be able to report back soon-ish with more.

*sigh* this can take a long time to track down. And you right that
getting the "magic" workload to reproduce is key.

>
>  if anybody else has helpful ideas, we're all ears.
>
>  thanks, grant!

welcome,
grant

>
>  marc
>
>
