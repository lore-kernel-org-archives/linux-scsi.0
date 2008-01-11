From: "Filippos Papadopoulos" <psybases@gmail.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Fri, 11 Jan 2008 18:44:23 +0200
Message-ID: <9f00bd9d0801110844g176acdcdle0331783f82ed866@mail.gmail.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <476C1472.1040103@redhat.com>
	 <1198271036.3130.60.camel@localhost.localdomain>
	 <476C4177.3030902@redhat.com>
	 <1198277391.3130.73.camel@localhost.localdomain>
	 <9f00bd9d0801031618l324e9078i56b0679a35e27f69@mail.gmail.com>
	 <1200028577.5337.8.camel@localhost.localdomain>
	 <9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com>
	 <1200066295.3286.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:17051 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbYAKQo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 11:44:26 -0500
Received: by wx-out-0506.google.com with SMTP id h31so749621wxd.4
        for <linux-scsi@vger.kernel.org>; Fri, 11 Jan 2008 08:44:25 -0800 (PST)
In-Reply-To: <1200066295.3286.19.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

On Jan 11, 2008 5:44 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> >
> > I havent reported "initio: I/O port range 0x0 is busy."
>
> Sorry ... we appear to have several reporters of different bugs in this
> thread.  That message was copied by Chuck Ebbert from a Red Hat
> bugzilla ... I was assuming it was the same problem.
>
> > I applied the patch on 2.6.24-rc6-git9 but unfortunatelly same thing happens.
>
> First off, has this driver ever worked for you in 2.6?  Just booting
> SLES9 (2.6.5) or RHEL4 (2.6.9) ... or one of their open equivalents to
> check a really old kernel would be helpful.  If you can get it to work,
> then we can proceed with a patch reversion regime based on the
> assumption that the problem is a recent commit.

Yes it works under 2.6.16.13.  See the beginning of this thread, i
mention there some things about newer versions.

>
> Thanks,
>
> James
>
>
>
