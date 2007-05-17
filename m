From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 23:11:10 +0530
Message-ID: <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com>
References: <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
	 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	 <17841.simon.1179228389@5ec7c279.invalid>
	 <20070515120228.GI10562@parisc-linux.org>
	 <4649E03A.1090004@simon.arlott.org.uk>
	 <20070515172905.GJ10562@parisc-linux.org>
	 <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
	 <20070516025121.GK10562@parisc-linux.org>
	 <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com>
	 <20070517172023.GL10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:52512 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759226AbXEQRlM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 13:41:12 -0400
Received: by wr-out-0506.google.com with SMTP id 76so700710wra
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2007 10:41:11 -0700 (PDT)
In-Reply-To: <20070517172023.GL10562@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

On 5/17/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Thu, May 17, 2007 at 10:43:06PM +0530, Satyam Sharma wrote:
> > >No, it does matter.  Your suggestion doesn't work, because
> > >/sys/module/scsi_mod/parameters/ belongs to the module code.  To create
> > >a new attribute there, you use the module_param() code -- and there's
> > >no way to have code called when your parameter is changed.
>
> (thanks, Roland for pointing out that I'm incorrect about code being
> called)

> Come up with a sensible suggestion, and I'll listen to you.  Code isn't
> the issue.  API is the issue.

Well, that itself is a suggestion.

> > Ok, thanks for pointing out that /sys/module/scsi_mod/parameters/wait...
> > is _wrong_. Could you suggest something that would be _right_?
>
> No, I can't, which is why I find it hard to like the idea of "use
> sysfs".  I have no particular love for using a module like this, but
> my preferred way (a new verb for /proc/scsi/scsi) isn't liked by others.

Another command to /proc/scsi/scsi isn't a bad thought at all, considering
we're not _inventing_ a *new* /proc/not-related-to-processes interface, but
simply extending one that already exists. But then James / others are also
somewhat justified in shooting that down. I bet a lot of people would find
that even worse than this whole module affair.
