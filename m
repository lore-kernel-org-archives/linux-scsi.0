From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: target userspace utils (rtsadmin) project is dysfunctional
Date: Fri, 09 Sep 2011 10:14:06 -0400
Message-ID: <4E6A1F2E.6080601@interlog.com>
References: <4E69BB29.2030800@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57415 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326Ab1IIOOT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2011 10:14:19 -0400
In-Reply-To: <4E69BB29.2030800@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Jerome Martin <jxm@risingtidesystems.com>, Nicholas Bellinger <nab@risingtidesystems.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 11-09-09 03:07 AM, Andy Grover wrote:
> Hi Jerome and Nick,
>
> I happened upon this website:
>
> http://www.theopensourceway.org/book/The_Open_Source_Way-How_to_tell_if_a_FLOSS_project_is_doomed_to_FAIL.html

I totted up 70 each for my open source packages so I
reckon that list should be taken with a large grain
of salt.

This one amused me:
  "Your code tries to install into /opt or /usr/local [ +10 points of FAIL ]"
Installing into /usr/local is the default for autotools.

> According to my calculations (available upon request), rtsadmin comes in
> at 220 points: "so much fail, your code should have its own reality TV
> show".
>
> I could also add some more like "primary developer never responds to
> email", "CLA discourages external contributions", and "uses executable
> name as corporate marketing tool".
>
> Admittedly rtsadmin is a nice piece of code, thanks btw, but your
> company is falling short of accepted standards for stewardship of a
> FLOSS project. Please tell me why we all wouldn't be better off if I
> forked rtsadmin tomorrow.

One reason from the above link:
   "Your code is a fork of another project [ +10 points of FAIL ]"
:-)

Doug Gilbert

