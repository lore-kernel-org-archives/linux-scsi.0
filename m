From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: megaraid_sas: which patches are needed for 2.6.32.y?
Date: Sun, 25 Nov 2012 01:47:04 -0800
Message-ID: <20121125094704.GB30132@elie.Belkin>
References: <FB09F9AF3FE25444B277AA82BB35EE175F028482@LCHQEX03.lancope.local>
 <20120329165806.GC3147@burratino>
 <FB09F9AF3FE25444B277AA82BB35EE175F0284E2@LCHQEX03.lancope.local>
 <20120329194751.GG3147@burratino>
 <20120609164753.GA18761@burratino>
 <20120624151318.GA18451@burratino>
 <CAHtARFH=kmVO_xWs+DafPuWd+wPFnP-Cw5vTVRR-Pd3+xDxkzw@mail.gmail.com>
 <20120628202743.GA7295@burratino>
 <CAHtARFHafR+hrB4u=wDUSE3-J2uXOQCFHW3wRSQMiebowu-9iA@mail.gmail.com>
 <20121029115049.GA28465@elie.Belkin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46225 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2KYJrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Nov 2012 04:47:10 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7349758pbc.19
        for <linux-scsi@vger.kernel.org>; Sun, 25 Nov 2012 01:47:09 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121029115049.GA28465@elie.Belkin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, Buford Peek <BPeek@lancope.com>, 666108@bugs.debian.org, Gator_Yin@dell.com, linux-scsi@vger.kernel.org, Priyantha Bleeker <priyantha.bleeker@gmail.com>, Edward Konetzko <konetzed@gmail.com>

On Mon, Oct 29, 2012, Jonathan Nieder wrote:
> In June, adam radford wrote:
>> On Thu, Jun 28, 2012 at 1:27 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:

>>> If someone makes a backport of the patches marked [3] as well, would
>>> you be able to look over or test the combination?  That would be much
>>> appreciated.
[...]
>> Yes, I will be able to look over and/or test the combination.
[...]
> I've made a backport with all relevant patches I could find from the
> 3.0.y tree and put the patches and a built package at
>
>   http://alioth.debian.org/~jrnieder-guest/temp/driver-test/
>
> Patches are against 2.6.32.y.

Gentle ping.  LSI folks, would it make sense for Debian to apply this
series to their 2.6.32.y-based kernel?  Would some other format (a git
tree instead of the current "git am"-ready patch series) be easier to
review?

Thanks for your kindness,
Jonathan
