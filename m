From: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: aic79xx problems
Date: Fri, 21 Sep 2007 11:16:52 +1000
Message-ID: <646765f40709201816v7d60cfbem8d348238db5e6b11@mail.gmail.com>
References: <20070920130440.GE1606@loop.mdy.univie.ac.at>
	 <1190297751.3360.15.camel@localhost.localdomain>
	 <20070920143448.GF1606@loop.mdy.univie.ac.at>
	 <1190299275.3360.22.camel@localhost.localdomain>
	 <20070920145336.GH1606@loop.mdy.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.226]:3410 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbXIUBQy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 21:16:54 -0400
Received: by nz-out-0506.google.com with SMTP id s18so586417nze
        for <linux-scsi@vger.kernel.org>; Thu, 20 Sep 2007 18:16:53 -0700 (PDT)
In-Reply-To: <20070920145336.GH1606@loop.mdy.univie.ac.at>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Boresch <stefan@mdy.univie.ac.at>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On 9/21/07, Stefan Boresch <stefan@mdy.univie.ac.at> wrote:
>
> I will try, but a very dumb question first. If I have a kernel that
> crashes because of a disk problem ..., how do I get to save the output?
> (Never worked with a serial console, but there might be a first time
> for everything ...) But maybe there is an obvious solution that I overlook?
>
> Or should I just try to watch and look for certain messages (ordering of
> messages), which given the huge amount of output seems a bit daunting ...

Ok, in response to your dumb question, an answer from another dumb user: (me)

Firstly, serial consoles aren't that difficult to set up - all you
need is a null modem cable and suitable software on the other end.
Then ensure that it's built in and pass "console=ttyS0" (or
"console=ttyS1" if you're using serial port #2) when you boot.

There is a network console - but I'm not sure whether that is useful
for boot messages.

Hope that helps =)

--

Julian Calaby

Email: julian.calaby@gmail.com
